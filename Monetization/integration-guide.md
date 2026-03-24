# 🔌 Monetization Integration Guide

**This guide covers the architectural integration of ARCPurchasing into a Clean Architecture ARC Labs app. For API usage, see the [ARCPurchasing README](../../../ARCPurchasing/README.md) and [DocC GettingStarted guide](../../../ARCPurchasing/Documentation.docc/GettingStarted.md).**

---

## 🏗️ Pre-Code Setup

Before writing any Swift, set up the external services.

### Step 1: App Store Connect

1. Create your subscription group (e.g., "Premium")
2. Create subscription products within the group:
   - `com.yourapp.premium.monthly` — Monthly subscription
   - `com.yourapp.premium.annual` — Annual subscription
3. Set introductory offer (free trial) on each product
4. Add localized display names and descriptions
5. Wait for product status: **Ready to Submit**

> Products must be in "Ready to Submit" state before they appear in sandbox. "Waiting for Review" is sufficient.

### Step 2: RevenueCat Dashboard

1. Create a new Project for your app
2. Add iOS app → paste your App Store Connect API key or Bundle ID
3. Create an **Entitlement**: `premium` (or your chosen identifier — keep it simple)
4. Create an **Offering**: `default`
5. Within the offering, create **Packages**:
   - `$rc_annual` → maps to your annual product
   - `$rc_monthly` → maps to your monthly product
6. Attach both packages to the entitlement

### Step 3: Entitlement Naming

Choose your entitlement identifier carefully — it lives in your code and in RevenueCat and must match exactly.

**Recommendation**: Use a single `"premium"` entitlement rather than per-feature entitlements. This simplifies entitlement checking and makes pricing changes (adding/removing features to tiers) easier.

---

## 🏛️ Where ARCPurchasing Lives in Clean Architecture

ARCPurchasing is a **Data layer** dependency. It must never be imported directly in the Domain or Presentation layers.

```
┌─────────────────────────────────────────────────┐
│               Presentation Layer                 │
│  PaywallView / SubscriptionViewModel             │
│  Uses: HasPremiumEntitlementUseCase              │
│        PurchaseProductsUseCase                   │
└───────────────────┬─────────────────────────────┘
                    │ depends on (protocols only)
┌───────────────────▼─────────────────────────────┐
│                Domain Layer                      │
│  HasPremiumEntitlementUseCase                    │
│  PurchaseProductsUseCase                         │
│  PurchaseRepository (protocol)     ◄──────────  │
└───────────────────┬──────────────────────────── ┘
                    │ implements
┌───────────────────▼─────────────────────────────┐
│                 Data Layer                       │
│  ARCPurchaseRepository: PurchaseRepository       │
│  Wraps: ARCPurchaseManager (ARCPurchasing)        │
│  Import: ARCPurchasing                           │
└─────────────────────────────────────────────────┘
```

**Key rule**: Only the Data layer imports `ARCPurchasing`. Domain and Presentation interact through protocols you define.

---

## 📁 Recommended File Structure

```
Sources/
├── Domain/
│   ├── Repositories/
│   │   └── PurchaseRepository.swift       ← Protocol you define
│   └── UseCases/
│       ├── HasPremiumEntitlementUseCase.swift
│       ├── FetchProductsUseCase.swift
│       └── PurchaseProductUseCase.swift
│
├── Data/
│   └── Repositories/
│       └── ARCPurchaseRepository.swift    ← Wraps ARCPurchaseManager
│
└── Presentation/
    └── Features/
        └── Subscription/
            ├── View/
            │   └── PaywallView.swift      ← Uses ARCPaywallView (ARCPurchasingUI)
            └── ViewModel/
                └── SubscriptionViewModel.swift
```

---

## 🧩 Domain Layer — Define Your Protocol

```swift
// Domain/Repositories/PurchaseRepository.swift
// Does NOT import ARCPurchasing — only uses your own types

public protocol PurchaseRepository: Sendable {
    var isPremium: Bool { get async }
    func hasEntitlement(_ id: String) async -> Bool
    func purchase(_ productID: String) async throws
    func restorePurchases() async throws
}
```

---

## 🗃️ Data Layer — Wrap ARCPurchaseManager

```swift
// Data/Repositories/ARCPurchaseRepository.swift
import ARCPurchasing

public final class ARCPurchaseRepository: PurchaseRepository {
    private let manager = ARCPurchaseManager.shared

    public var isPremium: Bool {
        get async { await manager.hasEntitlement("premium") }
    }

    public func hasEntitlement(_ id: String) async -> Bool {
        await manager.hasEntitlement(id)
    }

    public func purchase(_ productID: String) async throws {
        let products = try await manager.fetchProducts(for: [productID])
        guard let product = products.first else { throw PurchaseRepositoryError.productNotFound }
        let result = try await manager.purchase(product)
        guard result.isSuccess else { throw PurchaseRepositoryError.purchaseFailed }
    }

    public func restorePurchases() async throws {
        try await manager.restorePurchases()
    }
}

enum PurchaseRepositoryError: Error {
    case productNotFound
    case purchaseFailed
}
```

---

## 🎯 Domain Layer — Use Cases

```swift
// Domain/UseCases/HasPremiumEntitlementUseCase.swift

public struct HasPremiumEntitlementUseCase {
    private let repository: PurchaseRepository

    public init(repository: PurchaseRepository) {
        self.repository = repository
    }

    public func execute() async -> Bool {
        await repository.hasEntitlement("premium")
    }
}
```

---

## 📊 Analytics Wiring

Implement `PurchaseAnalytics` (from ARCPurchasing) in your Data layer, routing events to your analytics provider (ARCMetrics, Firebase, TelemetryDeck, etc.):

```swift
// Data/Analytics/AppPurchaseAnalytics.swift
import ARCPurchasing

final class AppPurchaseAnalytics: PurchaseAnalytics {
    func track(_ event: PurchaseEvent) async {
        // Route to your analytics provider
        // See tools-references.md for event list
    }
}
```

Pass it during configuration:

```swift
await ARCPurchaseManager.shared.configure(
    with: PurchaseConfiguration(apiKey: "your_rc_key"),
    analytics: AppPurchaseAnalytics()
)
```

---

## 🖼️ Presentation Layer — Paywall UI

The Presentation layer can import `ARCPurchasingUI` directly (it's a UI component, like importing SwiftUI). It should **not** import the core `ARCPurchasing` module directly — all purchase actions go through Use Cases.

```swift
// Presentation/Features/Subscription/View/PaywallView.swift
import ARCPurchasingUI
import SwiftUI

struct PaywallView: View {
    var body: some View {
        ARCPaywallView(
            offeringIdentifier: nil,   // nil = RevenueCat default offering
            onDismiss: { /* dismiss */ },
            onPurchaseCompleted: { /* update UI state */ }
        )
    }
}
```

### Choosing the Right Paywall Presentation Pattern

| Pattern | API | Use When |
|---------|-----|---------|
| Full-screen sheet | `.presentARCPaywall(isPresented:)` | User taps "Upgrade" button |
| Auto-gate (entitlement check) | `.presentARCPaywallIfNeeded(entitlement:)` | Feature view that requires premium |
| Embedded footer | `.arcPaywallFooter()` | Always-visible upsell in a content list |

See [`paywall-patterns.md`](./paywall-patterns.md) for design guidance on which to use when.

---

## 🧪 Testing

Use `MockPurchaseProvider` (included in ARCPurchasing) to test domain and presentation layers without hitting RevenueCat:

```swift
// In your test target
import ARCPurchasingTests  // or access MockPurchaseProvider from ARCPurchasing

let mockRepository = MockPurchaseRepository()
mockRepository.isPremiumResult = true

let useCase = HasPremiumEntitlementUseCase(repository: mockRepository)
let result = await useCase.execute()
#expect(result == true)
```

For StoreKit testing in the simulator, see `Example/ARCPurchasingDemoApp/README.md` in the ARCPurchasing package.

---

## ✅ App Revenue Integration Checklist

### Pre-Development
- [ ] App Store Connect products created and in "Ready to Submit" state
- [ ] RevenueCat project configured with entitlements and offerings
- [ ] Entitlement identifier chosen and documented (`"premium"` recommended)
- [ ] `PurchaseRepository` protocol defined in Domain layer

### Implementation
- [ ] `ARCPurchaseManager.configure()` called in `App.init` (before any view appears)
- [ ] Only Data layer imports `ARCPurchasing`
- [ ] All `PurchaseResult` cases handled (`.success`, `.cancelled`, `.pending`, `.requiresAction`, `.unknown`)
- [ ] Restore Purchases accessible from Settings or Paywall
- [ ] Loading state shown while `isPurchasing == true`
- [ ] `PurchaseAnalytics` implementation wired up
- [ ] Unit tests written using `MockPurchaseProvider`

### Pre-Launch
- [ ] Sandbox purchase flow tested end-to-end on device
- [ ] Production RevenueCat API key in xcconfig (not hardcoded)
- [ ] Tested on all supported platforms (if multi-platform)
- [ ] App Store Review Guidelines §3.1 compliance verified (restore button, disclosure)
- [ ] Paywall reviewed against [`paywall-patterns.md`](./paywall-patterns.md) checklist

### Post-Launch
- [ ] RevenueCat Dashboard monitored for first 7 days
- [ ] Trial-to-paid conversion baseline established
- [ ] First pricing A/B test planned

---

## 🔗 Related Docs

- [`paywall-patterns.md`](./paywall-patterns.md) — High-conversion paywall design
- [`pricing-strategy.md`](./pricing-strategy.md) — Pricing model and localization decisions
- [`tools-references.md`](./tools-references.md) — RevenueCat dashboard and external tools
- [ARCPurchasing README](../../../ARCPurchasing/README.md) — Full API reference

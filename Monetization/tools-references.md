# 🔧 Monetization Tools & References

**Know your tools: RevenueCat is the operational hub for IAP, App Store Connect is the source of truth for products and subscriptions.**

---

## 📊 RevenueCat Dashboard

The RevenueCat Dashboard is the primary operations center for subscription analytics and management.

### Key Sections

| Section | What It Shows | When to Check |
|---------|--------------|---------------|
| **Overview** | MRR, Active Trials, New Customers, Churn | Daily / weekly |
| **Charts** | Detailed time-series for all metrics | Weekly review |
| **Customers** | Individual subscriber history, troubleshooting | When investigating a specific user issue |
| **Experiments** | A/B test results for offerings/prices | During active A/B tests |
| **Integrations** | Webhook and analytics connections | During initial setup |

### Metric Definitions

| Metric | Definition | Healthy Range |
|--------|-----------|---------------|
| **MRR** | Monthly Recurring Revenue (normalized) | Growing month-over-month |
| **Active Subscriptions** | Paid subscribers currently in billing period | — |
| **Active Trials** | Users in free trial, not yet charged | High = good top-of-funnel |
| **Trial Conversion Rate** | Trials → paid / total trials started | 25–40% |
| **Churn Rate** | Subscriptions cancelled / active subscriptions | < 5%/month |
| **New Customers** | First-time paying customers | Trend up |
| **Revenue** | Gross revenue before Apple's 15–30% cut | — |
| **Proceeds** | Net revenue after Apple's cut | MRR × ~0.7–0.85 |

---

## 🧪 A/B Testing with RevenueCat Experiments {#ab-testing}

RevenueCat Experiments let you test different Offerings (prices, trial lengths, package configurations) without an app update.

### Setup Steps

1. In RevenueCat Dashboard → **Experiments** → **Create Experiment**
2. Define **Control** (current offering) and **Treatment** (new offering)
3. Set enrollment percentage (recommend 50/50)
4. Set the enrollment criteria (new users only, or all users)
5. Activate experiment
6. Monitor in **Experiments** tab — wait for statistical significance (typically 2–4 weeks)

### What to Test

| Variable | Example | What You Learn |
|----------|---------|----------------|
| **Price point** | $4.99 vs $9.99/mo | Price elasticity |
| **Trial length** | 7-day vs 14-day trial | Trial-to-paid conversion |
| **Annual discount** | 40% off vs 60% off annual | Annual vs monthly uptake |
| **Offering structure** | Monthly-only vs Monthly+Annual | Package prominence effect |

### Reading Results

RevenueCat shows statistical confidence. Do not call a winner until p < 0.05 and you have at least 100 conversions per variant.

---

## 📱 App Store Connect — Subscription Management

App Store Connect is where products are defined. RevenueCat reads from it; it is the source of truth.

### Key Areas

| Area | Path | Purpose |
|------|------|---------|
| **In-App Purchases** | App → Features → In-App Purchases | Create consumables, non-consumables |
| **Subscriptions** | App → Features → Subscriptions | Create subscription groups and products |
| **Subscription Groups** | Under Subscriptions | Organize related products (user can only hold one from a group) |
| **Introductory Offers** | Per product → Introductory Offers | Set up free trials and reduced-price periods |
| **Promotional Offers** | Per product → Promotional Offers | Win-back campaigns for lapsed subscribers |
| **Offer Codes** | App → Features → Offer Codes | Promo codes for marketing campaigns |
| **Price Tiers** | Per product → Price | Base price and per-storefront overrides |

### Product Checklist (before going live)

- [ ] Products created in App Store Connect
- [ ] Products in **Ready to Submit** state (not just Approved)
- [ ] Subscription group configured (if using subscriptions)
- [ ] Introductory offer set up (if using free trial)
- [ ] Localized display names and descriptions for key markets
- [ ] App Store Review screenshot attached (if required)

---

## 🔗 PurchaseAnalytics Protocol Integration

ARCPurchasing's `PurchaseAnalytics` protocol lets you route purchase events to any analytics provider without changing the purchasing code.

```swift
// Domain layer — implement this protocol
final class MyAnalyticsProvider: PurchaseAnalytics {
    func track(_ event: PurchaseEvent) async {
        switch event {
        case .purchaseStarted(let productID):
            Analytics.logEvent("purchase_started", parameters: ["product_id": productID ?? ""])
        case .purchaseCompleted(let productID):
            Analytics.logEvent("purchase_completed", parameters: ["product_id": productID ?? ""])
        case .trialStarted(let productID):
            Analytics.logEvent("trial_started", parameters: ["product_id": productID ?? ""])
        default:
            Analytics.logEvent(event.name, parameters: [:])
        }
    }
}

// Usage
await ARCPurchaseManager.shared.configure(
    with: config,
    analytics: MyAnalyticsProvider()
)
```

### Available PurchaseEvents

| Event | When Fired |
|-------|-----------|
| `productsFetched` | Products loaded from store |
| `purchaseStarted` | User initiates a purchase |
| `purchaseCompleted` | Purchase succeeds |
| `purchaseFailed` | Purchase fails (includes error) |
| `purchaseCancelled` | User cancels |
| `restoreStarted` | Restore purchases initiated |
| `restoreCompleted` | Restore succeeds |
| `restoreFailed` | Restore fails |
| `trialStarted` | Free trial begins |
| `subscriptionRenewed` | Subscription auto-renews |
| `subscriptionCancelled` | Subscription cancelled |
| `subscriptionExpired` | Subscription expires |
| `entitlementGranted` | Entitlement becomes active |
| `entitlementRevoked` | Entitlement becomes inactive |
| `paywallPresented` | Paywall view appears |
| `paywallDismissed` | Paywall view dismissed |

**Integration options**: Firebase Analytics, Amplitude, TelemetryDeck, Mixpanel, or ARCMetrics.

---

## 🔔 Webhooks & Server-Side Validation

For apps with a backend that needs to verify subscription status:

1. RevenueCat Dashboard → **Integrations** → **Webhooks**
2. Add your server endpoint URL
3. Select events to receive (recommend: `INITIAL_PURCHASE`, `RENEWAL`, `CANCELLATION`, `EXPIRATION`, `BILLING_ISSUE`)
4. Verify the webhook signature in your server handler

**When you need webhooks**: High-value content access, server-side entitlement enforcement, unlocking server resources on purchase.

**When you don't**: Client-only apps where `ARCPurchaseManager.hasEntitlement` is sufficient.

---

## 📚 Official Documentation Links

| Resource | URL |
|----------|-----|
| RevenueCat Docs | https://www.revenuecat.com/docs |
| RevenueCat SDK (iOS) | https://www.revenuecat.com/docs/ios |
| RevenueCat Experiments | https://www.revenuecat.com/docs/experiments-v1 |
| StoreKit 2 (Apple) | https://developer.apple.com/storekit/ |
| App Store Review Guidelines §3.1 | https://developer.apple.com/app-store/review/guidelines/#payments |
| Human Interface Guidelines — In-App Purchase | https://developer.apple.com/design/human-interface-guidelines/in-app-purchase |
| Subscription Offer Codes | https://developer.apple.com/app-store/subscriptions/#offer-codes |

---

## 🔗 Related Docs

- [`paywall-patterns.md`](./paywall-patterns.md) — Paywall design principles
- [`pricing-strategy.md`](./pricing-strategy.md) — Pricing models and localization
- [`integration-guide.md`](./integration-guide.md) — Wiring ARCPurchasing into your app

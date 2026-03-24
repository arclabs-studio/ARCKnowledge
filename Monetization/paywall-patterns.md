# 💰 Paywall Design Patterns

**High-conversion paywalls show value before asking for payment and make upgrading feel natural, not coercive.**

---

## 🎯 Core Principle: Value Before Ask

Users convert when they've already experienced enough value to justify the cost. A paywall shown too early feels like a toll gate; one shown at the right moment feels like a natural next step.

```
User Journey
─────────────────────────────────────────────────────────
Onboarding  →  Core Feature  →  Aha Moment  →  Paywall
                                    ↑
                             Optimal trigger
```

**Rule**: Show the paywall after the user has experienced the core value proposition at least once.

---

## ⏱️ Paywall Timing

### Aha-Moment Triggers (Recommended)

The best time to show a paywall is immediately after a user experiences a "wow" moment:

| App Type | Aha Moment | Paywall Trigger |
|----------|-----------|-----------------|
| Productivity | First completed task / doc created | After save success |
| Media / content | Consumed 2-3 pieces of content | On next content tap |
| Utility | First successful use of core feature | On second use attempt |
| Fitness | First completed workout | At session end screen |
| Social | First content share or meaningful interaction | After share completes |

### Timing Anti-Patterns to Avoid

- **On first launch** — user has no context for the value yet
- **On every session** — trains users to dismiss without reading
- **After a failure state** — feels punitive rather than aspirational
- **Mid-task interruption** — causes frustration and abandonment

---

## 🚪 Paywall Types

### 1. Full-Screen Modal (Highest Conversion, Highest Friction)

Best for: feature unlocks, premium tier upsell, post-aha-moment

```
┌─────────────────────────────┐
│        Hero Image           │
│                             │
│   "Unlock Premium Features" │
│                             │
│  ✓ Feature A                │
│  ✓ Feature B                │
│  ✓ Feature C                │
│                             │
│  [ Start Free Trial ]       │
│  [ $9.99/mo ]               │
│  Restore · Terms · Privacy  │
└─────────────────────────────┘
```

**ARCPurchasingUI**: `ARCPaywallView` or `.presentARCPaywall(isPresented:)`

### 2. Contextual Feature Gate (Medium Friction, High Intent)

Best for: gating specific premium features in context

```
┌─────────────────────────────┐
│  [Tap premium feature]      │
│                             │
│  🔒 This is a Premium       │
│     Feature                 │
│                             │
│  [ Upgrade to Unlock ]      │
└─────────────────────────────┘
```

**ARCPurchasingUI**: `.presentARCPaywallIfNeeded(entitlement:)` — automatically presents only when the user lacks the entitlement.

### 3. Footer / Embedded (Low Friction, Lower Conversion)

Best for: persistent upsell without interrupting the main flow; works well in content lists

```
┌─────────────────────────────┐
│  Content Area               │
│                             │
│  (your view continues here) │
│                             │
├─────────────────────────────┤
│ 🔒 Unlock All  [ $9.99/mo ] │
└─────────────────────────────┘
```

**ARCPurchasingUI**: `.arcPaywallFooter()` — iOS only.

### 4. Onboarding Gate (Subscription-First Model)

Best for: apps with no meaningful free tier; typically used in media/streaming

Present during onboarding after demonstrating value with a preview or demo. Use only when the entire app requires a subscription to function.

---

## 🧱 Soft Gate vs Hard Gate

| Type | Description | Conversion | Retention |
|------|------------|------------|-----------|
| **Soft gate** | Feature accessible after dismissing paywall | Lower | Higher — user builds habit first |
| **Hard gate** | Feature completely blocked | Higher | Lower — frustrated users churn |

**Recommendation**: Default to **soft gates**. Reserve hard gates for content that truly has no free equivalent (e.g., streaming media, professional tools without free tier).

---

## 🎨 High-Conversion Design Principles

### 1. Lead with Outcomes, Not Features

```
❌ "Export to PDF"
✅ "Share polished reports in seconds"
```

### 2. Anchor with the Annual Price

Show annual pricing prominently, monthly as secondary. Users perceive annual as better value when shown the equivalent daily/monthly breakdown:

```
  Most Popular
  ┌──────────────────────┐
  │  Annual — $49.99/yr  │  ← Primary CTA
  │  ($4.17/month)       │
  └──────────────────────┘
  Monthly — $9.99/mo
```

### 3. Free Trial Emphasis

When offering a free trial, make it the hero — not the price:

```
✅ "Try Free for 7 Days"   (then $49.99/year)
❌ "$49.99/year"            (includes 7-day free trial)
```

### 4. Social Proof

Include a rating or review count if your app has strong ratings:
- "Loved by 50,000+ users"
- "4.8 ★ App Store Rating"

### 5. Visible Legal Requirements (Required)

Always display prominently and accessibly:
- Auto-renewal disclosure
- Restore Purchases button
- Terms of Service and Privacy Policy links

---

## ✅ Paywall Review Checklist

Before shipping any paywall screen:

- [ ] Clear value proposition visible without scrolling
- [ ] Primary CTA is prominent and action-oriented ("Start Free Trial", not "Subscribe")
- [ ] Annual option shown as the default / most prominent
- [ ] Free trial period displayed clearly
- [ ] Price including currency shown (required by App Store guidelines)
- [ ] Auto-renewal disclosure present
- [ ] Restore Purchases accessible (required by App Store guidelines §3.1.1)
- [ ] Terms of Service and Privacy Policy links present
- [ ] Loading state handled during purchase processing
- [ ] Dismissal / close button accessible (required)
- [ ] VoiceOver labels set on all interactive elements
- [ ] Dark mode tested

---

## 🔗 Related Docs

- [`pricing-strategy.md`](./pricing-strategy.md) — Choosing the right pricing model and localization
- [`integration-guide.md`](./integration-guide.md) — Wiring ARCPurchasing into your app's architecture
- [ARCPurchasing README](../../Packages/ARCPurchasing/README.md) — API reference for `ARCPaywallView` and modifiers

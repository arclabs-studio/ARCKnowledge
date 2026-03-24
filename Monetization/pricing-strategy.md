# 💵 Pricing Strategy

**Choose a business model that matches your app's value delivery rhythm, then price for your target market — not your home market.**

---

## 🗂️ Business Model Decision Matrix

| Model | Best When | Risk | Example |
|-------|-----------|------|---------|
| **Freemium** (free + IAP) | Large top-of-funnel, viral potential, feature depth varies | Low free-to-paid conversion if free tier is too generous | Notes, Task managers |
| **Subscription** | Ongoing value delivery (content, sync, AI, updates) | Churn; requires constant value justification | Streaming, Fitness, AI tools |
| **Premium** (paid upfront) | Finite, complete utility; professional niche | Discovery is harder; no recurring revenue | Utilities, Games, Pro tools |
| **Consumable** | Renewable resources (credits, tokens, boosts) | Revenue spikes, hard to predict MRR | AI token packs, In-game currency |

### Decision Framework

```
Does the app deliver ongoing value over time?
├── YES → Is the value content-based or feature-based?
│          ├── Content (media, news, AI) → Subscription
│          └── Features (sync, export, cloud) → Subscription or Freemium
└── NO  → Is the utility deep enough to justify upfront payment?
           ├── YES (professional tool) → Premium
           └── NO (broad consumer) → Freemium with IAP
```

**ARC Labs default**: Freemium with annual subscription. Provides discoverability (free download) + predictable revenue (subscription).

---

## 📊 Subscription Pricing Structure

### Annual vs Monthly

The annual plan is your most important SKU. It improves cash flow, reduces churn, and is preferred by power users.

| Metric | Monthly | Annual | Target Ratio |
|--------|---------|--------|-------------|
| Price example | $9.99/mo | $49.99/yr | 58% discount |
| Churn rate | ~7–15%/mo | ~2–5%/yr | — |
| LTV | Lower | 2–3× higher | — |
| % of subscribers on annual | — | — | **60–70%** |

**Anchor pricing**: Show monthly equivalent of annual plan. `$49.99/year = $4.17/month` frames the annual price as a bargain against the monthly.

### Introductory Offers

| Type | Description | Best For |
|------|------------|---------|
| **Free Trial** | Full access, no charge for N days | High-engagement apps where users need time to form habits |
| **Pay As You Go** | Reduced price for first N periods | Price-sensitive markets |
| **Pay Up Front** | One-time reduced price unlocks subscription | Seasonal promotions |

**Recommendation**: Default to a **7-day free trial** for subscription apps. It's the industry standard and sets clear expectations.

---

## 🌍 Localized Pricing

### Why Localize

The US App Store price tier does not translate to fair pricing in other markets. A $9.99/mo subscription represents a very different percentage of disposable income in Brazil vs Germany.

### App Store Price Tiers

Apple provides localized price tiers in App Store Connect. Use them:

- **Tier-based**: Apple auto-converts your base price. Simplest option.
- **Manual overrides**: Set custom prices per storefront. Use for major markets (DE, JP, BR, IN).

### Recommended Regional Adjustments

Start with the US price as the baseline:

| Region | Relative Price | Notes |
|--------|----------------|-------|
| USA | 1.0× | Baseline |
| Western Europe (DE, FR, GB) | 0.9–1.1× | Parity |
| Japan | 0.7–0.9× | Use Apple's JPY tiers |
| Brazil | 0.3–0.5× | Significant purchasing power difference |
| India | 0.15–0.25× | Apple manages INR pricing natively |
| Southeast Asia | 0.3–0.5× | Varies significantly by country |

**Tool**: Use RevenueCat Experiments to A/B test pricing by country. See [`tools-references.md`](./tools-references.md#ab-testing).

### Offering Segmentation

Use RevenueCat Offerings to serve different price points to different markets without app updates:

```
Default Offering      → Global (USD base)
"brazil-offering"     → BRL-localized pricing
"india-offering"      → INR-localized pricing
```

---

## 📈 Key Metrics to Track

| Metric | Definition | Target |
|--------|-----------|--------|
| **Trial-to-Paid** | % of trial starters who convert | 25–40% |
| **Monthly Churn** | % of subscribers who cancel each month | < 5% |
| **Annual Churn** | % of annual subscribers who don't renew | < 20% |
| **ARPU** | Average Revenue Per User (all users) | Depends on model |
| **ARPPU** | Average Revenue Per Paying User | Depends on price point |
| **LTV** | Lifetime Value = ARPPU × avg subscription length | > 3× CAC |

**Minimum instrumentation**: Track trial starts, trial conversions, and cancellations via `PurchaseAnalytics`. See [`tools-references.md`](./tools-references.md) for RevenueCat Charts.

---

## 🔄 Freemium Tier Design

The free tier should be genuinely useful — not crippled — but clearly limited relative to premium.

| Approach | Example | Risk |
|----------|---------|------|
| **Feature gating** | Free: 3 projects, Premium: unlimited | Users who only need 3 never convert |
| **Usage limits** | Free: 10 exports/month, Premium: unlimited | Creates natural conversion trigger |
| **Quality ceiling** | Free: standard resolution, Premium: original | Works for media; feels arbitrary elsewhere |
| **Collaboration gating** | Free: solo use, Premium: sharing/teams | Viral growth driver |

**Recommendation**: Use **usage limits** where natural, **feature gating** for premium-only capabilities. Avoid making the free tier feel punishing.

---

## ✅ Pricing Strategy Checklist

- [ ] Business model chosen and justified against app's value delivery
- [ ] Annual plan is the primary / most promoted SKU
- [ ] Free trial period set (7 days recommended)
- [ ] Monthly-equivalent of annual plan displayed in UI
- [ ] Price localization reviewed for at least 5 major markets (US, EU, JP, BR, IN)
- [ ] Introductory offer configured in App Store Connect if using free trial
- [ ] RevenueCat Offerings set up to allow price changes without app update
- [ ] Analytics events wired to track trial-to-paid conversion

---

## 🔗 Related Docs

- [`paywall-patterns.md`](./paywall-patterns.md) — Designing high-converting paywall UI
- [`tools-references.md`](./tools-references.md) — RevenueCat Experiments for A/B price testing
- [`integration-guide.md`](./integration-guide.md) — Wiring multiple offerings into ARCPurchasing

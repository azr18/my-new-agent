# SOP: Advertising

**Owner:** Ariel (My New Agent) + Store Admin (Nomi)
**Frequency:** Continuous (pixel tracking), monthly (audience syncs), daily (performance pulls)
**Current Time per Cycle:** ~30 minutes/week manual (campaign management only)
**Tools Used:** Next.js storefront, Meta Pixel, Google Ads tag, n8n, Meta CAPI, Google Enhanced Conversions, Supabase, Recharts admin dashboard, Slack
**Starting Ad Budget:** Under $500/month

## Process Steps

| # | Step | Who | What They Do | Tool | Time | Automation Status |
|---|------|-----|-------------|------|------|-------------------|
| 1 | Customer browses site, pixels fire PageView/ViewContent/AddToCart events | System | Meta Pixel and Google Ads tag fire standard e-commerce events as the customer navigates, views products, and adds to cart. UTM parameters captured and persisted for session attribution. | Meta Pixel + Google Ads tag | Instant | Automated |
| 2 | Customer completes checkout, Purchase event fires client-side | System | Purchase event fires with order value, product data, and a generated event_id. fbp/fbc cookies read for server-side deduplication. | Meta Pixel + Google Ads tag | Instant | Automated |
| 3 | Checkout webhook triggers n8n workflow | System | Stripe/Supabase webhook fires, n8n Ad Conversion Tracker workflow picks it up | n8n | Instant | Automated |
| 4 | Server sends Purchase event to Meta CAPI | System | SHA-256 hashed email + event_id sent to Meta Conversions API. Platform deduplicates against client-side pixel using matching event_id. | n8n + Meta CAPI | Instant | Automated |
| 5 | Server sends Purchase event to Google Enhanced Conversions | System | Same hashed data sent to Google Enhanced Conversions endpoint. Conversion counted once via event_id dedup. | n8n + Google Enhanced Conversions | Instant | Automated |
| 6 | Quote submission triggers Lead event on both platforms | System | When a customer submits a custom quote request, Lead conversion event fires to both Meta CAPI and Google Enhanced Conversions with hashed contact data. | n8n | Instant | Automated |
| 7 | Monthly customer list sync to ad platforms | System | n8n Monthly Audience Sync workflow exports two segments from Supabase: all customers and high-value ($300+) customers. Lists uploaded to Meta Custom Audiences and Google Customer Match. | n8n + Supabase | ~5 min (runs overnight) | Automated |
| 8 | Admin triggers manual audience sync (optional) | Admin | Admin UI shows sync history and provides a manual trigger button for on-demand audience refresh. | Admin Dashboard | ~1 min | Manual (on-demand) |
| 9 | Daily ad performance data pulled from APIs | System | n8n Daily Performance Pull workflow fetches spend, impressions, clicks, conversions, and revenue from Meta and Google Ads APIs. Data written to ad_performance_daily table. | n8n + Meta/Google APIs + Supabase | ~2 min (runs overnight) | Automated |
| 10 | Performance displayed in admin dashboard | System | Recharts dashboard shows spend, revenue, ROAS, and campaign-level breakdown. Updated daily. | Admin Dashboard (Recharts) | — | Automated |
| 11 | Low-ROAS campaigns trigger Slack alert | System | If any campaign drops below ROAS threshold, a Slack notification fires with campaign name, spend, and ROAS. | n8n + Slack | Instant | Automated |
| 12 | Ariel reviews dashboard, adjusts campaigns | Ariel | Reviews ROAS data and Slack alerts, then makes budget/bid/targeting changes directly in Meta Ads Manager and Google Ads UI. | Meta Ads Manager + Google Ads UI | ~30 min/week | Manual |

**Pixel gating:** Environment variable gating ensures pixels only load when platform IDs are configured. No tracking code fires in development or staging.

**Privacy:** All personally identifiable data (emails) is SHA-256 hashed before leaving the server. No raw PII is sent to ad platforms.

**Database tables:** `ad_audience_sync_log` (tracks audience sync history and status) and `ad_performance_daily` (stores daily campaign metrics from both platforms).

**n8n Workflows:** Ad Conversion Tracker, Monthly Audience Sync, Daily Performance Pull.

**Version history:** All 4 phases shipped (v2.1). Phase 1: client-side tracking. Phase 2: server-side events. Phase 3: audience building. Phase 4: performance dashboard.

## Automation Opportunities

At $500/month ad spend, most campaign management stays manual on purpose. The math changes at higher budgets.

| Step(s) | Current State | Possible Automation | Impact |
|---------|--------------|---------------------|--------|
| 12 | Ariel reviews dashboard and adjusts campaigns in platform UIs (~30 min/week) | Rule-based auto-pause for campaigns below ROAS threshold (e.g., pause if ROAS < 1.0 for 3 consecutive days) | Saves ~10 min/week on obvious underperformers. Low risk since it only pauses, never increases spend. Worth building once ad budget exceeds $1,000/month. |
| 12 | Budget reallocation between campaigns is manual | Auto-shift budget toward highest-ROAS campaigns using platform APIs | Saves ~10 min/week. Higher risk at small budgets where sample sizes are noisy. Revisit at $2,000+/month when data is statistically meaningful. |
| 8 | Manual audience sync trigger exists as backup | Remove manual trigger, rely entirely on monthly automated sync | Minimal time savings (~1 min occasionally). Keep the manual trigger for now as a safety valve. |

## Annual Value Calculation

<!-- DRAFT PRICING — Input Assumptions:
     Hourly rate: $25/hr
     Pre-automation: manually uploading customer lists (~2 hrs/month), manually checking ad dashboards in two platforms (~1 hr/week), manually deduplicating conversions (~30 min/week), no server-side tracking (lost ~30% of conversions to browser blocking)
     Post-automation: audience syncs automated, unified dashboard replaces platform-hopping, dedup handled automatically, server-side tracking recovers blocked conversions
     Manual time eliminated: ~6.5 hrs/month
     Conversion recovery: server-side tracking recovers ~30% of conversions lost to ad blockers/browser privacy, improving ROAS optimization
-->

| Metric | Calculation | Annual Value |
|--------|------------|-------------|
| Labor Savings (audience management) | 2 hrs/month x $25 x 12 | **$600/year** |
| Labor Savings (dashboard consolidation) | 1 hr/week x $25 x 52 (checking two platforms separately, now one dashboard) | **$1,300/year** |
| Labor Savings (conversion dedup) | 0.5 hr/week x $25 x 52 (manual cross-referencing eliminated) | **$650/year** |
| Conversion Recovery (server-side tracking) | ~30% of conversions previously lost to ad blockers now tracked, improving optimization at $500/mo spend, est. 15% ROAS improvement = $75/mo additional revenue attribution | **$900/year** |
| **Total Annual Value (realized)** | | **$3,450/year** |
| **Recommended Setup Fee (25% of realized)** | | **$863** |

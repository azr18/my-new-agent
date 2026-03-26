# SOP: Order Fulfillment

**Owner:** Store Admin (Nomi)
**Frequency:** ~15 orders/week (cart checkout via Stripe + quote payments)
**Current Time per Cycle:** ~8 minutes manual (down from ~25 minutes pre-automation)
**Tools Used:** Next.js storefront, Supabase, Stripe, n8n, Resend, EasyPost, Xero, Admin Dashboard

## Process Steps

| # | Step | Who | What They Do | Tool | Time | Automation Status |
|---|------|-----|-------------|------|------|-------------------|
| 1 | Customer places order via Stripe checkout | Customer | Completes cart checkout or pays quote invoice | Stripe Checkout | — | Automated |
| 2 | Webhook fires, order created in Supabase | System | Stripe webhook triggers order record creation with line items, dimensions, and customer info | Supabase + Stripe webhook | Instant | Automated |
| 3 | Order confirmation email sent | System | Branded email with order summary, line items, and custom dimensions | n8n + Resend | Instant | Automated |
| 4 | Admin reviews order in dashboard | Admin | Opens admin dashboard, checks order details, dimensions, and any special notes | Admin Dashboard | ~2 min | Manual |
| 5 | Admin moves order to "processing" | Admin | Updates status (linear enforcement: paid → processing) | Admin Dashboard | ~1 min | Manual |
| 6 | Admin rate-shops carriers via EasyPost | Admin | Views rate comparison table (USPS, UPS, FedEx) with prices and delivery times | EasyPost API + Admin UI | ~3 min | Manual (tool-assisted) |
| 7 | Admin purchases shipping label | Admin | Selects carrier/service, clicks "Purchase Label" with confirmation dialog | EasyPost API | ~1 min | Manual (one-click) |
| 8 | Tracking number saved, status updates to "shipped" | System | EasyPost returns tracking number, saved to order, status auto-advances | Supabase + EasyPost | Instant | Automated |
| 9 | Shipped notification email with tracking link | System | Branded email triggered by status change to "shipped" | n8n + Resend | Instant | Automated |
| 10 | Admin marks order "delivered" | Admin | Updates status when delivery is confirmed | Admin Dashboard | ~1 min | Manual |
| 11 | Delivered email with care guide | System | Branded email triggered by status change to "delivered," includes tablecloth care instructions | n8n + Resend | Instant | Automated |
| 12 | Xero invoice created, payment recorded, fees tracked | System | Auto-creates Xero invoice, records Stripe payment, logs Stripe processing fees | Xero API + n8n | Instant | Automated |

**Status enforcement:** Orders follow a strict linear lifecycle (paid → processing → shipped → delivered). The system prevents skipping steps.

**Two purchase flows feed into this pipeline:** Standard cart checkout and quote-based payment. Both converge at Step 1 and follow the same fulfillment path from there.

**Version history:** Shipped v1.0-v1.4, v2.2 (shipping integration), v2.5 (admin dashboard fix).

## Automation Opportunities

These are the remaining manual steps. Further automation is possible but may not be worth the tradeoff in oversight.

| Step(s) | Current State | Possible Automation | Impact |
|---------|--------------|---------------------|--------|
| 4, 5 | Admin reviews order and moves to processing (~3 min) | Auto-advance to "processing" after a configurable delay, flag exceptions only | Saves ~3 min/order, but removes a human quality check. Worth revisiting once order volume exceeds 30/week. |
| 6, 7 | Admin picks carrier and buys label (~4 min) | Auto-select cheapest carrier meeting delivery SLA, auto-purchase label | Saves ~4 min/order. Requires confidence in weight estimation accuracy. Good candidate once EasyPost weight estimates are validated over 50+ shipments. |
| 10 | Admin marks delivered (~1 min) | Use carrier tracking API to auto-detect delivery and update status | Saves ~1 min/order. EasyPost supports delivery webhooks. Low-effort, high-value improvement. |

## Annual Value Calculation

<!-- DRAFT PRICING — Input Assumptions:
     Hourly rate: $25/hr
     Orders per week: 15
     Time saved per order (automation vs. fully manual): 17 minutes
     Fully manual process: ~25 min/order (email drafting, invoice creation, carrier website, tracking copy-paste)
     Current process with automation: ~8 min/order
     Remaining automatable time: ~8 min/order (steps 4-7, 10)
-->

| Metric | Calculation | Annual Value |
|--------|------------|-------------|
| Labor Savings (already realized) | (17 min x 15 orders/week) / 60 x $25 x 52 | **$5,525/year** |
| Labor Savings (additional, if remaining steps automated) | (8 min x 15 orders/week) / 60 x $25 x 52 | **$2,600/year** |
| Error Reduction (invoicing) | Manual Xero entry error rate ~5%, avg cost $50/error, 15 orders/week x 52, 90% reduction | **$1,755/year** |
| **Total Annual Value (realized)** | | **$7,280/year** |
| **Additional Value (if fully automated)** | | **$2,600/year** |
| **Recommended Setup Fee (25% of realized)** | | **$1,820** |

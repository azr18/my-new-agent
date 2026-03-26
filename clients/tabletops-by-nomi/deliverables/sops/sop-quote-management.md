# SOP: Quote Management

**Owner:** Store Admin (Nomi)
**Frequency:** ~5 quotes/week
**Current Time per Cycle:** ~9 minutes manual (down from ~29 minutes pre-automation)
**Tools Used:** Next.js storefront, Supabase, Stripe, n8n, Resend, Slack, Vercel Cron, Admin Dashboard

## Process Steps

| # | Step | Who | What They Do | Tool | Time | Automation Status |
|---|------|-----|-------------|------|------|-------------------|
| 1 | Customer submits quote request with dimensions | Customer | Fills out quote form with tablecloth dimensions and fabric preferences | Storefront form | — | Automated (form submission) |
| 2 | Quote confirmation email to customer | System | Branded email confirming the request was received | n8n + Resend | Instant | Automated |
| 3 | Slack notification to admin | System | Admin gets a Slack ping with quote details and a link to the admin dashboard | n8n + Slack | Instant | Automated |
| 4 | Admin reviews quote and checks dimensions | Admin | Opens quote in dashboard, verifies dimensions are reasonable, checks fabric availability | Admin Dashboard | ~5 min | Manual |
| 5 | Admin sets price and optional remarks | Admin | Enters price based on dimensions and fabric, adds any notes for the customer | Admin Dashboard | ~3 min | Manual |
| 6 | Admin approves or rejects | Admin | Clicks approve or reject button | Admin Dashboard | ~1 min | Manual |
| 7 | Approval email with payment link OR rejection email with reason | System | Approved: branded email with Stripe payment link (30-day expiry). Rejected: branded email with reason. | n8n + Resend + Stripe | Instant | Automated |
| 8 | Day 25 expiration reminder | System | If quote is still unpaid at day 25, customer gets a reminder email | Vercel Cron + n8n | Scheduled | Automated |
| 9 | Day 30 link expiration | System | Payment link is deactivated after 30 days | Vercel Cron | Scheduled | Automated |
| 10 | Customer pays via Stripe checkout link | Customer | Clicks payment link, completes Stripe checkout | Stripe Checkout | — | Automated |
| 11 | Order created, standard fulfillment begins | System | Payment triggers order creation in Supabase, enters the Order Fulfillment pipeline | Supabase + Stripe webhook | Instant | Automated |

**Security notes:**
- Quote amount is fetched server-side at checkout time. The frontend never controls the price.
- Payment tokens use base64url encoding to prevent ID enumeration. Customers cannot guess other quote payment links.

**Version history:** Shipped v1.1.

## Automation Opportunities

| Step(s) | Current State | Possible Automation | Impact |
|---------|--------------|---------------------|--------|
| 4, 5 | Admin manually reviews dimensions and sets price (~8 min) | Auto-price calculator based on dimension/fabric lookup table, with admin override for edge cases | Saves ~6 min/quote. Requires a pricing matrix. Good candidate once Nomi has standardized pricing for common sizes. |
| 6 | Admin manually approves/rejects (~1 min) | Auto-approve quotes under a dollar threshold or within standard size ranges | Saves ~1 min/quote for standard requests. Keep manual approval for custom or high-value quotes. |

## Annual Value Calculation

<!-- DRAFT PRICING — Input Assumptions:
     Hourly rate: $25/hr
     Quotes per week: 5
     Time saved per quote (automation vs. fully manual): 20 minutes
     Fully manual process: ~29 min/quote (email drafting, payment link creation, deadline tracking, follow-up reminders)
     Current process with automation: ~9 min/quote
     Remaining automatable time: ~7 min/quote (steps 4-6, with pricing calculator)
-->

| Metric | Calculation | Annual Value |
|--------|------------|-------------|
| Labor Savings (already realized) | (20 min x 5 quotes/week) / 60 x $25 x 52 | **$2,167/year** |
| Labor Savings (additional, if pricing calculator added) | (7 min x 5 quotes/week) / 60 x $25 x 52 | **$758/year** |
| Revenue Protection (expiration tracking) | Prevents forgotten quotes from going stale. Estimated 1 recovered quote/month at avg $200 | **$2,400/year** |
| **Total Annual Value (realized)** | | **$4,567/year** |
| **Additional Value (if pricing calculator added)** | | **$758/year** |
| **Recommended Setup Fee (25% of realized)** | | **$1,142** |

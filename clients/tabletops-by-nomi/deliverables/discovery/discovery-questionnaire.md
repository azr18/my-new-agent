# Discovery Session: Tabletops by Nomi

> This discovery document is pre-filled from our existing engagement. We built the Tabletops by Nomi e-commerce platform and automation infrastructure across 50 development phases. The answers below are sourced from the codebase, project documentation, and automation plans. A "Gaps" section at the end flags information we still need.

## About Your Business

**1. What does your company do, and how would you describe it to someone at a dinner party?**

Tabletops by Nomi is a bespoke table linen studio. Customers design custom tablecloths with precise dimensions, choose from multiple patterns and tiers, and receive handmade luxury products. Tagline: "Custom table linens for tables that gather families." Positioned for discerning hosts who have searched for the right tablecloth and could not find it.

**2. How many people are on your team, and who touches the processes you want to improve?**

Solo operator (Ariel). Handles everything: product management, order fulfillment, customer communication, advertising, accounting, and content. No employees. Potential future marketing hire mentioned in advertising PRD.

**3. What's your current revenue model?**

Per-unit e-commerce. Two sales channels:
- Standard cart checkout (Stripe) for catalog products. Tablecloths priced by fabric area (sq in) x tier level (1-3) + $25 custom fee. Napkins at $36, placemats at $48.
- Custom quote flow for oversized or specialty orders. Admin sets price, customer pays via Stripe checkout link with 30-day expiration.

Shipping: $19.99 standard, $39.99 express (flat rates, actual cost tracked per order for margin analysis via EasyPost).

**4. What tools and software do you use day-to-day?**

| Tool | Purpose |
|------|---------|
| Next.js 16 (Vercel) | Website and admin dashboard |
| Supabase | Database, auth, file storage, analytics events |
| Stripe | Payments, checkout, webhooks |
| n8n Cloud | 19 active workflows (email, finance, social, ads, blog) |
| Resend | Transactional and marketing email delivery |
| Xero | Accounting, invoicing, payment reconciliation |
| EasyPost | Multi-carrier shipping labels (USPS, UPS, FedEx) |
| Meta Graph API | Social media publishing, ad CAPI, audience sync |
| Google Ads API | Conversion tracking, Enhanced Conversions, audience sync |
| Slack | Admin notifications, alerts, social media approval queue |
| GA4 | Web analytics (dual-tracked with Supabase analytics) |

**5. If you could wave a magic wand and fix one thing about how your business runs, what would it be?**

Based on the unbuilt automation pillars: customer lifecycle marketing (no post-purchase sequences, win-back emails, or VIP segmentation) and financial reporting (no automated P&L visibility, expense tracking, or margin analysis). The transactional and operational side is well-automated. The growth and financial intelligence side is not.

**6. What does a good month look like vs. a bad month?**

Not documented in repo. See Gaps section.

**7. Have you tried to automate or improve any of these processes before?**

Yes, extensively. 50 phases of automation shipped across 16 milestones (v1.0 through v3.0). Starting point was a raw Next.js storefront with no email, no accounting integration, and manual everything. Current state: near-full automation of order processing, customer communication, finance, social media, advertising, and content.

**8. What would success look like 90 days after we finish this project?**

For the remaining unbuilt pillars: automated post-purchase email sequences driving repeat purchases, seasonal campaign automation accounting for 2-4 week production lead times, real-time financial dashboards showing per-product profitability and cash flow.

## Your Processes

**9. Walk me through the order fulfillment process from trigger to final step.**

1. Customer adds items to cart, proceeds to checkout (Stripe)
2. Stripe webhook fires on successful payment
3. n8n Order Confirmation workflow sends branded email with order details, line items, dimensions
4. Order appears in admin dashboard with status "paid"
5. Admin reviews order, moves to "processing" (linear status enforcement)
6. Admin uses EasyPost integration to rate-shop carriers, purchase shipping label
7. Label purchase auto-saves tracking number, updates status to "shipped"
8. n8n Order Status workflow sends shipped email with tracking link
9. Admin marks as "delivered" (manual, no carrier API polling)
10. n8n sends delivered email with care guide
11. n8n Xero Invoice Sync creates invoice, records Stripe payment, tracks fee as expense

**10. Who does each step?**

Ariel (solo operator) handles steps 5-6 and 9 manually. Everything else is automated via n8n workflows and database triggers.

**11. What tools do you use at each step?**

Steps 1-4: Next.js app, Stripe, Supabase, n8n, Resend. Steps 5-9: Admin dashboard, EasyPost, n8n. Step 11: n8n, Xero.

**12. How long does each step take?**

Manual steps: Order review (~2 min), shipping label purchase (~3 min via rate comparison UI), marking delivered (~1 min). Everything else is instant (automated).

**13. What goes wrong most often?**

Previously: tracking number state sync issues between EasyPost label purchase and admin UI (fixed in v2.5 with belt-and-suspenders approach). Previously: Stripe metadata exceeding 500-char limit for custom dimensions (fixed with pipe-delimited format). Current: occasional Xero API rate limits handled by exponential backoff.

**14. When something goes wrong, how do you find out?**

Slack alerts for: Xero sync failures (3 consecutive failures in 1 hour), low-ROAS ad campaigns, social media token expiry. n8n error monitoring workflow for Xero. Manual review for order processing issues via admin dashboard.

**15. Are there steps where someone is basically just copying data from one place to another?**

Not anymore. All data handoffs are automated: Stripe to Supabase (webhooks), Supabase to n8n (webhooks/triggers), n8n to Xero (API), n8n to Resend (API), n8n to Meta/Google (API). Before automation, order data was manually exported to spreadsheets/accounting.

**16. Is any part of this process different depending on the customer, order type, or time of year?**

Yes. Cart checkout vs. quote payment follow different paths (webhook routing by metadata.source). Tablecloth pricing uses tier-based calculation while non-tablecloths use flat base_price. Custom orders (oversized) redirect to quote request flow. Seasonal patterns exist but no automated campaign system yet (unbuilt marketing pillar).

## E-commerce Specifics

**23. How many orders do you process per day, and what's your peak vs. slow period?**

Not documented in repo. See Gaps section.

**24. What platform are you on?**

Custom-built Next.js 16 + Supabase + Stripe. Not a hosted platform (Shopify, etc.). Full codebase control.

**25. How does order data get from your store to your fulfillment process?**

Automated pipeline: Stripe checkout completion fires webhook to Next.js API, which creates order in Supabase, which triggers n8n workflows via pg_net database triggers. Admin sees orders immediately in admin dashboard.

**26. How do you keep inventory in sync across channels?**

Single channel (own website). No multi-channel complexity. No inventory management system (made-to-order model, no physical inventory to track).

**27. What does your customer communication look like after purchase?**

Fully automated via n8n + Resend:
- Order confirmation (immediate, includes line items and dimensions)
- Shipped notification (on status change, includes tracking link)
- Delivered notification (on status change, includes care guide)
- Newsletter welcome drip (5 emails over ~2 weeks for subscribers)

No post-purchase follow-up sequences, review requests, or win-back emails yet (unbuilt marketing pillars).

**28. How do you handle returns and refunds?**

Refunds processed via Stripe. n8n creates Xero credit notes (ACCRECCREDIT type) automatically. No formal returns workflow or RMA system documented.

## Gaps (Information Not in the Repo)

These items are not captured in the codebase or planning documents:

1. **Monthly order volume and revenue figures.** Needed for accurate ROI calculations on remaining automation opportunities.
2. **Customer acquisition cost (CAC).** The advertising dashboard tracks spend and ROAS, but baseline CAC before paid ads is unknown.
3. **Average order value (AOV).** Stripe data exists but not summarized in docs.
4. **Repeat purchase rate.** No customer lifecycle data captured. How many customers buy more than once?
5. **Production cost per unit.** Needed for profit margin analysis (unbuilt finance pillar). What does it cost to produce a custom tablecloth?
6. **Monthly operating expenses.** Beyond tool costs ($46 Xero, n8n, etc.), what are the fixed and variable costs?
7. **Growth targets.** What revenue or order volume is Ariel targeting for the next 6-12 months?
8. **Which unbuilt pillars are highest priority?** The marketing plan has 5 unbuilt pillars, finance has 7. Which matter most right now?

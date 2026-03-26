# Internal Profile: Tabletops by Nomi

**Status:** Case Study (Retrospective)
**Created:** 2026-03-25
**Last Updated:** 2026-03-25

## Contact
- **Primary Contact:** Nomi Rubinstein
- **Email:** nomi@tabletopsbynomi.com
- **Phone:** 305-467-7888

## Company Info
- **Name:** Tabletops by Nomi
- **Industry:** Luxury E-commerce (custom tablecloths and table linens)
- **Size:** Solo operator (Ariel, owner/operator)
- **Revenue Model:** Direct-to-consumer e-commerce. Two purchase flows: standard cart checkout (Stripe) and custom quote request flow for oversized/specialty orders. Pricing based on fabric area (sq in) + tier level (1-3) + $25 custom fee.
- **Tech Stack:** Next.js 16, Supabase (DB + Auth + Storage), Stripe (payments), n8n Cloud (workflow automation), Resend (email), Xero (accounting), EasyPost (shipping), Meta Graph API (social media + ads), Google Ads API (advertising), Vercel (hosting)
- **Website:** Custom-built platform, ~40,109 lines TypeScript

## Business Context
- Luxury positioning: "Custom table linens for tables that gather families"
- Products: Custom tablecloths (variable pricing by dimension/tier), napkins ($36), placemats ($48)
- Production lead time: 2-3 weeks + 3-7 business days shipping
- US-only market currently
- Brand aesthetic: Charcoal (#1a1a1a), Subtle Gold (#c6a87c), Playfair Display headlines, Geist Sans body

## What We Built (v1.0 through v3.0)
- **50 phases shipped** across 16 milestones (Jan 17 to Mar 5, 2026)
- **19 active n8n workflows** (12 transactional + 7 blog pipeline)
- **10 branded email templates** (auth, orders, quotes, newsletter, contact, account)
- Complete order-to-cash pipeline: customer places order, branded confirmation email, admin manages status, shipped/delivered notifications with tracking, Xero invoice + payment reconciliation
- Custom quote flow: request, admin review, approve/reject emails, payment link, order creation
- Shipping label automation: EasyPost multi-carrier rate shopping, one-click label purchase, auto tracking
- Finance automation: Xero integration for invoicing, payment reconciliation, Stripe fee tracking, refund credit notes, payout transfers
- Social media automation: AI content generation, multi-platform publishing (IG, FB), approval queue, chat handler, comment monitor
- Advertising infrastructure: Meta Pixel + Google Ads with full e-commerce event funnel, CAPI, Enhanced Conversions, audience sync, performance dashboard
- SEO blog pipeline: n8n generates Markdown content, Supabase Storage for images, ISR rendering
- Newsletter welcome drip: 5-email series with branded templates
- Admin dashboard: order management, quote management, shipping labels, ad performance, social analytics

## Pain Points (Remaining at Time of Case Study)
- Phase 50 (Brand & Docs Sync) not yet started: Instagram handle update site-wide, docs sync
- Marketing automation pillars 2-4, 6-7 unbuilt: customer lifecycle marketing, campaign automation, UGC/reviews, analytics dashboard, crisis communications
- Finance automation pillars 5-11 unbuilt: tax management, financial reporting, expense tracking, accounts payable, cash flow management, financial alerts, profit margin analysis
- Meta API tokens pending App Review approval
- Telegram bot for Quick Post workflow not yet configured

## Complexity Estimate
- **Number of processes mapped:** 7 major process areas
- **Integration points:** Supabase, Stripe, n8n Cloud, Resend, Xero, EasyPost, Meta Graph API, Google Ads API, Vercel, Slack
- **Estimated project size:** Large

## Status Checklist
- [x] Discovery questionnaire sent
- [x] Discovery session completed
- [x] SOPs documented
- [x] Process flows created
- [ ] Proposal sent (N/A, case study)
- [ ] Speaking notes prepared (N/A, case study)
- [ ] Proposal presented (N/A, case study)
- [ ] Contract signed (N/A, case study)

## Key n8n Workflows

| Workflow | Purpose | Milestone |
|----------|---------|-----------|
| Order Confirmation | Cart/quote checkout completion email | v1.0 |
| Order Status | Shipped/delivered notification emails | v1.0 |
| Quote Received | Quote submission confirmation | v1.1 |
| Quote Decision | Approve/reject/reminder emails | v1.1 |
| Contact Form | Inquiry confirmation + admin alert | v1.1 |
| Newsletter Welcome | 5-email welcome drip series | v1.1/v2.3 |
| Account Deletion | Deletion confirmation | v1.1 |
| Chatbot | Customer support AI | v1.4 |
| Xero Invoice Sync | Order to Xero invoice + payment | v1.6 |
| Xero Fee Expense | Stripe fee to Xero expense | v1.6 |
| Xero Payout Transfer | Stripe payout to bank transfer | v1.6 |
| Xero Error Monitoring | Failure alerting via Slack | v1.6 |
| Cluster SEO Post (+6 subs) | Blog content generation pipeline | v1.9 |
| Social Media Content | AI content creation + publishing | v2.0 |
| FB/IG Chat Handler | Two-tier KB+LLM customer chat | v2.0 |
| Comment Monitor | AI-suggested replies via Slack | v2.0 |
| Ad Conversion Tracker | Meta CAPI + Google Enhanced Conversions | v2.1 |
| Monthly Audience Sync | Customer lists to Meta/Google audiences | v2.1 |
| Daily Performance Pull | Ad spend/ROAS data collection | v2.1 |

## Notes
This is a retrospective case study, not a prospective client engagement. We built the entire platform and automation infrastructure. The repo (bynomi-bd) serves as the primary source of truth for all deliverables. Existing detailed automation plans in `.planning/` cover marketing (7 pillars) and finance (11 pillars), of which a subset was implemented.

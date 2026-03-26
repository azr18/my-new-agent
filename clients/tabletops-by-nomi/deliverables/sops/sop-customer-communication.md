# SOP: Customer Communication

**Owner:** Store Admin (Nomi) + Ariel (My New Agent)
**Frequency:** Continuous (transactional emails fire per event), daily (chatbot handles incoming messages)
**Current Time per Cycle:** ~15 minutes/week manual (Slack escalation replies only)
**Tools Used:** Next.js storefront, Supabase Auth, n8n, Resend, Vercel cron, Slack, Admin Dashboard

## Process Steps — Email Pipeline

| # | Step | Who | What They Do | Tool | Time | Automation Status |
|---|------|-----|-------------|------|------|-------------------|
| 1 | Trigger event occurs (signup, order, quote action, contact form, account deletion, etc.) | Customer/System | Customer takes an action or a system event fires (e.g., order status change, quote expiration approaching) | Various | — | Trigger |
| 2 | Webhook or cron trigger fires | System | Supabase webhook, n8n trigger, or Vercel cron job detects the event and initiates the email workflow | Supabase + n8n + Vercel cron | Instant | Automated |
| 3 | n8n routes to correct email template | System | Workflow logic matches the event type to one of 10 branded templates (see template list below) | n8n | Instant | Automated |
| 4 | Dynamic data injected into template | System | Customer name, order details, tracking numbers, quote specifics, payment links, or rejection reasons inserted into the template | n8n | Instant | Automated |
| 5 | Email sent via Resend API with 3x retry | System | Resend delivers the email. Failed sends retry up to 3 times before logging a failure. | Resend | Instant | Automated |
| 6 | Newsletter subscriber enters drip sequence | System | New subscribers receive a 5-email welcome series over ~2 weeks. Workflow ID: llbOhxXsOMCYHf3Z (25 nodes). | n8n + Resend | ~2 weeks (spaced) | Automated |
| 7 | Unsubscribe request processed | System | One-click unsubscribe via /unsubscribe/{token} route. Token-based (path segment, not query param). Subscriber flagged immediately. | Next.js + Supabase | Instant | Automated |

## Process Steps — Customer Support

| # | Step | Who | What They Do | Tool | Time | Automation Status |
|---|------|-----|-------------|------|------|-------------------|
| 1 | Customer sends message via FB/IG or website chatbot | Customer | Writes a question about products, orders, shipping, custom quotes, etc. | Facebook/Instagram/Website | — | Trigger |
| 2 | AI chatbot generates response | System | Two-tier matching: knowledge base lookup first, then LLM fallback if no good match. Covers product info, order status, shipping timelines, and custom quote process. | n8n chatbot workflow | Instant | Automated |
| 3 | No good match: message forwarded to Slack | System | If confidence is low or the question falls outside the knowledge base, the message routes to a Slack channel for human review. | n8n + Slack | Instant | Automated |
| 4 | Ariel reviews and replies via Slack bridge | Ariel | Reads the customer message in Slack, types a reply that gets sent back through the original channel (FB/IG/website). | Slack Reply Bridge (n8n) | ~5 min (as needed) | Manual |

**Kill switch:** AI chatbot responses can be disabled instantly via admin toggle. All messages route to Slack when the kill switch is active.

## Email Template Inventory

| Category | Template | Trigger | Delivery |
|----------|----------|---------|----------|
| Auth | Registration confirmation | New account created | Supabase Auth (branded) |
| Auth | Password reset | Password reset requested | Supabase Auth (branded) |
| Orders | Order confirmation | Checkout completed (Stripe webhook) | n8n + Resend |
| Orders | Shipped notification | Status changed to "shipped" | n8n + Resend |
| Orders | Delivered notification | Status changed to "delivered" | n8n + Resend |
| Quotes | Quote received confirmation | Quote form submitted | n8n + Resend |
| Quotes | Quote approved (with payment link) | Admin approves quote | n8n + Resend |
| Quotes | Quote rejected (with reason) | Admin rejects quote | n8n + Resend |
| Quotes | Expiration reminder | Quote approaching expiry | Vercel cron + n8n + Resend |
| Newsletter | Welcome email (first of 5-email drip) | Newsletter signup | n8n + Resend |
| Contact | Inquiry confirmation | Contact form submitted | n8n + Resend |
| Account | Deletion confirmation | Account deleted | n8n + Resend |

**Brand consistency:** All emails use Outfit font, gradient header (#2c3e50 to #34495e), container with border-radius 12px and box-shadow. Fabric is always referred to as "luxury synthetic material" (not linen, polyester, or satin). Patterns, not fabric choices. Production time: 2-3 weeks, shipping: 3-7 business days. All marketing emails include physical business address (CAN-SPAM compliance) and one-click unsubscribe.

**Social handles:** Instagram: @tableclothsbynomi. Facebook: facebook.com/tabletopsbynomi. (Site-wide update to correct Instagram handle pending, Phase 50.)

**n8n Workflows:** Newsletter Welcome, Contact Form, Account Deletion, Chatbot, FB/IG Chat Handler, Slack Reply Bridge.

**Version history:** Newsletter drip v2.3, restyled in v3.0 Phase 49. Unsubscribe URL fix (path segment). Fake testimonials removed. Material references corrected.

## Automation Opportunities

The email pipeline is fully automated. The main gap is in post-purchase engagement and recovery sequences.

| Area | Current State | Possible Automation | Impact |
|------|--------------|---------------------|--------|
| Post-purchase follow-up | Nothing after delivery email | "How's your tablecloth?" email 2 weeks after delivery, care tips reminder at 1 month | Builds repeat purchase relationship. Low effort to build (one n8n workflow, two templates). |
| Review requests | No review collection | Automated review request email 3 weeks after delivery with direct link to Google/site review | Social proof drives conversions. Even 10 reviews/month at a 5% conversion lift on $500/mo ad spend adds up. |
| Win-back emails | No re-engagement for lapsed customers | "We miss you" sequence for customers who haven't ordered in 6+ months, triggered by Supabase query | Reactivating even 2-3 customers/month at ~$150 avg order = $3,600-$5,400/year. |
| Cart abandonment | No recovery emails | Triggered email 1 hour after abandoned cart with direct link back to checkout | Industry average recovery rate is 5-10%. At 15 orders/week, even 1-2 recovered carts/week = $150-$300/week. |
| Personalized recommendations | No product suggestions | Post-purchase email with complementary products (e.g., matching runner for a tablecloth buyer) | Cross-sell opportunity. Depends on catalog depth. |
| Chatbot escalation | Slack bridge requires manual reply | Auto-respond with "We'll get back to you within X hours" and queue for batch reply | Reduces perceived wait time. Minimal build effort. |

## Annual Value Calculation

<!-- DRAFT PRICING — Input Assumptions:
     Hourly rate: $25/hr
     Pre-automation: manually writing and sending order/shipping/quote emails (~20 min each, ~15 orders/week + ~5 quotes/week), manually checking FB/IG messages (~30 min/day), manually onboarding newsletter subscribers
     Post-automation: all transactional emails automated, chatbot handles ~80% of customer messages, newsletter drip runs itself
     Orders per week: 15
     Quotes per week: 5
     Customer messages per day: ~10 (estimated)
     Chatbot resolution rate: ~80%
-->

| Metric | Calculation | Annual Value |
|--------|------------|-------------|
| Labor Savings (transactional emails) | 20 orders+quotes/week x 20 min each / 60 x $25 x 52 | **$8,667/year** |
| Labor Savings (chatbot, 80% auto-resolved) | 10 messages/day x 80% x 5 min each / 60 x $25 x 365 | **$6,083/year** |
| Labor Savings (newsletter management) | 2 hrs/month manual subscriber handling eliminated x $25 x 12 | **$600/year** |
| **Total Annual Value (realized)** | | **$15,350/year** |
| **Potential Value (if post-purchase sequences built)** | Cart abandonment recovery (1.5 carts/week x $150 x 52) + win-back (2.5 customers/month x $150 x 12) | **$16,200/year** |
| **Recommended Setup Fee (25% of realized)** | | **$3,838** |

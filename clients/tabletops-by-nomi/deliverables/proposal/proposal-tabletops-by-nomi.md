# Automation Proposal: Tabletops by Nomi

**Prepared by:** My New Agent (mynewagent.ai)
**Date:** March 25, 2026
**Version:** Draft

---

## Executive Summary

Over the past three months, we built and deployed 19 automated workflows across your entire business operation. Order confirmations, shipping labels, invoicing, social media, advertising, blog content, and customer communication now run with minimal manual intervention. The numbers speak for themselves: **$53,996/year in documented value** across seven process areas.

That covers the operational foundation. Your order-to-cash pipeline works. Your emails are branded and automated. Your accounting reconciles itself. Your social media publishes on schedule.

What is missing is the growth layer. You have no post-purchase sequences turning one-time buyers into repeat customers. No cart abandonment recovery (every abandoned checkout is lost revenue). No automated review collection building social proof. No financial dashboards showing per-product profitability. These are the next set of automations, and they are where the math gets interesting: **$24,765/year in additional value**, most of it tied directly to revenue.

---

## Work Delivered (Phases 1-50)

Before scoping the next phase, here is what is already running and the value it delivers:

| Process Area | Annual Value | Key Automation |
|-------------|-------------|----------------|
| Customer Communication | $15,350/yr | 10 branded email templates, AI chatbot (80% auto-resolved), 5-email welcome drip |
| Marketing & Content | $13,697/yr | AI social media pipeline, SEO blog generation, newsletter automation |
| Order Fulfillment | $7,280/yr | Stripe webhook → confirmation email → Xero invoice, all in seconds |
| Shipping Labels | $6,403/yr | EasyPost multi-carrier rate shopping, one-click labels, auto tracking |
| Quote Management | $4,567/yr | Full lifecycle from request to payment, 30-day expiration tracking |
| Advertising | $3,450/yr | Meta + Google pixels, server-side CAPI, monthly audience sync, ROAS dashboard |
| Finance & Accounting | $3,249/yr | Xero invoicing, payment reconciliation, fee tracking, payout transfers |
| **Total Delivered** | **$53,996/yr** | **19 active n8n workflows, 50 phases shipped** |

---

## Scope of Work: Next Phase

### Automation 1: Post-Purchase & Win-Back Sequences

**Current State:** After a customer receives their order, communication stops. No follow-up, no review request, no repurchase prompt. Lapsed customers get no win-back outreach.

**Proposed Solution:** Build a three-tier email sequence in n8n:
- **Post-purchase** (2 weeks after delivery): "How does your tablecloth look?" with care tips and a prompt to share a photo
- **Review request** (3 weeks): Direct link to leave a review, with incentive for photo reviews
- **Win-back** (90 days of inactivity): Personalized email based on original purchase, seasonal tie-in, and a return incentive

**Impact:**
- Estimated repeat purchase lift: 5-10% of customer base
- Annual value: Part of $16,200/yr (combined with cart recovery below)
- Builds social proof pipeline for advertising

### Automation 2: Cart Abandonment Recovery

**Current State:** Your analytics already track `begin_checkout` events without a matching `purchase_complete`. That data exists in Supabase. Nobody follows up on abandoned carts.

**Proposed Solution:** n8n workflow triggered by a time-window check (begin_checkout with no purchase after 1 hour). Three-email sequence:
- Email 1 (1 hour): "You left something behind" with cart contents
- Email 2 (24 hours): "Still thinking about it?" with a reminder of production lead times
- Email 3 (72 hours): "Last chance" with urgency framing

**Impact:**
- Industry average cart recovery rate: 5-15%
- Annual value: Part of $16,200/yr (combined post-purchase and cart recovery)
- Revenue-generating, not just cost-saving

### Automation 3: Campaign & Seasonal Automation

**Current State:** No automated campaign system. Seasonal promotions (holidays, wedding season, Thanksgiving) require manual creation and scheduling. The 2-4 week production lead time means campaigns need to launch early, and there is no system enforcing this.

**Proposed Solution:** Campaign template system in n8n with:
- Pre-built seasonal templates (Thanksgiving, Christmas, wedding season, Mother's Day)
- Auto-scheduled launch dates accounting for production lead time
- Multi-channel push (email + social + ad audience targeting)
- Campaign performance tracking in existing ad dashboard

**Impact:**
- Time saved: ~10 hours/week during peak seasons
- Annual value: $510/yr (labor) + revenue uplift from timely campaigns

### Automation 4: Review Collection & UGC Pipeline

**Current State:** No automated review requests. Social proof is manually curated through the featured reviews admin UI, but no system feeds it.

**Proposed Solution:** Integrate review request emails (from Automation 1) with:
- Photo submission flow (customer uploads, stored in Supabase Storage)
- Auto-populate featured reviews admin queue
- Best photos auto-queued for social media content pipeline (feeds existing social automation)

**Impact:**
- Time saved on content sourcing: ~2 hours/week
- Annual value: $1,170/yr (labor) + organic social content
- Feeds the existing social media pipeline with real customer content

### Automation 5: Financial Reporting & Expense Tracking

**Current State:** Xero handles invoicing and reconciliation automatically. But there is no automated P&L visibility, no expense tracking beyond Stripe fees, no per-product margin analysis. Tax prep is still manual.

**Proposed Solution:** Three new n8n workflows:
- **Weekly P&L report** via Slack: revenue, expenses, margins pulled from Xero API
- **Expense entry automation:** Receipt OCR (Claude/GPT) for supplier invoices, auto-categorized in Xero
- **Tax prep export:** Monthly summary of sales tax collected by state, formatted for accountant

**Impact:**
- Time saved: ~3 hours/week on financial admin
- Annual value: $1,665/yr
- Real-time financial visibility without logging into Xero

### Automation 6: Marketing Analytics Dashboard

**Current State:** Ad performance lives in the admin dashboard (Meta + Google). Social media analytics are tracked. But there is no unified marketing dashboard showing: email open/click rates, blog traffic, social engagement, and ad ROAS in one view.

**Proposed Solution:** Extend the existing admin dashboard with a marketing tab pulling data from:
- Resend (email metrics via API)
- Supabase analytics (blog traffic, funnel events)
- Existing ad_performance_daily table
- Social media engagement metrics (already tracked)

**Impact:**
- Time saved: ~1 hour/week on manual cross-platform reporting
- Annual value: $540/yr
- Single source of truth for all marketing metrics

---

## Investment

<!-- DRAFT PRICING — Input Assumptions:
     Hourly rate: $25/hr
     All time estimates from existing SOP documentation
     Revenue estimates (cart recovery, repeat purchases) are conservative
     Automation coverage percentages are initial targets
     Values sourced from SOP annual value calculations
-->

| Automation | Annual Value | Setup Fee (25%) |
|-----------|-------------|----------------|
| Post-Purchase & Win-Back Sequences | $6,480/yr | $1,620 |
| Cart Abandonment Recovery | $9,720/yr | $2,430 |
| Campaign & Seasonal Automation | $510/yr | $128 |
| Review Collection & UGC Pipeline | $1,170/yr | $293 |
| Financial Reporting & Expense Tracking | $1,665/yr | $416 |
| Marketing Analytics Dashboard | $540/yr | $135 |
| **Total** | **$20,085/yr** | **$5,022** |

**Monthly Retainer:** $400/month (monitoring, adjustments, support across all existing + new workflows)

> You keep 75%+ of the value from day one. The setup fee pays for itself within 3 months of operation. Combined with the $53,996/yr already delivered, total automation value reaches $74,081/yr.

---

## Timeline

| Phase | Duration | What Happens |
|-------|----------|-------------|
| Planning & Access | 3 days | Final requirements for new sequences, email copy review |
| Post-Purchase + Cart Recovery | 2 weeks | Build n8n workflows, email templates, test with real data |
| Campaign Templates | 1 week | Seasonal templates, scheduling logic, multi-channel integration |
| Reviews & UGC | 1 week | Photo submission flow, social pipeline integration |
| Finance Dashboards | 1 week | P&L reporting, expense OCR, tax prep export |
| Marketing Dashboard | 1 week | Unified metrics tab in admin |
| Testing & Go-Live | 3 days | End-to-end testing, monitoring setup |

**Total: 5-6 weeks** for the full scope. Or phase it: start with post-purchase sequences and cart recovery (highest value, 2 weeks), add the rest over time.

---

## What We Need From You

1. Email copy preferences for the new sequences (we will draft, you review)
2. Seasonal calendar: which holidays/events matter most for your customers
3. Access to Resend analytics API (if not already enabled)
4. Review incentive decision: discount code, free gift, or just a thank-you
5. Supplier invoice samples for OCR testing (2-3 examples)
6. 30 minutes for final review before each automation goes live

---

## Next Steps

1. Review this proposal and flag any questions
2. Prioritize which automations matter most right now
3. We finalize scope and kick off within the week
4. First automation live within 2 weeks

---

*Questions? Reach out at ariel.r08@gmail.com*

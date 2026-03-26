# SOP: Marketing and Content

**Owner:** Ariel (sole operator) + n8n automation
**Frequency:** Daily (social publishing, chat handling), weekly (blog), ongoing (newsletter drip)
**Current Time per Cycle:** ~3 min/post for approval, chat and comments as-needed. Blog and newsletter fully hands-off.
**Tools Used:** n8n Cloud, Supabase, Meta Graph API v22.0, Slack, Resend, Next.js (ISR)

## Process Steps

### Social Media Pipeline (v2.0)

| # | Step | Who | What They Do | Tool | Time | Automation Potential |
|---|------|-----|-------------|------|------|---------------------|
| 1 | Content trigger fires | System | Scheduled trigger or manual Quick Post request initiates workflow | n8n | Instant | Already Automated |
| 2 | Fetch content theme and product data | System | Pulls product info, recent themes, and campaign templates from Supabase | n8n, Supabase | Instant | Already Automated |
| 3 | AI generates platform-specific copy | System | Two-tier LLM produces copy for Instagram and Facebook. Supports 4 content types. | n8n (LLM) | ~30 sec | Already Automated |
| 4 | AI generates imagery | System | Product photos and lifestyle images created to match content | n8n (LLM) | ~1 min | Already Automated |
| 5 | Content enters approval queue | System | Post staged with preview, sent to Slack for review | n8n, Slack | Instant | Already Automated |
| 6 | Admin reviews content | Ariel | Reviews copy and image in Slack. Approve or reject via Slack actions. | Slack | ~3 min | Keep Manual (brand quality gate) |
| 7 | Dead man's switch fallback | System | If no response within configured window, content auto-publishes | n8n | N/A | Already Automated |
| 8 | Publisher posts to social platforms | System | 15-minute scheduled publisher sends approved content via Meta Graph API v22.0. Supports carousel and story formats. | n8n, Meta API | Instant | Already Automated |
| 9 | Customer messages handled by chatbot | System | FB/IG messages hit two-tier handler: knowledge base match first, then LLM fallback. Kill switch available for emergencies. | n8n (LLM) | Instant | Already Automated |
| 10 | Unhandled messages forwarded to Slack | System | Messages the bot cannot confidently answer get routed to Slack for manual reply | n8n, Slack | N/A | Already Automated |
| 11 | Manual reply via Slack bridge | Ariel | Responds to escalated messages directly from Slack (bridged back to platform) | Slack | ~2 min/msg | Keep Manual (judgment calls) |
| 12 | Comment monitor with AI suggestions | System | Monitors post comments, generates suggested replies, sends to Slack for approval | n8n (LLM), Slack | Instant | Already Automated |
| 13 | Reconciliation poller | System | 6-hour safety net checks for missed messages or failed publishes | n8n | Instant (every 6h) | Already Automated |
| 14 | Token health check | System | Daily check + webhook monitoring for Meta API token health | n8n | Instant (daily) | Already Automated |

### Blog Content Pipeline (v1.9)

| # | Step | Who | What They Do | Tool | Time | Automation Potential |
|---|------|-----|-------------|------|------|---------------------|
| 1 | Cluster SEO Post workflow triggers | System | Scheduled n8n workflow kicks off the blog generation pipeline (7 sub-workflows total) | n8n | Instant | Already Automated |
| 2 | AI generates blog post | System | Multi-sub workflow produces full Markdown blog post with SEO optimization | n8n (LLM) | ~2 min | Already Automated |
| 3 | Images generated and stored | System | AI-generated images saved to Supabase Storage with proper paths | n8n, Supabase Storage | ~1 min | Already Automated |
| 4 | Blog post saved to database | System | Markdown content and metadata written to blog_posts table | n8n, Supabase | Instant | Already Automated |
| 5 | ISR serves content | System | Next.js Incremental Static Regeneration delivers pages with 1-hour cache + on-demand revalidation | Next.js, Vercel | Instant | Already Automated |
| 6 | Structured data for SEO | System | Article and FAQ JSON-LD schema automatically included for search engine visibility | Next.js | Instant | Already Automated |

### Newsletter (v2.3)

| # | Step | Who | What They Do | Tool | Time | Automation Potential |
|---|------|-----|-------------|------|------|---------------------|
| 1 | Customer subscribes | Customer | Signs up via website form | Next.js, Supabase | Instant | Already Automated |
| 2 | Source tracking recorded | System | Subscriber source (checkout, footer, popup, etc.) logged for attribution | Supabase | Instant | Already Automated |
| 3 | Welcome drip series begins | System | 5-email sequence delivered over ~2 weeks via n8n + Resend | n8n, Resend | Automated (scheduled) | Already Automated |
| 4 | Unsubscribe handling | System | One-click unsubscribe link in every email (CAN-SPAM compliant) | Next.js, Supabase | Instant | Already Automated |

### Remaining Manual Work

- Social media content approval (~3 min per post, quality control)
- Escalated customer messages via Slack bridge (as needed)
- Comment reply approval (quick Slack action per comment)
- No formal review of blog content before publish (fully automated)

### n8n Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| Social Media Content | Schedule / manual | AI content creation + Slack approval + Meta publishing |
| FB/IG Chat Handler | Incoming message webhook | Two-tier customer chat (KB + LLM) |
| Comment Monitor | Schedule | AI-suggested comment replies via Slack |
| Reconciliation Poller | Every 6 hours | Safety net for missed messages or failed publishes |
| Token Health Check | Daily + webhook | Meta API token monitoring |
| Cluster SEO Post (+6 subs) | Schedule | Full blog generation pipeline (7 workflows) |
| Newsletter Welcome | Subscriber creation | 5-email welcome drip series |

## Automation Opportunities

These are the unbuilt marketing pillars. The transactional and publishing side is done. What is missing is lifecycle marketing, campaign orchestration, and analytics.

| Area | Current Pain | Proposed Automation | Impact |
|------|-------------|-------------------|--------|
| Customer lifecycle marketing | No post-purchase sequences. No review requests. No win-back emails. No VIP tiers. | Post-purchase follow-up (care tips, cross-sell), win-back series for lapsed customers, VIP segmentation based on order history | Drive repeat purchases (currently unknown repeat rate) |
| Cart abandonment recovery | Analytics events exist (begin_checkout without purchase_complete) but no recovery workflow | Timed email sequence: 1h reminder, 24h nudge with social proof, 72h final notice | Recover estimated 5-15% of abandoned carts |
| Campaign automation | No seasonal promotion system. 2-4 week production lead time makes timing critical. | Seasonal campaign templates with lead-time-aware scheduling, product launch sequences, flash sale workflows | Coordinate marketing with production capacity |
| UGC and reviews | No review request automation. No social proof pipeline. | Post-delivery review request emails, approval queue for featuring reviews, auto-publish to social | Build social proof, improve conversion rate |
| Analytics and reporting | No marketing performance dashboard beyond ad-specific metrics. No attribution modeling. | Unified marketing dashboard (social + email + ads + blog), channel attribution, customer journey mapping | Know what is actually working |
| Crisis communications | No automated delay notifications or issue resolution workflows | Production delay auto-notification, shipping issue alerts, proactive status updates | Reduce support inquiries, protect brand trust |

## Annual Value Calculation

<!-- DRAFT PRICING — Input Assumptions:
     Hourly rate: $25/hr
     Social posts per week: ~5 (estimated)
     Blog posts per month: ~4 (estimated)
     Newsletter subscribers: growing (drip is automated)
     Pre-automation time for social content: ~45 min/post (research, write, design, schedule)
     Pre-automation time for blog: ~3 hrs/post (research, write, images, publish, SEO)
     Pre-automation time for customer messages: ~15 min/day
     Orders per week: estimated 5-10
-->

### Value Already Delivered (Built Automation)

| Metric | Calculation | Annual Value |
|--------|------------|-------------|
| Social media content creation | 45 min/post x 5 posts/week x 52 weeks x ($25/60), 90% automated | $4,388/year |
| Social media approval (remaining manual) | 3 min/post x 5 posts/week x 52 weeks, still manual | (Cost: $325/year, accepted as quality gate) |
| Blog content pipeline | 3 hrs/post x 4 posts/month x 12 months x $25, 95% automated | $3,420/year |
| Customer chat handling | 15 min/day x 365 days x ($25/60), 80% automated | $1,825/year |
| Newsletter welcome drip | 30 min/subscriber for manual onboarding x est. 20 subscribers/month x 12 x ($25/60), 100% automated | $3,000/year |
| Comment monitoring | 10 min/day x 365 x ($25/60), 70% automated | $1,064/year |
| **Total Value Delivered** | | **$13,697/year** |

### Value Remaining (Unbuilt Automation)

| Metric | Calculation | Annual Value |
|--------|------------|-------------|
| Cart abandonment recovery | 7.5 orders/week x 30% abandon rate x 10% recovery x $150 AOV x 52 weeks | $1,755/year in recovered revenue |
| Post-purchase sequences | Estimated 5% repeat purchase lift x $150 AOV x 7.5 orders/week x 52 | $2,925/year in incremental revenue |
| Campaign automation | 2 hrs/campaign x 12 campaigns/year x $25, 85% automated | $510/year in labor savings |
| Review request automation | Manual review outreach ~1 hr/week x 52 x $25, 90% automated | $1,170/year |
| Marketing analytics dashboard | 2 hrs/month manual reporting x 12 x $25, 90% automated | $540/year |
| **Total Remaining Value** | | **$6,900/year** |
| **Recommended Setup Fee (25%)** | | **$1,725** |

Note: Cart abandonment and post-purchase values are revenue estimates, not labor savings. Actual impact depends on order volume and AOV (see discovery questionnaire gaps). Labor-only remaining value is $2,220/year.

# Past Work Reference

Use these case studies as social proof in proposals and speaking notes. Never name the actual client. Use the suggested framing language to describe each project.

---

## Case Study 1: E-Commerce Shipping Automation

**Framing:** "A product company similar to yours" or "an e-commerce business we worked with"

**Problem:** The client was generating shipping labels manually through EasyPost's web interface. Each order required copying the recipient address from their order system, pasting it into EasyPost, selecting the carrier, generating the label, downloading it, and then copying the tracking number back into their order system. They were also manually checking for address issues after labels were already printed.

**What we built:**
- Automated label generation triggered by new orders, with carrier selection based on package weight and destination
- Address validation before label creation (catches errors before they cost money)
- Automatic tracking number sync back to the order system
- Daily exception report for flagged addresses or carrier issues

**Result:** 85% reduction in time spent on shipping operations. What used to take one person most of their day now runs in the background with a 10-minute daily review of the exception report.

**Key numbers for proposals:**
- If the client processes ~100 orders/day and each takes 3 minutes manually: 300 min/day = 5 hours/day
- At $25/hr: $125/day = $625/week = ~$32,500/year in labor on this one process
- 85% reduction = ~$27,600/year in savings from this single automation

---

## Case Study 2: Order Confirmation Workflow

**Framing:** "A retail business we worked with" or "a company with a similar order flow"

**Problem:** When orders came in, data had to be handed off between three systems: the storefront, the inventory tracker, and the invoicing tool. Each handoff was manual, and the person doing it had to recalculate totals (adding tax, applying discounts, adjusting for bundles). Errors were common: incorrect totals, wrong quantities, missed discount codes. Each error required a correction email to the customer and a manual fix in all three systems.

**What we built:**
- Automated data sync between all three systems on order creation
- Validation layer that checks quantities, recalculates totals, and flags mismatches before anything posts
- Automatic correction triggers when source data changes (e.g., customer updates their order)
- Error log with notification for anything the system can't auto-resolve

**Result:** Zero data handoff errors since launch (4+ months). The person who used to spend ~2 hours/day on data entry and error correction now spends that time on customer relationships and upselling.

**Key numbers for proposals:**
- 2 hours/day at $25/hr = $50/day = ~$13,000/year in direct labor savings
- Error correction cost (customer comms, system fixes, reputation): estimated $200-500/month = $2,400-6,000/year
- Total value: ~$15,000-19,000/year from this automation

---

## Case Study 3: Blog Content Automation

**Framing:** "An e-commerce brand we work with" or "a product company with a content marketing need"

**Problem:** The client needed 52 blog posts/year (one per week) to drive organic SEO traffic. Each post required keyword research, competitive analysis, writing 1,200-1,800 words, finding/citing sources, adding internal links to previous posts, generating section images and a feature image, creating SEO metadata (slug, title, meta description), and formatting for their CMS. Manually, each post took 4-6 hours of a content person's time.

**What we built:**
- 8-step automated pipeline triggered by a content calendar row (keyword + search intent)
- AI-powered planning: keyword analysis → outline → detailed plan with research integration
- Full blog post generation in brand voice with SEO keyword placement
- Automatic internal linking to previous posts (3-5 contextual links per post)
- SEO metadata generation (slug, title tag, 150-160 char meta description)
- Custom image prompt generation for section diagrams and feature hero image
- Final formatting to production-ready markdown for their CMS

**Result:** ~87% reduction in time per blog post. What took 4-6 hours now takes ~30 minutes of review and light editing. The client publishes weekly on schedule with consistent brand voice and SEO optimization across all 52 posts.

**Key numbers for proposals:**
- Manual: 4-6 hours/post × 52 posts = 208-312 hours/year
- Automated: ~30 min/post × 52 posts = 26 hours/year
- At $35/hr content writer rate: ~$6,400-10,000/year in labor savings
- Plus: consistent quality, never misses a publish date, SEO-optimized from day one

# SOP: Shipping Label Management

**Owner:** Store Admin (Nomi)
**Frequency:** ~15 labels/week (1:1 with orders)
**Current Time per Cycle:** ~2.5 minutes (down from ~15 minutes pre-automation)
**Tools Used:** EasyPost API, Next.js Admin Dashboard, n8n, Resend, Supabase

## Process Steps

| # | Step | Who | What They Do | Tool | Time | Automation Status |
|---|------|-----|-------------|------|------|-------------------|
| 1 | Order reaches "processing" status | Prerequisite | Order must be in "processing" before shipping tools are available | Admin Dashboard | — | Prerequisite |
| 2 | System estimates package weight from dimensions | System | Tablecloth dimensions (from order) are used to calculate estimated package weight | Supabase (dimension data) | Instant | Automated |
| 3 | Admin opens shipping section, sees rate comparison table | System | EasyPost API returns real-time rates from USPS, UPS, and FedEx with prices and delivery estimates | EasyPost API + Admin UI | Instant | Automated |
| 4 | Admin overrides weight/dimensions if needed | Admin | Optional. If the estimate looks off (unusual fabric, bundled items), admin can adjust | Admin Dashboard | ~1 min (when needed) | Manual (optional) |
| 5 | Admin selects carrier and service | Admin | Picks from the rate table based on price, speed, and customer expectations | Admin Dashboard | ~1 min | Manual |
| 6 | Admin clicks "Purchase Label" (confirmation dialog) | Admin | Confirmation popup prevents accidental purchases | Admin Dashboard | ~30 sec | Manual (one-click) |
| 7 | Label purchased via EasyPost API | System | API call to EasyPost, label generated, PDF stored | EasyPost API | Instant | Automated |
| 8 | Tracking number saved to order | System | Tracking number written to the order record in Supabase | Supabase | Instant | Automated |
| 9 | Order status auto-updates to "shipped" | System | Status change triggers downstream automations | Supabase | Instant | Automated |
| 10 | Customer receives shipped email with tracking | System | Existing n8n workflow fires on status change to "shipped" | n8n + Resend | Instant | Automated |
| 11 | Label PDF available for download/print | System | Admin can download or print the label directly from the dashboard | Admin Dashboard | Instant | Automated |
| 12 | Actual shipping cost recorded for margin analysis | System | Real cost from EasyPost stored alongside flat customer rate for profit tracking | Supabase | Instant | Automated |

**Flat rate pricing to customers:** $19.99 standard, $39.99 express. Actual carrier cost is tracked per order so Nomi can monitor shipping margins over time.

**Fallback:** If EasyPost is unavailable, the admin can manually enter a tracking number. The system still updates the order status and triggers the customer email.

**Version history:** Shipped v2.2, fix in v2.5.

## Automation Opportunities

| Step(s) | Current State | Possible Automation | Impact |
|---------|--------------|---------------------|--------|
| 4, 5, 6 | Admin reviews rates and selects carrier (~2.5 min) | Auto-select cheapest carrier meeting a delivery SLA (e.g., 5 business days for standard, 2 for express), auto-purchase label | Saves ~2.5 min/label. Biggest remaining manual step. Requires validated weight estimates and a defined SLA policy. |
| 4 | Weight override is occasionally needed | Improve weight estimation model with historical data (actual vs. estimated weights) | Reduces override frequency. After 100+ shipments, the system can self-correct using actual package weights. |

## Annual Value Calculation

<!-- DRAFT PRICING — Input Assumptions:
     Hourly rate: $25/hr
     Labels per week: 15
     Time saved per label (automation vs. fully manual): 12.5 minutes
     Fully manual process: ~15 min/label (log into carrier website, enter addresses, compare rates manually, purchase, download label, copy tracking number, paste into system, notify customer)
     Current process with automation: ~2.5 min/label
     Remaining automatable time: ~2.5 min/label (steps 4-6)
-->

| Metric | Calculation | Annual Value |
|--------|------------|-------------|
| Labor Savings (already realized) | (12.5 min x 15 labels/week) / 60 x $25 x 52 | **$4,063/year** |
| Labor Savings (additional, if auto-select implemented) | (2.5 min x 15 labels/week) / 60 x $25 x 52 | **$813/year** |
| Shipping Cost Savings (rate shopping) | Multi-carrier comparison saves avg $2/label vs. single-carrier default, 15 labels/week x 52 | **$1,560/year** |
| Margin Visibility | Actual cost tracking enables data-driven flat rate adjustments. Conservative estimate: 5% margin improvement on $20 avg shipping revenue, 780 orders/year | **$780/year** |
| **Total Annual Value (realized)** | | **$6,403/year** |
| **Additional Value (if auto-select added)** | | **$813/year** |
| **Recommended Setup Fee (25% of realized)** | | **$1,601** |

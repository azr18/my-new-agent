# SOP: Finance and Accounting

**Owner:** Ariel (sole operator) + n8n automation
**Frequency:** Per order (invoicing), daily (payout reconciliation), weekly (OAuth keep-alive)
**Current Time per Cycle:** ~55 min/order before automation, ~0 min/order after (fully automated pipeline)
**Tools Used:** Xero, Stripe, n8n Cloud, Supabase, Slack

## Process Steps

| # | Step | Who | What They Do | Tool | Time | Automation Potential |
|---|------|-----|-------------|------|------|---------------------|
| 1 | Order completed (cart checkout or quote payment) | Customer | Completes Stripe checkout | Stripe, Next.js | 0 min (trigger) | Already Automated |
| 2 | Webhook received by n8n | System | n8n Xero Invoice Sync workflow picks up the event | n8n | Instant | Already Automated |
| 3 | Customer lookup/creation in Xero | System | Checks if customer exists by xero_contact_id on profiles table. Creates new Xero contact if not found. | n8n, Xero, Supabase | Instant | Already Automated |
| 4 | Invoice created with line items | System | Creates Xero invoice with products (account 4000), shipping (4001), custom fee (4100), and tax as explicit line item. Amounts match Stripe exactly. | n8n, Xero | Instant | Already Automated |
| 5 | Stripe payment recorded | System | Logs Stripe payment against the Xero invoice, marking it paid | n8n, Xero | Instant | Already Automated |
| 6 | Stripe fee recorded as expense | System | Xero Fee Expense workflow creates expense entry in Stripe Fees account (6040) with exact Stripe fee amount | n8n, Xero | Instant | Already Automated |
| 7 | Refund handling (when applicable) | System | Stripe refund triggers credit note creation in Xero (ACCRECCREDIT type) | n8n, Xero | Instant | Already Automated |
| 8 | Daily payout reconciliation | System | Xero Payout Transfer workflow matches Stripe payouts to bank transfers using Stripe Clearing pattern | n8n, Xero | Instant (daily) | Already Automated |
| 9 | Failure monitoring and alerting | System | Xero Error Monitoring workflow logs all sync operations to xero_sync_log. Sends Slack alert after 3 consecutive failures in 1 hour. Retries with exponential backoff (base-3: 1s, 3s, 9s). Handles 429 rate limits. | n8n, Slack, Supabase | Instant | Already Automated |
| 10 | OAuth token keep-alive | System | Weekly n8n job refreshes Xero OAuth2 token to prevent expiry | n8n, Xero | Instant (weekly) | Already Automated |
| 11 | Tax filing preparation | Ariel | Manual review of tax data, prep for filing | Xero, spreadsheets | ~2 hrs/month | High |
| 12 | Non-Stripe expense entry | Ariel | Manually enters operating expenses (tools, supplies, etc.) into Xero | Xero | ~1 hr/month | High |
| 13 | Supplier invoice processing | Ariel | Reviews and enters supplier bills for fabric, materials | Xero | ~30 min/month | High |
| 14 | Financial reporting | Ariel | Manually pulls P&L, reviews revenue and expenses | Xero, spreadsheets | ~2 hrs/month | High |
| 15 | Margin analysis | Ariel | Calculates per-product profitability (no system for this yet) | Spreadsheets | ~1 hr/month | High |

### Reliability Features (Built)

- **Idempotency:** Order ID used as unique key prevents duplicate invoices if a webhook fires twice.
- **Exponential backoff:** Base-3 retry (1s, 3s, 9s) for transient API failures.
- **Rate limit handling:** 429 responses trigger automatic backoff.
- **Config table:** Xero tenant ID and all account IDs stored in xero_config table (no hardcoded values).
- **Audit trail:** Every sync operation logged to xero_sync_log with error details on failure.

### n8n Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| Xero Invoice Sync | Order completion webhook | Invoice creation, payment recording, contact management |
| Xero Fee Expense | Order completion webhook | Stripe fee expense logging to account 6040 |
| Xero Payout Transfer | Daily schedule | Stripe payout to bank reconciliation |
| Xero Error Monitoring | Failure events | Slack alerting, retry orchestration |

## Automation Opportunities

These are the unbuilt finance pillars (5-11 from the original automation plan). Each represents a clear next step.

| Step(s) | Current Pain | Proposed Automation | Impact |
|---------|-------------|-------------------|--------|
| 11 | Manual tax data compilation (~2 hrs/month). No US sales tax tracking or nexus monitoring. | Automated sales tax calculation at checkout, tax liability reports, filing-ready exports by jurisdiction | Eliminate ~24 hrs/year of prep, reduce filing errors |
| 14 | No real-time P&L. Ariel pulls reports manually from Xero. | Scheduled P&L generation, revenue dashboards in admin panel, automated weekly financial summary to Slack | Instant financial visibility, ~24 hrs/year saved |
| 12 | Operating expenses entered by hand. No receipt capture. | Receipt OCR (photo to Xero expense), auto-categorization, recurring expense templates | Eliminate ~12 hrs/year of data entry |
| 13 | Supplier invoices managed manually. No payment scheduling. | Supplier bill import, payment due date tracking, automated payment scheduling | Eliminate ~6 hrs/year, avoid late payment fees |
| N/A | No cash flow forecasting. Surprises happen. | Projected cash flow based on order pipeline, seasonal patterns, and known expenses. Low-balance alerts. | Proactive cash management instead of reactive |
| N/A | No anomaly detection on transactions. | Automated flags for unusual transactions, margin drops, or revenue pattern changes | Early warning system for financial issues |
| 15 | Per-product profitability unknown. Production cost not tracked in system. | COGS tracking per product, automated margin calculation, profitability dashboard | Know which products and tiers actually make money |

## Annual Value Calculation

<!-- DRAFT PRICING — Input Assumptions:
     Hourly rate: $25/hr
     Orders per week: estimated 5-10 (confirm with actual Stripe data)
     Pre-automation time per order: ~55 min (15 min invoice + 10 min reconciliation + 30 min/week prorated)
     Post-automation time per order: ~0 min (steps 1-10 fully automated)
     Tax/reporting manual hours: ~6.5 hrs/month remaining
-->

### Value Already Delivered (Built Automation, Steps 1-10)

| Metric | Calculation | Annual Value |
|--------|------------|-------------|
| Invoice creation savings | 15 min/order x 7 orders/week x 52 weeks x ($25/60) | $1,365/year |
| Payment reconciliation savings | 10 min/order x 7 orders/week x 52 weeks x ($25/60) | $910/year |
| Payout reconciliation savings | 30 min/week x 52 weeks x ($25/60) | $650/year |
| Error reduction (duplicate invoices, missed entries) | ~2 errors/month x $15/error x 12 months x 90% reduction | $324/year |
| **Total Value Delivered** | | **$3,249/year** |

### Value Remaining (Unbuilt Automation, Steps 11-15)

| Metric | Calculation | Annual Value |
|--------|------------|-------------|
| Tax prep automation | 2 hrs/month x 12 x $25 x 80% automation | $480/year |
| Financial reporting automation | 2 hrs/month x 12 x $25 x 90% automation | $540/year |
| Expense entry automation | 1 hr/month x 12 x $25 x 85% automation | $255/year |
| Supplier invoice automation | 0.5 hrs/month x 12 x $25 x 80% automation | $120/year |
| Margin analysis automation | 1 hr/month x 12 x $25 x 90% automation | $270/year |
| **Total Remaining Value** | | **$1,665/year** |
| **Recommended Setup Fee (25%)** | | **$416** |

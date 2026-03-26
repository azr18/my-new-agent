# Internal Profile: Seven Seas International

**Status:** Discovery Phase
**Created:** 2026-03-17
**Last Updated:** 2026-03-24

## Contact
- **Primary Contact:** Ygal Senior
- **Phone:** 401.433.8256
- **Email:** ygal@sevenseasfoods.com
- **Website:** https://sevenseasfoods.com/

## Company Info
- **Name:** Seven Seas International (dba Seven Seas Foods)
- **Industry:** International frozen seafood distribution (import/export, wholesale, private label)
- **HQ:** 66 W Flagler St, Suite #912, Miami, FL 33130
- **Size:** Global team spanning 18 countries, 20+ nationalities, 24/7 coverage across time zones
- **Revenue Model:** B2B wholesale distribution (per-unit/per-order, likely with contract pricing for large buyers)
- **Tech Stack:** Google Sheets ("SHIPMENT REPORT 7 SEAS OFFICE" for shipment tracking), carrier web portals (Maersk, MSC, Evergreen, Cosco, OOCL, TRIDENT). ERP/accounting/other systems TBD.

## Business Scale
- **72 countries** supplied
- **49 diverse species** in catalog
- **20+ million pounds/year** processed
- Global dedicated teams covering every time zone
- Founded by European founders, started as US/Canada importer, expanded to export worldwide (Europe, Asia, Russia, Africa, Latin America)

## Product Lines
1. **Retail & Food Service:** Pollock fillets, salmon portions, tilapia fillets, cod products, breaded fish, canned tuna/sardines, scallops, gourmet prepared fillets with sauces
2. **Bait & Feed:** Mackerel, Pacific saury, sardines, herring, squid, capelin, salmon heads, anchovies
3. **Industry & Canning:** Frozen blocks (pollock, cod, salmon), minced products, bulk ingredients for processing

## Services
- Custom fish fillets and portions
- Private label retail packaging (bags and boxes)
- Bait and feed distribution
- Full supply chain management (procurement to delivery)
- Work with state-of-the-art partner processing facilities (not own manufacturing)

## Certifications (via partner facilities)
- BAP (Best Aquaculture Practices)
- MSC (Marine Stewardship Council)
- BRC (British Retail Consortium)
- IFS (International Featured Standards)
- Kosher

## Core Values
Confidence, Quality, Full Service, Competitiveness, Sustainability

## Pain Points
- **Shipment tracking (confirmed):** Daily manual process of checking 4-6 carrier websites for container status, then updating Google Sheets. Estimated 45-90 min/day. Carriers: Maersk, MSC, Evergreen, Cosco, OOCL, TRIDENT. Risk of missed ETA changes and delayed customer/warehouse communication.
- **Customs/ISF tracking (confirmed):** Ygal and at least one other person ("C") handle ISF filings. Status tracked in spreadsheet notes column. Some shipments need ISF, some don't (domestic Alaska via TRIDENT). Filing triggers and status tracking appear manual.
- Logistics and trucking issues (additional specifics TBD)
- At 20M+ lbs/year across 72 countries: coordination complexity is massive
- Multi-region distribution with cold chain requirements

## Likely Automation Opportunities (Pre-Discovery)
- **Order-to-fulfillment pipeline:** Order intake across multiple channels/countries, routing to correct processing facility, dispatch coordination
- **International logistics:** Multi-carrier management, customs documentation, bill of lading generation, freight forwarding coordination
- **Cold chain compliance:** Temperature monitoring/alerts, certification document management, audit trail
- **Customer communication:** Order status updates across time zones, delivery confirmations, multi-language support
- **Inventory management:** Stock levels across partner processing facilities, species availability, seasonal supply tracking
- **Private label workflow:** Custom packaging specs, label generation, quality control checklists
- **Invoicing & AR:** Multi-currency invoicing, payment tracking across 72 countries, credit management
- **Compliance document management:** BAP/MSC/BRC/IFS/Kosher cert tracking, expiration alerts, audit prep

## Complexity Estimate
- **Number of processes to map:** 5-8 (international scope adds layers vs. domestic-only)
- **Integration points:** TBD (ERP, TMS, customs brokers, carrier APIs, processing facility systems, accounting)
- **Estimated project size:** Large (international B2B, multi-facility, multi-currency, compliance-heavy)

## Status Checklist
- [x] Initial contact made
- [x] Company research completed
- [x] Discovery questionnaire sent
- [ ] Discovery session completed
- [ ] SOPs documented
- [ ] Process flows created
- [ ] Proposal sent
- [ ] Speaking notes prepared
- [ ] Proposal presented
- [ ] Contract signed

## Discovery Intel: Shipment Tracking (from 2026-03-24 intro meeting)

**Source:** Ygal shared the "SHIPMENT REPORT 7 SEAS OFFICE" Google Sheets spreadsheet.

### Spreadsheet structure:
- Column A: Order # (e.g., 26012, 26300V3)
- Column B: Product (Giant Squid, Tilapia Fillets, Monkfish heads, Pollock Fillets, Horse Mackerel, Breaded Fish)
- Column C: Shipper/Supplier (Bering Sea, Besecker, NN, NAPS, Bertram, Hatov)
- Column D: Reference number (possibly supplier PO or booking ref)
- Column E: Carrier (Maersk, MSC, Evergreen, Cosco, OOCL, TRIDENT)
- Column F: Container # (e.g., MNBU4694497, EMCU5917330, OTPU6168008; blank for TRIDENT)
- Column G: Date (likely ship/departure date)
- Column H: Date (likely ETA/arrival, highlighted yellow for attention items)
- Column I: Origin (Guayaquil EC, Qingdao, China, ALASKA, Boston)
- Column J: Destination (Seattle WA, Kent, Gloucester, NJ/SeaJet, Haiti, Felixstowe GB)
- Notes columns (right of J): ISF filing status, customs notes

### Key observations from spreadsheet:
- ISF status tracked in notes: "ISF filed with C...", "ISF sent by Yg...", "ISF Needed", "Don't file ISF"
- "Yg" = Ygal filing ISF himself; "C" = likely customs broker or team member
- TRIDENT rows (Alaska pollock) have no container numbers, appear to be domestic
- Some entries have "ASAP" or "TBD" for dates
- Yearly tabs back to 2014, currently on 2026 tab
- Yellow highlighting on column H indicates items needing attention

### Two target processes for automation:
1. Container trace & track (carrier API/website to Google Sheets)
2. Customs/ISF tracking and updating

### Carrier landscape:
- Tier 1 (public APIs available): Maersk, OOCL, Cosco
- Tier 2 (web portal only, scraping needed): MSC, Evergreen
- Tier 3 (manual/domestic): TRIDENT

## Notes
- First dialogue focused on logistics and trucking pain points
- Intro meeting (2026-03-24) narrowed focus to shipment tracking and customs as first automation targets
- This is a substantial international operation, not a small local importer. 72 countries and 20M+ lbs/year puts them solidly mid-market
- Partner processing model (not own factories) means automation opportunities are more on the commercial/logistics side, less on manufacturing
- Multi-currency, multi-timezone, multi-language operation = high value for automation but also higher complexity
- Private label business adds another workflow layer (custom specs, packaging, labeling)
- The bait/feed and industry/canning lines likely have different fulfillment workflows than retail/food service
- Need to find out: what other systems they use, exact time spent on tracking, how customs broker relationship works

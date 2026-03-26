# Shipment Tracking Automation: What's Possible

**Prepared for:** Seven Seas International
**Prepared by:** My New Agent (mynewagent.ai)
**Date:** 2026-03-24

---

## The Big Picture

You showed us your shipment tracking spreadsheet. Right now, someone on your team opens 4-6 different carrier websites every day, types in container numbers, reads the tracking results, and manually updates the spreadsheet. Then they check customs status, update notes, and email people when something changes.

We can automate most of that. Not all of it (we'll be upfront about what's hard), but the repetitive carrier-by-carrier lookup and spreadsheet updating? That's very doable.

Here's what we found after researching your specific carriers, customs systems, and FDA requirements.

---

## 1. Container Tracking: This Is the Easy Win

Your spreadsheet shows six carriers. We looked into each one to understand how to pull tracking data automatically.

### Your Carriers

| Carrier | Can We Get Data Automatically? | How |
|---------|-------------------------------|-----|
| Maersk | Yes | They offer a free tracking API. Best documented of any carrier. |
| MSC | Yes (through a service) | MSC doesn't offer their own API, but tracking services cover them. |
| Evergreen | Yes | They have a tracking API through their ShipmentLink platform. |
| Cosco | Yes (through a service) | No direct API, but tracking services cover them. |
| OOCL | Yes (through a service) | No direct API, but tracking services cover them. |
| TRIDENT | Different situation | This is domestic trucking (Alaska), not ocean freight. No container numbers. We'd handle this separately. |

**The short version:** For your five ocean carriers, we can pull tracking data automatically. Two of them (Maersk and Evergreen) have their own APIs. The other three need a tracking aggregator, which is a service that connects to all major carriers through a single point.

### Tracking Aggregator Options

Rather than building separate connections to each carrier, we'd use one service that covers all of them.

| Service | Carriers Covered | Cost | What It Gives You |
|---------|-----------------|------|-------------------|
| ShipsGo | 160+ carriers (all of yours) | Free, unlimited | Container status, ETA, vessel info, port history |
| Terminal49 | All major carriers + US/Canada port terminals | Free for first 100 containers | Same as above, plus customs hold status at the port level |
| SeaRates | 180+ carriers | Free for 5 containers/month, then paid | Container tracking plus rate comparison tools |

**What you'd get for each container:**
- Current status (loaded, in transit, at port, delivered)
- Vessel name and current position
- Updated ETA at destination port
- Port call history (where it's been, where it's going)
- Transshipment updates (when a container switches vessels)

### How It Would Work

1. The system reads your spreadsheet every few hours
2. It finds every row with a container number that hasn't been delivered yet
3. For each container, it calls the tracking service and gets the latest status
4. If the ETA changed or something important happened, it updates your spreadsheet and sends you an alert
5. Everything gets logged so you have a complete history of every update

**This works for all your destinations.** Seattle, Gloucester, NJ, Felixstowe (UK), Haiti. The tracking services cover global ocean freight, not just US-bound containers.

### TRIDENT (Alaska Domestic)

The TRIDENT rows in your spreadsheet don't have container numbers. These appear to be domestic shipments (Alaska pollock to Gloucester). They need a different approach since there's no ocean container to track. Options here depend on whether TRIDENT offers any tracking portal or if it's phone-and-email only. We'll ask about this in our discovery session.

---

## 2. Customs & ISF Status: This Is Harder (But Not Impossible)

We noticed your spreadsheet tracks ISF filing status in the notes column: "ISF filed with C...", "ISF sent by Yg...", "ISF Needed", "Don't file ISF." This tells us customs tracking is a real part of the workflow.

Here's what we found.

### The Honest Reality

**US Customs (CBP) does not offer a tracking API to importers.** Everything goes through your customs broker's systems. There's no way to log into a government website and pull clearance status automatically the way you can with carrier tracking.

ISF filings go through your broker's software into the CBP system. Status updates (cleared, held, released) come back through the broker.

### What We Can Do

| Automation | How | Effort |
|-----------|-----|--------|
| **Parse broker emails** | If your broker sends status emails (filed, cleared, held), we can automatically read those emails and update your spreadsheet | Straightforward, as long as the emails follow a consistent format |
| **Port-level customs holds** | Some tracking services (Terminal49) include whether a container is on customs hold at the port. We'd flag those automatically. | Comes free with the tracking service |
| **ISF filing reminders** | When a new container number shows up in your spreadsheet with no ISF note, the system sends a reminder | Easy to add |
| **Status column updates** | When customs status changes (from any source), the system updates a dedicated column and logs the change | Part of the core workflow |

### What We Can't Automate (Yet)

- **The actual ISF filing.** That still goes through your broker or whoever files it (you, "C", etc.)
- **Real-time CBP clearance status.** We can only get this as fast as your broker relays it
- **UK customs (HMRC) for Felixstowe shipments.** That's a different system entirely. We can track the container's journey, but UK customs clearance would need to come from whoever handles that side

### What We Need From You

We need to understand your customs broker relationship. Specifically: who is your broker, do they have an online portal you check, and how do they currently tell you when something clears or gets held? This determines which automation path works best.

---

## 3. FDA Clearance: Mostly Manual, But We Can Help

For frozen seafood imports, FDA requires Prior Notice filed at least 8 hours before the vessel arrives at a US port. Here's the landscape.

### What Exists

| System | What It Does | Can We Automate It? |
|--------|-------------|-------------------|
| FDA Prior Notice (PNSI) | Where prior notices get filed and checked | No. Web portal only, no API. |
| FDA ITACS | Upload documents, check shipment status | No. Web portal only. |
| FDA Data Dashboard | Historical data on import refusals, alerts, inspections | Yes. This one has an API. |

### What We Can Do

- **Proactive risk checking.** The FDA Data Dashboard API lets us check if a specific product, supplier, or country of origin is on an FDA import alert. Before a shipment arrives, the system can automatically flag: "Heads up, tilapia from this region has an active FDA alert." That gives you time to prepare documentation or contact your broker.
- **Filing reminders.** Based on the vessel ETA from carrier tracking, the system can send a reminder when prior notice needs to be filed (8+ hours before arrival).
- **Status tracking via email.** If FDA or your broker sends clearance emails, we can parse those and update the spreadsheet.

### What Stays Manual

The actual filing and real-time status checking in the FDA portal stays manual for now. There's no programmatic way around that. But the reminders, risk checks, and email parsing take the busywork out of it.

---

## 4. The Full Automation: How It All Fits Together

Here's what the complete system would look like.

### Daily Cycle

```
Every few hours, the system automatically:

  1. Opens your spreadsheet and finds active shipments
     (has a container number, hasn't been delivered)

  2. Checks each container's status via tracking API
     (Maersk, MSC, Evergreen, Cosco, OOCL, all through one service)

  3. Updates your spreadsheet
     - New ETA in the date column
     - Status changes in a tracking status column
     - Customs hold flags if detected at the port

  4. Sends alerts when something important happens
     - ETA changed by more than a day
     - Container arrived at port
     - Customs hold detected
     - Delivery confirmed

  5. Logs everything
     - Complete history of every status change
     - Which API provided the data
     - Old value vs. new value
```

### What Changes in Your Spreadsheet

We'd keep your existing layout exactly as it is. No disruption. We'd add:

- **A "Tracking Status" column** that gets updated automatically (In Transit, At Port, Customs Hold, Delivered, etc.)
- **A "Last Checked" column** showing when the system last pulled data for that row
- **A "Tracking Log" tab** in the same spreadsheet with a complete history of every update (timestamp, container, what changed)
- **An "Errors" tab** for any containers the system couldn't track (invalid number, carrier API down, etc.)

Your existing columns, formatting, yearly tabs, and notes columns stay untouched.

### Alerts and Notifications

We can send alerts through email, WhatsApp, or Slack. You tell us what matters:

| Event | Suggested Alert Level |
|-------|----------------------|
| ETA changed by 1+ days | Notification |
| Container arrived at port | Notification |
| Customs hold detected | Urgent alert |
| FDA alert on a product/origin | Urgent alert |
| Shipment delivered | Notification |
| Container not found / tracking error | Flag for manual review |
| ISF filing deadline approaching | Reminder |

---

## 5. What's Straightforward vs. What's Hard

| Area | Difficulty | Notes |
|------|-----------|-------|
| Container tracking (all 5 ocean carriers) | Straightforward | Free aggregator APIs cover all of them. Proven technology. |
| Google Sheets integration (read/write) | Straightforward | Well-documented, free API. We've done this before. |
| Automated alerts (email/WhatsApp) | Straightforward | Standard automation capability. |
| Customs hold detection at port level | Straightforward | Comes with some tracking services (Terminal49). |
| ISF filing reminders | Straightforward | Simple ETA-based trigger. |
| FDA import alert risk checks | Moderate | FDA has an API for this data, but it requires registration and the data format needs parsing. |
| Customs broker status integration | Moderate to Hard | Depends entirely on your broker. If they send structured emails, it's moderate. If it's phone calls and PDFs, it's harder. |
| Real-time CBP clearance status | Hard | No API exists. Must come through your broker. |
| Real-time FDA hold/release status | Hard | No API exists. Web portal only. Must come through your broker or manual checks. |
| TRIDENT domestic tracking | Unknown | Need to understand what tracking TRIDENT offers before we can assess this. |
| UK/Haiti customs tracking | Out of scope for phase 1 | Different customs systems. We can track the container, but not the customs clearance on those routes initially. |

---

## 6. What We Need From You

Before we can scope and price this, we need a few things:

1. **Your customs broker info.** Who are they? Do they have a portal? How do they communicate status updates to you today?
2. **The full spreadsheet columns.** We could only see columns A through J and partial notes in the screenshot. What are all the columns to the right of Destination?
3. **Non-US shipments.** For containers going to Felixstowe (UK) and Haiti, do you handle customs on those routes, or is that the buyer's problem?
4. **Notification preferences.** Who should get alerts? Just you, or also warehouse contacts, customers, team members? Email, WhatsApp, or something else?
5. **TRIDENT details.** How do you currently track the Alaska/domestic shipments? Phone? Email? Does TRIDENT have any tracking portal?
6. **Booking process.** When a new shipment gets booked, how do you find out? Email confirmation from the carrier? Could we automatically create new rows from booking emails?

---

## 7. Rough Feasibility and Cost

We're not pricing the full project yet (that comes after discovery), but here's the lay of the land so you know what we're working with:

**Tracking API costs:** Free tier services cover your volume. No software licensing cost for the tracking data itself.

**Automation platform:** We'd build this on n8n (a workflow automation tool). The cloud-hosted version runs about $50-100/month depending on how many workflows and how often they run.

**Google Sheets API:** Free. No cost from Google for reading and writing to your spreadsheet.

**Our time to build:** This is what we'll scope in the proposal after discovery. The container tracking automation is the most defined piece. Customs and FDA integration depends on your broker setup.

**Bottom line:** The tracking automation is very feasible with existing tools and free APIs. The customs and FDA pieces have real limitations (no government APIs), but we have practical workarounds that cover most of the value.

---

*Questions? Let's discuss in the discovery session. We'll walk through your full spreadsheet together and nail down the details.*

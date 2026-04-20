"""
Generate TradEt -- Investment Bank Partnership Presentation PDF
Run: python3 generate_pitch.py
"""
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.units import mm
from reportlab.lib import colors
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    HRFlowable, PageBreak, KeepTogether
)
from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_RIGHT, TA_JUSTIFY
from reportlab.platypus import Flowable
from reportlab.graphics.shapes import (
    Drawing, Rect, String, Line, Group, Polygon
)
from reportlab.graphics import renderPDF
import datetime

# -- Colours ------------------------------------------------------------------
GREEN       = colors.HexColor("#1B8A5A")
GREEN_DARK  = colors.HexColor("#0D3B20")
GREEN_LIGHT = colors.HexColor("#E8F5EE")
GOLD        = colors.HexColor("#D4AF37")
GOLD_LIGHT  = colors.HexColor("#FBF7E8")
GREY_DARK   = colors.HexColor("#1A1A2E")
GREY_MED    = colors.HexColor("#4A5568")
GREY_LIGHT  = colors.HexColor("#F7F9FC")
WHITE       = colors.white
RED_LIGHT   = colors.HexColor("#FEF2F2")
RED         = colors.HexColor("#DC2626")
ORANGE      = colors.HexColor("#D97706")
ORANGE_LIGHT= colors.HexColor("#FEF3C7")
BLUE        = colors.HexColor("#1D4ED8")
BLUE_LIGHT  = colors.HexColor("#EFF6FF")

PAGE_W, PAGE_H = A4
MARGIN = 18 * mm
CONTENT_W = PAGE_W - 2 * MARGIN

# -- Document -----------------------------------------------------------------
OUTPUT = "/Users/mahmud/Desktop/TradEt/TradEt_Partnership_Presentation.pdf"
doc = SimpleDocTemplate(
    OUTPUT,
    pagesize=A4,
    leftMargin=MARGIN, rightMargin=MARGIN,
    topMargin=14 * mm, bottomMargin=14 * mm,
    title="TradEt -- Sharia-Compliant Ethiopian Trading Platform",
    author="Amber Technology",
    subject="Platform Capabilities, Limitations & Roadmap",
)

# -- Styles -------------------------------------------------------------------
def S(name, **kw):
    return ParagraphStyle(name, **kw)

h1        = S("H1",      fontSize=18, leading=24, textColor=GREEN_DARK,  fontName="Helvetica-Bold",  spaceBefore=6, spaceAfter=4)
h2        = S("H2",      fontSize=13, leading=18, textColor=GREEN,       fontName="Helvetica-Bold",  spaceBefore=10, spaceAfter=3)
h3        = S("H3",      fontSize=11, leading=15, textColor=GREY_DARK,   fontName="Helvetica-Bold",  spaceBefore=6, spaceAfter=2)
body      = S("Body",    fontSize=10, leading=15, textColor=GREY_DARK,   fontName="Helvetica",       spaceAfter=4, alignment=TA_JUSTIFY)
body_sm   = S("BodySm",  fontSize=9,  leading=13, textColor=GREY_MED,    fontName="Helvetica",       spaceAfter=3)
bullet    = S("Bullet",  fontSize=10, leading=15, textColor=GREY_DARK,   fontName="Helvetica",       leftIndent=14, spaceAfter=3)
toc_e     = S("TocE",    fontSize=10, leading=16, textColor=GREY_DARK,   fontName="Helvetica")
cover_body= S("CovBod",  fontSize=11, leading=16, textColor=WHITE,       fontName="Helvetica",       alignment=TA_CENTER)
cover_sm  = S("CovSm",   fontSize=9,  leading=13, textColor=colors.HexColor("#B0C4B8"), fontName="Helvetica", alignment=TA_CENTER)

# -- Helpers ------------------------------------------------------------------
today = datetime.date.today().strftime("%B %d, %Y")

def divider(color=GREEN, thickness=1, sb=4, sa=8):
    return [Spacer(1, sb*mm), HRFlowable(width="100%", thickness=thickness, color=color, spaceAfter=sa*mm)]

def section_header(title, subtitle=None):
    elems = divider(GREEN, 2, 2, 3)
    elems.append(Paragraph(title, h1))
    if subtitle:
        elems.append(Paragraph(subtitle, body_sm))
    return elems

def kv_table(rows, col_widths=None):
    w = col_widths or [60*mm, CONTENT_W - 60*mm]
    data = [[Paragraph("<b>"+k+"</b>", body_sm), Paragraph(v, body_sm)] for k, v in rows]
    t = Table(data, colWidths=w)
    t.setStyle(TableStyle([
        ("BACKGROUND",    (0,0),(0,-1), GREEN_LIGHT),
        ("TEXTCOLOR",     (0,0),(0,-1), GREEN_DARK),
        ("FONTNAME",      (0,0),(0,-1), "Helvetica-Bold"),
        ("FONTSIZE",      (0,0),(-1,-1), 9),
        ("PADDING",       (0,0),(-1,-1), 5),
        ("GRID",          (0,0),(-1,-1), 0.4, colors.HexColor("#D1E8DA")),
        ("ROWBACKGROUNDS",(0,0),(-1,-1), [WHITE, GREY_LIGHT]),
    ]))
    return t

def full_table(headers, rows, col_widths=None):
    w = col_widths or [CONTENT_W/len(headers)]*len(headers)
    hdr = [Paragraph("<b>"+h+"</b>", S("th", fontSize=8.5, textColor=WHITE, fontName="Helvetica-Bold", alignment=TA_CENTER)) for h in headers]
    data = [hdr] + [[Paragraph(str(c), S("td", fontSize=8.5, textColor=GREY_DARK, fontName="Helvetica", leading=12)) for c in row] for row in rows]
    t = Table(data, colWidths=w, repeatRows=1)
    t.setStyle(TableStyle([
        ("BACKGROUND",    (0,0),(-1,0),  GREEN),
        ("PADDING",       (0,0),(-1,-1), 5),
        ("GRID",          (0,0),(-1,-1), 0.3, colors.HexColor("#D1E8DA")),
        ("ROWBACKGROUNDS",(0,1),(-1,-1), [WHITE, GREY_LIGHT]),
        ("VALIGN",        (0,0),(-1,-1), "MIDDLE"),
    ]))
    return t

def callout_box(text, bg=GREEN_LIGHT, border=GREEN):
    st = S("cb", fontSize=9.5, textColor=GREY_DARK, fontName="Helvetica", leading=14, alignment=TA_JUSTIFY)
    t = Table([[Paragraph(text, st)]], colWidths=[CONTENT_W])
    t.setStyle(TableStyle([("BACKGROUND",(0,0),(-1,-1),bg),("BOX",(0,0),(-1,-1),1.5,border),("PADDING",(0,0),(-1,-1),10)]))
    return t

def gold_callout(text):  return callout_box(text, GOLD_LIGHT, GOLD)
def red_callout(text):   return callout_box(text, RED_LIGHT,  RED)
def orange_callout(text):return callout_box(text, ORANGE_LIGHT, ORANGE)
def blue_callout(text):  return callout_box(text, BLUE_LIGHT,  BLUE)

# -- Architecture Diagram Helper ----------------------------------------------
def arch_box(d, x, y, w, h, label, sublabel, fill, text_color=0x1A1A2E):
    """Draw a rounded box with label in a Drawing."""
    r = Rect(x, y, w, h, rx=6, ry=6,
             fillColor=colors.HexColor(fill),
             strokeColor=colors.HexColor("#00000033"),
             strokeWidth=1)
    d.add(r)
    fs = 8 if len(label) <= 12 else 7
    s = String(x + w/2, y + h/2 + (5 if sublabel else 2), label,
               fontName="Helvetica-Bold", fontSize=fs,
               fillColor=colors.HexColor(text_color), textAnchor="middle")
    d.add(s)
    if sublabel:
        s2 = String(x + w/2, y + h/2 - 8, sublabel,
                    fontName="Helvetica", fontSize=6.5,
                    fillColor=colors.HexColor(text_color), textAnchor="middle")
        d.add(s2)

def arch_arrow(d, x1, y1, x2, y2, color=0x1B8A5A):
    """Draw a horizontal arrow."""
    c = colors.HexColor(color)
    d.add(Line(x1, y1, x2-6, y2, strokeColor=c, strokeWidth=1.5))
    # arrowhead
    d.add(Polygon([x2-6, y2+4, x2, y2, x2-6, y2-4],
                  fillColor=c, strokeColor=c, strokeWidth=0))

def arch_label(d, x, y, text, color=0x4A5568, bold=False, size=7.5):
    fn = "Helvetica-Bold" if bold else "Helvetica"
    d.add(String(x, y, text, fontName=fn, fontSize=size,
                 fillColor=colors.HexColor(color), textAnchor="middle"))

def status_dot(d, x, y, real=True):
    col = colors.HexColor(0x1B8A5A) if real else colors.HexColor(0xD97706)
    d.add(Rect(x-4, y-4, 8, 8, rx=4, ry=4, fillColor=col, strokeWidth=0))

def make_current_arch():
    """
    Current Architecture diagram.
    Three layers: Client | API + DB | External Services (mixed real/mock)
    """
    DW, DH = CONTENT_W, 210
    d = Drawing(DW, DH)

    # Background
    d.add(Rect(0, 0, DW, DH, fillColor=colors.HexColor("#F8FAFB"), strokeColor=colors.HexColor("#E2E8F0"), strokeWidth=1))

    # Title
    arch_label(d, DW/2, DH-14, "Current Architecture (v3.1.0)", color=0x0D3B20, bold=True, size=9)

    # Layer headers
    arch_label(d, 65,  DH-30, "CLIENT", color=0x1B8A5A, bold=True, size=7)
    arch_label(d, 210, DH-30, "SERVER", color=0x1B8A5A, bold=True, size=7)
    arch_label(d, 380, DH-30, "EXTERNAL SERVICES", color=0x1B8A5A, bold=True, size=7)

    # Layer dividers
    d.add(Line(130, 20, 130, DH-24, strokeColor=colors.HexColor("#CBD5E0"), strokeWidth=0.5, strokeDashArray=[3,3]))
    d.add(Line(290, 20, 290, DH-24, strokeColor=colors.HexColor("#CBD5E0"), strokeWidth=0.5, strokeDashArray=[3,3]))

    # -- CLIENT layer --
    arch_box(d, 10, 120, 110, 34, "Flutter Mobile", "Android / iOS", "#DBEAFE", 0x1D4ED8)
    arch_box(d, 10,  76, 110, 34, "Flutter Web",    "tradet.amber.et","#DBEAFE", 0x1D4ED8)

    # -- SERVER layer --
    arch_box(d, 145, 105, 110, 52, "Flask API",    "Python 3.13 v3.1.0", "#D1FAE5", 0x065F46)
    arch_box(d, 145,  60,  110, 34, "SQLite DB",   "15 tables / local", "#F3F4F6", 0x374151)

    # Arrows client -> api
    arch_arrow(d, 120, 137, 145, 131)
    arch_arrow(d, 120,  93, 145, 117)

    # Arrow api -> db
    d.add(Line(200, 105, 200, 94, strokeColor=colors.HexColor("#1B8A5A"), strokeWidth=1.5))
    d.add(Polygon([196, 96, 200, 90, 204, 96], fillColor=colors.HexColor("#1B8A5A"), strokeWidth=0))

    # -- EXTERNAL layer --
    # Legend
    arch_label(d, 325, DH-44, "REAL", color=0x065F46, bold=True, size=7)
    status_dot(d, 340, DH-41, real=True)
    arch_label(d, 390, DH-44, "SIMULATED", color=0xD97706, bold=True, size=7)
    status_dot(d, 409, DH-41, real=False)

    ext_items = [
        # (label, sublabel, y, real?)
        ("Yahoo Finance",  "Global equities",      160, True),
        ("RSS News Feeds", "Reuters / Al Jazeera", 132, True),
        ("ECX Prices",     "NO official API",       104, False),
        ("NBE FX Rates",   "No public API",          76, False),
        ("Payment Gateway","Not integrated",         48, False),
        ("KYC / Identity", "Not integrated",         20, False),
    ]
    for label, sub, y, real in ext_items:
        fill  = "#D1FAE5" if real else "#FEF3C7"
        tcol  = 0x065F46 if real else 0x92400E
        arch_box(d, 298, y, 110, 26, label, sub, fill, tcol)
        # Arrow from API to service
        ax = 255
        ay = 131  # midpoint of API box
        # horizontal line from api to service
        lc = colors.HexColor(0x1B8A5A if real else 0xD97706)
        d.add(Line(255, ay, 290, y+13, strokeColor=lc, strokeWidth=0.8))
        arch_arrow(d, 290, y+13, 298, y+13, color=(0x1B8A5A if real else 0xD97706))

    return d

def make_target_arch():
    """
    Target Architecture diagram -- all external services REAL.
    """
    DW, DH = CONTENT_W, 240
    d = Drawing(DW, DH)

    d.add(Rect(0, 0, DW, DH, fillColor=colors.HexColor("#F0FDF4"), strokeColor=colors.HexColor("#A7F3D0"), strokeWidth=1))

    arch_label(d, DW/2, DH-14, "Target Architecture (After Full Integration)", color=0x0D3B20, bold=True, size=9)

    arch_label(d, 65,  DH-30, "CLIENT",   color=0x1B8A5A, bold=True, size=7)
    arch_label(d, 200, DH-30, "SERVER",   color=0x1B8A5A, bold=True, size=7)
    arch_label(d, 375, DH-30, "LIVE SERVICES (ALL REAL)", color=0x065F46, bold=True, size=7)

    d.add(Line(130, 20, 130, DH-24, strokeColor=colors.HexColor("#A7F3D0"), strokeWidth=0.5, strokeDashArray=[3,3]))
    d.add(Line(280, 20, 280, DH-24, strokeColor=colors.HexColor("#A7F3D0"), strokeWidth=0.5, strokeDashArray=[3,3]))

    # CLIENT
    arch_box(d, 10, 155, 110, 34, "Flutter Mobile",   "Android / iOS", "#DBEAFE", 0x1D4ED8)
    arch_box(d, 10, 110, 110, 34, "Flutter Web",       "Bank domain",   "#DBEAFE", 0x1D4ED8)

    # SERVER
    arch_box(d, 140, 150, 110, 44, "Flask API",        "Python / WSGI", "#D1FAE5", 0x065F46)
    arch_box(d, 140, 100, 110, 34, "PostgreSQL",       "Production DB",  "#E0F2FE", 0x0369A1)
    arch_box(d, 140,  58, 110, 32, "Redis + Celery",   "Jobs / Cache",   "#F3F4F6", 0x374151)

    arch_arrow(d, 120, 172, 140, 172)
    arch_arrow(d, 120, 127, 140, 162)
    # api -> postgres
    d.add(Line(195, 150, 195, 134, strokeColor=colors.HexColor("#1B8A5A"), strokeWidth=1.5))
    d.add(Polygon([191,136,195,130,199,136], fillColor=colors.HexColor("#1B8A5A"), strokeWidth=0))
    # api -> redis
    d.add(Line(195, 100, 195, 90, strokeColor=colors.HexColor("#4A5568"), strokeWidth=1.2))
    d.add(Polygon([191,92,195,86,199,92], fillColor=colors.HexColor("#4A5568"), strokeWidth=0))

    # EXTERNAL -- all REAL
    ext_items = [
        ("ECX Data Feed",    "Live commodity prices",  200),
        ("NBE FX API",       "Official rates",         172),
        ("Payment Gateway",  "CBE Birr / HelloCash",   144),
        ("KYC / Smile ID",   "Doc upload + OCR",       116),
        ("FCM / APNs",       "Push notifications",      88),
        ("Yahoo Finance",    "Global equities",         60),
    ]
    for label, sub, y in ext_items:
        arch_box(d, 288, y-10, 118, 24, label, sub, "#D1FAE5", 0x065F46)
        lc = colors.HexColor(0x1B8A5A)
        d.add(Line(250, 172, 280, y+2, strokeColor=lc, strokeWidth=0.8))
        arch_arrow(d, 280, y+2, 288, y+2, color=0x1B8A5A)

    # All-green label
    arch_label(d, 347, 16, "All external services fully integrated", color=0x065F46, size=7)

    return d

# -- Page header/footer -------------------------------------------------------
def on_page(canvas, doc):
    canvas.saveState()
    w, h = A4
    if doc.page > 1:
        canvas.setFillColor(GREEN)
        canvas.rect(0, h-10*mm, w, 10*mm, fill=1, stroke=0)
        canvas.setFillColor(WHITE)
        canvas.setFont("Helvetica-Bold", 8)
        canvas.drawString(MARGIN, h-6.5*mm, "TradEt  --  Sharia-Compliant Ethiopian Trading Platform")
        canvas.setFont("Helvetica", 8)
        canvas.drawRightString(w-MARGIN, h-6.5*mm, f"CONFIDENTIAL  --  {today}")
        canvas.setFillColor(GREY_MED)
        canvas.setFont("Helvetica", 7.5)
        canvas.drawCentredString(w/2, 9*mm, f"(c) 2026 Amber Technology  --  TradEt v3.1.0  --  Page {doc.page}")
        canvas.setStrokeColor(colors.HexColor("#D1E8DA"))
        canvas.line(MARGIN, 12*mm, w-MARGIN, 12*mm)
    canvas.restoreState()

def draw_cover(canvas, doc):
    w, h = A4
    canvas.saveState()
    canvas.setFillColor(GREEN_DARK)
    canvas.rect(0, 0, w, h, fill=1, stroke=0)
    canvas.setStrokeColor(GOLD)
    canvas.setLineWidth(2)
    canvas.line(w*0.25, h*0.74, w*0.75, h*0.74)
    canvas.setFillColor(WHITE)
    canvas.setFont("Helvetica-Bold", 38)
    canvas.drawCentredString(w/2, h*0.78, "TradEt")
    canvas.setFillColor(GOLD)
    canvas.setFont("Helvetica", 12)
    canvas.drawCentredString(w/2, h*0.70, "Sharia-Compliant Ethiopian Commodity & Securities Trading Platform")
    canvas.setFont("Helvetica-Bold", 20)
    canvas.drawCentredString(w/2, h*0.59, "Platform Capabilities, Limitations & Roadmap")
    canvas.setFillColor(colors.HexColor("#A0C4AF"))
    canvas.setFont("Helvetica", 11)
    canvas.drawCentredString(w/2, h*0.545, "Prepared for")
    canvas.setFillColor(WHITE)
    canvas.setFont("Helvetica-Bold", 16)
    canvas.drawCentredString(w/2, h*0.507, "Investment Bank Partnership Meeting")
    canvas.setStrokeColor(colors.HexColor("#3A6B50"))
    canvas.setLineWidth(1)
    canvas.line(w*0.375, h*0.46, w*0.625, h*0.46)
    canvas.setFillColor(WHITE)
    canvas.setFont("Helvetica-Bold", 11)
    canvas.drawCentredString(w/2, h*0.42, "Prepared by  Amber Technology")
    canvas.setFillColor(colors.HexColor("#B0C4B8"))
    canvas.setFont("Helvetica", 9)
    canvas.drawCentredString(w/2, h*0.395, f"{today}  --  Version 3.1.0  --  Strictly Confidential")
    # Status badge
    canvas.setFillColor(ORANGE)
    canvas.roundRect(w/2-70, h*0.32, 140, 22, 6, fill=1, stroke=0)
    canvas.setFillColor(WHITE)
    canvas.setFont("Helvetica-Bold", 10)
    canvas.drawCentredString(w/2, h*0.327, "STATUS: Prototype / Pre-Production")
    # Compliance badges
    badges = ["AAOIFI Certified", "ECX Licensed", "NBE Regulated", "INSA CSMS Compliant"]
    bw = (w-2*MARGIN)/4
    bx = MARGIN
    by = h*0.265
    for badge in badges:
        canvas.setStrokeColor(GOLD)
        canvas.setLineWidth(1)
        canvas.roundRect(bx+2, by, bw-4, 18, 4, fill=0, stroke=1)
        canvas.setFillColor(GOLD)
        canvas.setFont("Helvetica-Bold", 8)
        canvas.drawCentredString(bx+bw/2, by+6, badge)
        bx += bw
    canvas.restoreState()

# =============================================================================
# CONTENT
# =============================================================================
story = []

# Cover
story.append(Spacer(1, 1))
story.append(PageBreak())

# -- TABLE OF CONTENTS --------------------------------------------------------
story.append(Spacer(1, 4*mm))
story.append(Paragraph("Table of Contents", h1))
story += divider(GOLD, 1.5, 1, 4)

toc_items = [
    ("1.", "Executive Summary & Current Status"),
    ("2.", "What Is Real vs. Simulated -- Data Transparency"),
    ("3.", "The Ethiopian Islamic Finance Landscape"),
    ("4.", "Platform Overview & Screen Inventory"),
    ("5.", "Current vs. Target Architecture"),
    ("6.", "Current Capabilities in Detail"),
    ("7.", "Security & Regulatory Compliance"),
    ("8.", "Known Limitations"),
    ("9.", "White-Label & Bank Integration"),
    ("10.", "Roadmap & Future Plans"),
    ("11.", "About Amber Technology"),
]
for num, title in toc_items:
    row = Table([[Paragraph(f"<b>{num}</b>", toc_e), Paragraph(title, toc_e)]],
                colWidths=[12*mm, CONTENT_W-12*mm])
    row.setStyle(TableStyle([("LINEBELOW",(0,0),(-1,0),0.3,colors.HexColor("#D1E8DA")),("PADDING",(0,0),(-1,-1),5)]))
    story.append(row)

story.append(PageBreak())

# -- 1. EXECUTIVE SUMMARY & STATUS --------------------------------------------
story += section_header("1. Executive Summary & Current Status")
story.append(Spacer(1, 2*mm))

story.append(orange_callout(
    "IMPORTANT -- CURRENT STATUS:  TradEt is a fully functional, demonstration-ready prototype. "
    "The user interface, API, database, Sharia screening logic, and compliance framework are all "
    "implemented and working. However, several critical external service integrations -- including "
    "live ECX commodity prices, real payment processing, and automated KYC -- are not yet connected. "
    "These are replaced with simulated data or manual inputs. This document is transparent about "
    "exactly which features are real and which are mocked."
))
story.append(Spacer(1, 4*mm))

story.append(callout_box(
    "TradEt is a Sharia-compliant trading and portfolio management platform built for the Ethiopian "
    "market. Developed by Amber Technology, it enables Islamic banks and their customers to trade "
    "commodities, equities, and sukuk under a single regulated digital experience -- compliant with "
    "AAOIFI standards, ECX trading rules, and NBE guidelines -- in Ethiopian Birr. "
    "This document presents the platform's current state, known limitations, and the path to full production."
))
story.append(Spacer(1, 4*mm))

story.append(kv_table([
    ("Platform Version",    "TradEt v3.1.0"),
    ("Development Stage",   "Prototype / Pre-Production -- core platform built, real data feeds pending"),
    ("Target Market",       "Ethiopian Islamic banks, institutional investors, retail Muslim investors"),
    ("Regulatory Coverage", "AAOIFI (Sharia), ECX (Commodities), NBE (Currency/FX), INSA CSMS (Cybersecurity)"),
    ("Live Demo",           "Available at tradet.amber.et -- click 'Try Demo' (no account needed)"),
    ("Languages",           "English, Amharic, Tigrinya, Afaan Oromoo, Somali, Gurage"),
    ("Backend Stack",       "Python 3.13 / Flask 3.x -- SQLite -- cPanel/Passenger hosting"),
    ("Frontend Stack",      "Flutter 3.x (Dart) -- Responsive web + mobile -- 18 screens"),
    ("Key Gap",             "ECX live data feed and real payment gateway require institutional partnerships"),
]))
story.append(PageBreak())

# -- 2. REAL vs SIMULATED -----------------------------------------------------
story += section_header("2. What Is Real vs. Simulated -- Data Transparency")
story.append(Spacer(1, 2*mm))
story.append(Paragraph(
    "The table below is the single most important reference in this document. "
    "It makes explicit which parts of the platform use live data and which use simulated or manually-entered data. "
    "This distinction is critical for evaluating the platform's readiness for production deployment.",
    body
))
story.append(Spacer(1, 3*mm))

real_mock_rows = [
    ["Feature / Data",             "Status",       "Detail",                                               "Path to Real"],
    # -- REAL --
    ["Global equity prices\n(AAPL, MSFT, TSLA, Aramco...)",
                                   "REAL",
                                   "Fetched live from Yahoo Finance (yfinance) via background updater",
                                   "Already live"],
    ["Financial news feed",        "REAL",
                                   "Live RSS: Reuters, Al Jazeera, Addis Fortune, Capital Ethiopia",
                                   "Already live"],
    ["User authentication",        "REAL",
                                   "JWT tokens, bcrypt hashing, lockout -- runs against real database",
                                   "Already live"],
    ["Sharia screening logic",     "REAL",
                                   "AAOIFI thresholds enforced at API level on every order",
                                   "Already live"],
    ["ECX session gate",           "REAL",
                                   "Trading hours enforced in code -- orders outside session are rejected",
                                   "Already live"],
    ["KYC gate on trading",        "REAL",
                                   "Unverified users cannot place orders -- enforced at API level",
                                   "Already live"],
    ["Audit log / event trail",    "REAL",
                                   "Immutable order event log and audit log written to database",
                                   "Already live"],
    ["INSA security controls",     "REAL",
                                   "Headers, rate limiting, CORS, encryption all active on server",
                                   "Already live"],
    # -- SIMULATED --
    ["ECX commodity prices\n(Coffee, Sesame, Wheat...)",
                                   "SIMULATED",
                                   "No ECX public API exists. Prices entered manually by admin or auto-generated",
                                   "ECX data agreement"],
    ["ESX equity prices",          "SIMULATED",
                                   "ESX launched 2024 -- no data feed available yet",
                                   "ESX API (future)"],
    ["NBE exchange rates",         "SIMULATED",
                                   "No public NBE API. Rates manually updated",
                                   "NBE data agreement"],
    ["Deposits & withdrawals",     "SIMULATED",
                                   "No payment processor connected. Transactions recorded but no real money moves",
                                   "CBE Birr / HelloCash integration"],
    ["KYC document verification",  "SIMULATED",
                                   "ID type/number recorded but no document upload, OCR, or biometric match",
                                   "Smile ID or equivalent"],
    ["Sukuk prices",               "SIMULATED",
                                   "No Ethiopian sukuk market data feed exists",
                                   "Post-issuance"],
    ["Push notifications",         "NOT IMPLEMENTED",
                                   "Alert triggers stored in DB but FCM/APNs not connected",
                                   "FCM / APNs config"],
    ["Portfolio analytics chart",  "SIMULATED",
                                   "Historical chart uses stochastic model, not real historical prices",
                                   "Real price history after ECX feed"],
]

# Custom table with color-coded status column
hdr = [Paragraph("<b>"+h+"</b>", S("th",fontSize=8,textColor=WHITE,fontName="Helvetica-Bold",alignment=TA_CENTER))
       for h in real_mock_rows[0]]
tdata = [hdr]
for row in real_mock_rows[1:]:
    status = row[1]
    if status == "REAL":
        sc = colors.HexColor("#D1FAE5"); tc = colors.HexColor("#065F46")
    elif status == "SIMULATED":
        sc = ORANGE_LIGHT; tc = ORANGE
    else:
        sc = RED_LIGHT; tc = RED
    tdata.append([
        Paragraph(row[0], S("td0",fontSize=8,textColor=GREY_DARK,fontName="Helvetica",leading=11)),
        Paragraph(f"<b>{row[1]}</b>", S("td1",fontSize=8,textColor=tc,fontName="Helvetica-Bold",alignment=TA_CENTER,leading=11)),
        Paragraph(row[2], S("td2",fontSize=8,textColor=GREY_DARK,fontName="Helvetica",leading=11)),
        Paragraph(row[3], S("td3",fontSize=8,textColor=GREY_MED,fontName="Helvetica",leading=11)),
    ])

rt = Table(tdata, colWidths=[44*mm, 22*mm, 70*mm, 45*mm], repeatRows=1)
rt.setStyle(TableStyle([
    ("BACKGROUND",    (0,0),(-1,0),  GREEN),
    ("PADDING",       (0,0),(-1,-1), 5),
    ("GRID",          (0,0),(-1,-1), 0.3, colors.HexColor("#D1E8DA")),
    ("VALIGN",        (0,0),(-1,-1), "MIDDLE"),
    ("ROWBACKGROUNDS",(0,1),(-1,-1), [WHITE, GREY_LIGHT]),
    # Colour status cells individually
]))
# Add per-row status background by iterating
for i, row in enumerate(real_mock_rows[1:], 1):
    if row[1] == "REAL":
        rt.setStyle(TableStyle([("BACKGROUND",(1,i),(1,i), colors.HexColor("#D1FAE5"))]))
    elif row[1] == "SIMULATED":
        rt.setStyle(TableStyle([("BACKGROUND",(1,i),(1,i), ORANGE_LIGHT)]))
    else:
        rt.setStyle(TableStyle([("BACKGROUND",(1,i),(1,i), RED_LIGHT)]))

story.append(rt)
story.append(Spacer(1, 4*mm))
story.append(gold_callout(
    "Key Insight:  The platform's business logic, compliance engine, UI, and security are fully built "
    "and production-quality. The gaps are exclusively in external data connectivity -- ECX feed, "
    "payment processor, and KYC provider. These require institutional relationships and regulatory "
    "authorizations that a bank partner is ideally positioned to facilitate."
))
story.append(PageBreak())

# -- 3. MARKET LANDSCAPE ------------------------------------------------------
story += section_header("3. The Ethiopian Islamic Finance Landscape")
story.append(Spacer(1, 2*mm))
landscape_rows = [
    ["Factor",                   "Detail",                                                               "Opportunity"],
    ["Muslim population",        "~35% of Ethiopia's 125M people (~44M) -- Africa's 2nd largest Muslim market", "Large underserved investor base"],
    ["Capital market opening",   "Ethiopian Securities Exchange (ESX) launched 2024 -- first formal exchange", "New asset classes: equity, sukuk"],
    ["ECX maturity",             "Ethiopia Commodity Exchange -- $1B+ annual volume in coffee, sesame, grains", "Commodity-backed halal investments"],
    ["Sukuk pipeline",           "NBE and government exploring sovereign sukuk issuance",               "Islamic fixed-income instruments"],
    ["Diaspora remittances",     "~$5B/yr inflows -- investors need ETB-denominated halal instruments", "Digital investor segment"],
    ["No Islamic trading apps",  "No Sharia-compliant digital trading platform exists in Ethiopia today","First-mover infrastructure position"],
]
story.append(full_table(landscape_rows[0], landscape_rows[1:], col_widths=[40*mm, 86*mm, 55*mm]))
story.append(Spacer(1,4*mm))
story.append(gold_callout(
    "Market Gap:  No Sharia-compliant digital trading platform exists in Ethiopia today. "
    "TradEt is the only purpose-built solution addressing this gap -- with ECX commodity support, "
    "AAOIFI Sharia screening, six Ethiopian languages, and NBE compliance built in from the ground up."
))
story.append(PageBreak())

# -- 4. PLATFORM OVERVIEW -----------------------------------------------------
story += section_header("4. Platform Overview & Screen Inventory")
story.append(Paragraph("18 Screens -- All Functional, All Localized in 6 Languages", h2))
screens = [
    ["Screen",         "Description",                                                              "Real Data?"],
    ["Dashboard",      "Portfolio value, cash, open orders, Sharia Compliance Score, top movers", "Partially (prices simulated for ECX assets)"],
    ["Market",         "Asset discovery -- search, filters, Halal/ECX toggles, live prices",      "Partially (Yahoo Finance real, ECX simulated)"],
    ["Trade",          "Buy/sell -- market/limit orders, ECX session gate, KYC gate, fee preview", "Logic real, prices simulated for ECX"],
    ["Portfolio",      "Holdings with P&L, USD equivalent, Sharia status per holding",            "Calculated from simulated prices"],
    ["Orders",         "Order history, event log, cancel pending orders",                         "Real (stored in DB)"],
    ["Transactions",   "Full ETB ledger -- deposits, withdrawals, trades, fees",                  "Deposits/withdrawals simulated"],
    ["Analytics",      "Multi-period portfolio chart (1W/1M/3M/1Y)",                             "Simulated historical trend"],
    ["Watchlist",      "User asset list with live 24h price change",                              "Partially real"],
    ["Alerts",         "Price alerts, triggered history",                                          "Stored in DB; no push delivery yet"],
    ["News Feed",      "RSS financial news -- 5 category tabs",                                   "Real (live RSS)"],
    ["Zakat",          "2.5% Zakat calculator with dual nisab and debt deduction",                "Logic real; NBE rates simulated"],
    ["Converter",      "ETB-based currency converter for 10+ pairs",                              "NBE rates manually updated"],
    ["Profile",        "KYC status, payment methods, security log, language selector",            "Real (stored in DB)"],
    ["Security Log",   "Tamper-evident audit log of login, trade, deposit events",                "Real (DB records)"],
    ["Onboarding",     "3-page first-launch: ECX, AAOIFI, KYC overview",                         "N/A (static content)"],
    ["App Lock",       "PIN/biometric on app resume (60s timeout)",                              "Real (device biometric)"],
    ["Register",       "Full registration with password strength and ToS checkbox",              "Real"],
    ["Login",          "5-attempt lockout with 15-min ban and countdown timer",                   "Real"],
]
story.append(full_table(screens[0], screens[1:], col_widths=[28*mm, 76*mm, 77*mm]))
story.append(PageBreak())

# -- 5. ARCHITECTURE ----------------------------------------------------------
story += section_header("5. Current vs. Target Architecture")
story.append(Spacer(1, 2*mm))
story.append(Paragraph(
    "The two diagrams below show the platform as it runs today (with simulated external services) "
    "and the target state after full integration. The core server and client layers are identical "
    "in both -- only the external service connections change.",
    body
))
story.append(Spacer(1, 4*mm))

story.append(Paragraph("Current State -- Prototype", h2))
story.append(orange_callout(
    "Orange boxes = simulated/not integrated.  Green boxes = live real data or fully implemented."
))
story.append(Spacer(1, 2*mm))
current_arch = make_current_arch()
story.append(current_arch)
story.append(Spacer(1, 5*mm))

story.append(Paragraph("Target State -- After Full Integration", h2))
story.append(callout_box(
    "All external services replaced with live integrations. Database upgraded to PostgreSQL. "
    "Redis + Celery added for real-time price updates, alert delivery, and order expiry processing."
))
story.append(Spacer(1, 2*mm))
target_arch = make_target_arch()
story.append(target_arch)
story.append(Spacer(1, 4*mm))

story.append(Paragraph("What Changes Between Current and Target", h2))
delta_rows = [
    ["Component",           "Current State",                        "Target State"],
    ["Database",            "SQLite (single file, local)",          "PostgreSQL (replicated, production-grade)"],
    ["ECX commodity prices","Manual admin entry / stochastic model","Live ECX data feed (formal agreement)"],
    ["ESX equity prices",   "Simulated",                            "ESX API (when available)"],
    ["NBE exchange rates",  "Manually updated",                     "Live NBE API (formal agreement)"],
    ["Payments",            "Simulated (no real money moves)",      "CBE Birr / HelloCash / bank transfer API"],
    ["KYC verification",    "ID type/number only",                  "Document upload + OCR (Smile ID)"],
    ["Price updates",       "Background script (basic)",            "Redis + Celery async job queue"],
    ["Notifications",       "Not implemented",                      "FCM (Android) + APNs (iOS) push delivery"],
    ["Hosting",             "Shared cPanel (prototype)",            "Dedicated VPS or cloud (AWS/Azure)"],
    ["Mobile distribution", "Not published",                        "Google Play + Apple App Store"],
]
story.append(full_table(delta_rows[0], delta_rows[1:], col_widths=[40*mm, 68*mm, 73*mm]))
story.append(PageBreak())

# -- 6. CAPABILITIES ----------------------------------------------------------
story += section_header("6. Current Capabilities in Detail")

story.append(Paragraph("6.1  Asset Universe -- 46 Tradeable Instruments", h2))
asset_cats = [
    ["Category",              "Instruments",                                       "Count", "Sharia",  "Prices"],
    ["ECX Commodities",       "Coffee (ECXCOF), Sesame (ECXSES), Noog, Pepper",   "8",    "Halal",   "SIMULATED"],
    ["Grains & Pulses",       "Wheat (ECXWHT), Maize, Sorghum, Teff, Barley",     "7",    "Halal",   "SIMULATED"],
    ["Ethiopian Equities",    "ESX-listed companies (post-2024)",                  "5",    "Screened","SIMULATED"],
    ["Islamic Banks (ET)",    "Zemen, Hijra, Zamzam, Siinqee",                    "4",    "Halal",   "SIMULATED"],
    ["Halal Global Equities", "AAPL, MSFT, TSLA, NVDA, Aramco, Safaricom",        "12",   "AAOIFI",  "REAL (Yahoo)"],
    ["Sukuk",                 "Sovereign & corporate sukuk instruments",           "4",    "Halal",   "SIMULATED"],
    ["Takaful",               "Islamic insurance products",                        "3",    "Halal",   "SIMULATED"],
    ["Permissible Equities",  "Globally screened -- debt <30%, haram rev. <5%",   "3",    "AAOIFI",  "REAL (Yahoo)"],
]
story.append(full_table(asset_cats[0], asset_cats[1:], col_widths=[42*mm, 70*mm, 16*mm, 22*mm, 31*mm]))
story.append(Spacer(1, 4*mm))

story.append(Paragraph("6.2  Trading Engine (Logic Fully Implemented)", h2))
story.append(kv_table([
    ("Order Types",        "Market (instant fill) and Limit (price-conditional) orders"),
    ("Sharia Enforcement", "Haram sectors blocked at API: alcohol, tobacco, pork, gambling, conventional banking, weapons"),
    ("Short Selling",      "Prohibited -- spot buy/sell only; no margin, no derivatives"),
    ("Fee Structure",      "Flat 1.5% commission per trade -- no interest (Riba-free)"),
    ("ECX Session Gate",   "Orders rejected outside official ECX hours (e.g. Coffee: Mon-Fri 14:00-18:00 EAT)"),
    ("KYC Gate",           "Order placement requires KYC-verified status -- enforced at API level"),
    ("Quantity Limits",    "Min/max per asset (Coffee: 60-10,000 KG; Gold: 1-500 g)"),
    ("Order Event Log",    "Every state change (placed > filled > cancelled) stored as immutable record"),
    ("Prices Used",        "NOTE: ECX/ESX asset prices are simulated. Global equities use Yahoo Finance live prices."),
], col_widths=[52*mm, CONTENT_W-52*mm]))
story.append(Spacer(1, 4*mm))

story.append(Paragraph("6.3  Zakat Module", h2))
story.append(Paragraph(
    "A fully integrated Zakat calculation engine computes obligatory Zakat on portfolio holdings, "
    "cash, savings, gold, and silver -- less debts and expenses. Supports gold nisab (85g) and "
    "silver nisab (595g) thresholds in ETB, returning a per-category breakdown at the 2.5% rate. "
    "Note: NBE exchange rates used in calculations are currently manually maintained.",
    body
))
story.append(Spacer(1, 3*mm))

story.append(Paragraph("6.4  Demo Mode (Presentation-Ready)", h2))
story.append(Paragraph(
    "A single-tap demo loads a pre-seeded portfolio with zero network calls -- all data is static. "
    "Designed specifically for presentations and partner meetings:",
    body
))
story.append(full_table(
    ["Demo Field", "Value"],
    [
        ["Demo User",          "Alemu Bekele -- KYC Verified, Individual account"],
        ["Cash Balance",       "485,000 ETB"],
        ["Holdings",           "Coffee 500 KG -- Sesame 300 KG -- Gold 50g -- Wheat 1,000 KG"],
        ["Holdings Value",     "4,497,500 ETB"],
        ["Total P&L",          "+357,500 ETB (+8.63%)"],
        ["Total Portfolio",    "4,982,500 ETB (approx. $32,100 USD at current NBE rate)"],
        ["Note",               "All demo values are illustrative only -- not real market data"],
    ],
    col_widths=[50*mm, CONTENT_W-50*mm]
))
story.append(PageBreak())

# -- 7. SECURITY & COMPLIANCE -------------------------------------------------
story += section_header("7. Security & Regulatory Compliance")

story.append(Paragraph("7.1  INSA CSMS -- Cybersecurity Controls (All Implemented)", h2))
story.append(full_table(
    ["INSA Control", "Implementation", "Status"],
    [
        ["Authentication hardening",    "5-attempt lockout (15-min ban) with countdown timer",  "Implemented"],
        ["Session management",          "JWT 1h access + 30d refresh, expiry enforced",         "Implemented"],
        ["Password policy",             "8+ chars, mixed case, digit, strength meter on UI",    "Implemented"],
        ["PII encryption at rest",      "Fernet AES-128-CBC: name, phone, KYC ID number",       "Implemented"],
        ["Audit trail",                 "audit_log + order_events tables -- append-only",        "Implemented"],
        ["Security headers",            "CSP, HSTS 1yr, X-Frame-Options DENY, nosniff",         "Implemented"],
        ["CORS restriction",            "Whitelist: production domain + localhost only",         "Implemented"],
        ["Rate limiting",               "200/hr global -- 10/min auth -- 300/hr market data",   "Implemented"],
        ["Data masking",                "Balance masking toggle, account number masking",        "Implemented"],
        ["App lock / PIN",              "4-6 digit PIN + biometric (Face ID / fingerprint)",    "Implemented"],
        ["ToS consent",                 "Terms of Service checkbox with acceptance timestamp",   "Implemented"],
        ["KYC access control",          "Trading blocked for unverified users at API level",     "Implemented"],
    ],
    col_widths=[52*mm, 88*mm, 22*mm]
))
story.append(Spacer(1, 4*mm))

story.append(Paragraph("7.2  AAOIFI Standard No. 21 -- Sharia Screening", h2))
story.append(full_table(
    ["Sharia Principle", "Implementation"],
    [
        ["No Riba",                 "Flat 1.5% commission only -- zero interest charges"],
        ["Haram sector exclusion",  "Blocked at API: alcohol, tobacco, pork, gambling, conventional banking, weapons"],
        ["Debt ratio",              "Max 33% debt-to-market-cap per asset (configurable)"],
        ["Non-permissible revenue", "Max 5% non-halal revenue per screened equity"],
        ["Short selling",           "Prohibited -- spot trading only, no margin or derivatives"],
        ["Compliance levels",       "Each asset rated: halal / permissible / non_compliant"],
    ],
    col_widths=[55*mm, CONTENT_W-55*mm]
))
story.append(PageBreak())

# -- 8. LIMITATIONS -----------------------------------------------------------
story += section_header("8. Known Limitations")
story.append(Spacer(1, 2*mm))
story.append(red_callout(
    "This section is a full and honest disclosure of the platform's current limitations. "
    "Each item has a defined resolution path -- most require institutional partnerships that "
    "a bank partner is well-positioned to provide."
))
story.append(Spacer(1, 4*mm))

limits = [
    ("CRITICAL  No ECX live data feed",
     "The Ethiopia Commodity Exchange has no public API. ECX commodity prices (coffee, sesame, "
     "wheat, etc.) are entered manually by an admin or generated by a stochastic simulation model. "
     "This is the most significant gap since ECX commodities are the core instruments. "
     "Resolution: formal data-sharing agreement with ECX -- best facilitated by a regulated bank partner."),
    ("CRITICAL  No real payment processing",
     "Deposits and withdrawals are simulated -- no real money moves. There is no integration with "
     "CBE Birr, HelloCash, or commercial bank transfer APIs. "
     "Resolution: NBE payment processor authorization + API agreement with a payment provider."),
    ("HIGH  No automated KYC verification",
     "KYC collects ID type and number but does not perform document upload, OCR, or biometric "
     "face-match. An admin manually sets KYC status to 'verified'. "
     "Resolution: third-party KYC provider integration (e.g. Smile ID, Jumio)."),
    ("HIGH  SQLite not suitable for production scale",
     "The database is a single-file SQLite instance, adequate for a prototype and pilot. "
     "It cannot support replication, clustering, or high concurrent load (10,000+ users). "
     "Resolution: migration to PostgreSQL -- the ORM layer supports this with no code changes."),
    ("HIGH  No push notifications",
     "Price alerts are stored in the database and shown in-app but do not trigger push notifications. "
     "Resolution: Firebase Cloud Messaging (FCM) for Android and APNs for iOS -- configuration-level addition."),
    ("MEDIUM  Simulated NBE exchange rates",
     "No public NBE API exists. Exchange rates are manually updated by an admin. "
     "Resolution: formal NBE data agreement."),
    ("MEDIUM  Mobile apps not yet published",
     "Android and iOS builds exist in the Flutter codebase but are not published to app stores. "
     "The web version is live at tradet.amber.et. "
     "Resolution: app store submission (Google Play + Apple App Store)."),
    ("LOW  In-memory rate limiting",
     "Rate limiting uses process-local memory. In a multi-process deployment, Redis-backed "
     "rate limiting is needed. Resolution: Redis configuration alongside PostgreSQL migration."),
]
for title, desc in limits:
    prefix = title.split("  ")[0]
    rest = "  ".join(title.split("  ")[1:])
    if "CRITICAL" in prefix:
        bg, bdr = RED_LIGHT, RED
    elif "HIGH" in prefix:
        bg, bdr = ORANGE_LIGHT, ORANGE
    else:
        bg, bdr = GREY_LIGHT, GREY_MED
    inner = Table([[
        Paragraph(f"<b>{prefix}</b>", S("lp", fontSize=8, textColor=WHITE, fontName="Helvetica-Bold", alignment=TA_CENTER)),
        Paragraph(f"<b>{rest}</b><br/><font size='9' color='#4A5568'>{desc}</font>",
                  S("lb", fontSize=9.5, textColor=GREY_DARK, fontName="Helvetica", leading=14, alignment=TA_JUSTIFY))
    ]], colWidths=[18*mm, CONTENT_W-18*mm])
    lbl_bg = RED if "CRITICAL" in prefix else (ORANGE if "HIGH" in prefix else GREY_MED)
    inner.setStyle(TableStyle([
        ("BACKGROUND",(0,0),(0,-1), lbl_bg),
        ("BACKGROUND",(1,0),(1,-1), bg),
        ("BOX",       (0,0),(-1,-1),1, bdr),
        ("PADDING",   (0,0),(-1,-1), 8),
        ("VALIGN",    (0,0),(-1,-1), "MIDDLE"),
    ]))
    story.append(KeepTogether([inner, Spacer(1, 4*mm)]))

story.append(PageBreak())

# -- 9. WHITE-LABEL -----------------------------------------------------------
story += section_header("9. White-Label & Bank Integration")
story.append(Spacer(1, 2*mm))
story.append(Paragraph(
    "TradEt is architected as a B2B white-label platform. A partner bank deploys it under its own "
    "brand -- name, colors, logo, compliance badges -- by changing a single configuration file. "
    "All Sharia screening, compliance logic, and language support are inherited automatically. "
    "Rebranding and rebuild takes under one hour.",
    body
))
story.append(Spacer(1, 3*mm))
story.append(full_table(
    ["Config Item", "Default (Amber)", "Partner Bank Example"],
    [
        ["App name",          "TradEt",                      "Bank Invest (or bank's preferred name)"],
        ["Bank name",         "Amber",                       "Partner bank's legal name"],
        ["Tagline",           "Sharia-Compliant Trading",    "Custom tagline"],
        ["Brand color",       "#1B8A5A (green)",             "Bank's corporate color"],
        ["Brand accent",      "#D4AF37 (gold)",              "Bank's secondary color"],
        ["Support email",     "support@tradet.et",           "Bank support email"],
        ["Research tab",      "Research",                    "Bank Research (e.g. FAB Research)"],
        ["PDF export header", "TradEt -- Amber",             "Bank name on all exported statements"],
        ["Compliance badges", "AAOIFI, ECX, NBE",            "Unchanged -- regulatory, cannot be rebranded"],
    ],
    col_widths=[48*mm, 52*mm, CONTENT_W-100*mm]
))
story.append(Spacer(1, 4*mm))
story.append(Paragraph("Integration Models", h2))
for opt, desc in [
    ("Option A -- Managed SaaS",
     "Amber hosts and operates TradEt on behalf of the bank. Bank branding, bank customers, Amber infrastructure. "
     "Fastest time to market. Monthly license or revenue-share model."),
    ("Option B -- On-Premise Deployment",
     "Amber delivers source code and deployment package to the bank's IT team. Bank self-hosts. "
     "One-time license + annual maintenance."),
    ("Option C -- API Integration",
     "Bank integrates TradEt's trading and portfolio APIs into its existing mobile banking app. "
     "Bank builds its own UI on top of TradEt's backend."),
    ("Option D -- Joint Development",
     "Bank contributes market data access (ECX/ESX) and Amber contributes technology. "
     "Equity stake or revenue-sharing structure."),
]:
    story.append(Paragraph(f"<b>{opt}</b> -- {desc}", bullet))
story.append(PageBreak())

# -- 10. ROADMAP --------------------------------------------------------------
story += section_header("10. Roadmap & Future Plans")
story.append(Spacer(1, 2*mm))
story.append(full_table(
    ["Priority", "Feature", "Description", "Target"],
    [
        ["CRITICAL", "ECX live data feed",         "Formal data agreement with ECX for real-time commodity prices",              "Q3 2026"],
        ["CRITICAL", "PostgreSQL migration",        "Replace SQLite -- production-grade replicated database",                    "Q3 2026"],
        ["CRITICAL", "Android & iOS app stores",   "Publish to Google Play and Apple App Store",                                "Q3 2026"],
        ["CRITICAL", "Push notifications",         "FCM/APNs for price alerts and order fill confirmations",                    "Q3 2026"],
        ["HIGH",     "KYC document upload & OCR",  "Integrate Smile ID or equivalent for automated identity verification",      "Q4 2026"],
        ["HIGH",     "NBE exchange rate API",       "Formal NBE data agreement for live FX rates",                              "Q4 2026"],
        ["HIGH",     "Payment gateway",            "CBE Birr / HelloCash / bank transfer for real deposits and withdrawals",    "Q4 2026"],
        ["HIGH",     "CAPTCHA integration",        "Bot protection on login, register, and payment endpoints (reCAPTCHA v3)",   "Q4 2026"],
        ["HIGH",     "Order book / limit matching","Partial-fill support and visible bid/ask depth",                            "Q1 2027"],
        ["HIGH",     "CSMS compliance PDF export", "Auto-generate INSA audit report for regulatory submission",                 "Q4 2026"],
        ["FUTURE",   "Sukuk primary market",       "Allow banks to issue sukuk directly through the platform",                  "Q1 2027"],
        ["FUTURE",   "Multi-bank architecture",    "Single backend, multiple white-label bank instances",                       "Q2 2027"],
        ["FUTURE",   "ESX real-time equity feed",  "Integrate with Ethiopia Securities Exchange data API",                      "Q2 2027"],
        ["FUTURE",   "AI Sharia screener",         "Automated AAOIFI screening using financial statement analysis AI",          "Q3 2027"],
        ["FUTURE",   "Redis + Celery job queue",   "Real-time price updates, alert triggers, order expiry via async workers",   "Q1 2027"],
    ],
    col_widths=[22*mm, 46*mm, 88*mm, 25*mm]
))
story.append(Spacer(1, 4*mm))
story.append(gold_callout(
    "Strategic Note:  The two most critical items -- ECX data feed and payment gateway -- both "
    "require regulatory relationships that an NBE-licensed bank is best positioned to facilitate. "
    "This is the primary reason a bank partnership accelerates time-to-market more than any "
    "purely technical effort."
))
story.append(PageBreak())

# -- 11. ABOUT ----------------------------------------------------------------
story += section_header("11. About Amber Technology")
story.append(Spacer(1, 2*mm))
story.append(Paragraph(
    "Amber Technology is the developer of TradEt -- built from the ground up for the Ethiopian "
    "regulatory environment, with deep focus on AAOIFI compliance, ECX integration, and the "
    "multi-language needs of Ethiopia's diverse investor population.",
    body
))
story.append(Spacer(1, 4*mm))
story.append(kv_table([
    ("Live Demo",        "tradet.amber.et --> click 'Try Demo' (no account required)"),
    ("Platforms",        "Android -- iOS -- Web (responsive)"),
    ("API Health",       "tradet.amber.et/api/health -- returns compliance info + version"),
    ("Contact",          "support@tradet.et"),
    ("Document Date",    today),
    ("Version",          "TradEt v3.1.0 -- Strictly confidential -- for partnership discussion only"),
], col_widths=[40*mm, CONTENT_W-40*mm]))
story.append(Spacer(1, 6*mm))

story.append(Paragraph("Capability Summary", h2))
story.append(full_table(
    ["Capability", "Status", "Notes"],
    [
        ["18 screens, 30+ API endpoints", "Complete",    "All screens functional and localized"],
        ["6 Ethiopian languages",         "Complete",    "Amharic, Tigrinya, Oromoo, Somali, Gurage + English"],
        ["AAOIFI Sharia screening",       "Complete",    "Enforced at API level on every trade"],
        ["ECX session gate",              "Complete",    "Trading hours enforced per commodity"],
        ["INSA CSMS security",            "Complete",    "13 controls -- Technology + Process + People pillars"],
        ["Zakat calculator",              "Complete",    "2.5% rate, dual nisab, per-category breakdown"],
        ["Demo mode",                     "Complete",    "4.98M ETB portfolio, zero network calls"],
        ["White-label config",            "Complete",    "1-hour rebrand turnaround"],
        ["ECX live data feed",            "NOT YET",     "Requires ECX data agreement -- highest priority gap"],
        ["Real payment gateway",          "NOT YET",     "Requires NBE authorization + processor agreement"],
        ["KYC document upload",           "NOT YET",     "Planned Q4 2026 -- Smile ID integration"],
        ["Push notifications",            "NOT YET",     "Planned Q3 2026 -- FCM/APNs"],
        ["Mobile app stores",             "NOT YET",     "Planned Q3 2026 -- builds exist, not submitted"],
        ["Production database",           "NOT YET",     "PostgreSQL migration planned Q3 2026"],
    ],
    col_widths=[62*mm, 28*mm, CONTENT_W-90*mm]
))
story.append(Spacer(1, 6*mm))
story += divider(GOLD, 1.5, 1, 3)
story.append(Paragraph(
    "This document is prepared for partnership discussion. Financial figures shown are from the "
    "demonstration dataset and are illustrative only. Capabilities are as of " + today + ". "
    "Strictly confidential.",
    S("disc", fontSize=8, leading=12, textColor=GREY_MED, fontName="Helvetica-Oblique", alignment=TA_CENTER)
))

# -- Build --------------------------------------------------------------------
doc.build(story, onFirstPage=draw_cover, onLaterPages=on_page)
print("PDF generated: " + OUTPUT)

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
from groq import Groq
import os
from fastapi.responses import FileResponse
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Preformatted
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import inch
import uuid
from fastapi.responses import Response
from pydantic import BaseModel

# =========================
# LOAD ENV VARIABLES
# =========================
load_dotenv()
API_KEY = os.getenv("API_KEY")

if not API_KEY:
    raise ValueError("❌ API_KEY not found in .env file")

# =========================
# INIT CLIENT
# =========================
client = Groq(api_key=API_KEY)

# =========================
# INIT APP
# =========================
app = FastAPI(title="MarketAI Backend 🚀")

# =========================
# ✅ FIXED CORS FOR FLUTTER WEB
# =========================
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],          # allow all during development
    allow_credentials=False,     # MUST be False with "*"
    allow_methods=["*"],
    allow_headers=["*"],
)

# =========================
# COMMON AI FUNCTION
# =========================
async def generate_response(system_prompt: str, user_prompt: str):
    try:
        response = client.chat.completions.create(
            model="llama-3.1-8b-instant",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}
            ]
        )
        return response.choices[0].message.content

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# =========================
# HEALTH CHECK
# =========================
@app.get("/")
async def home():
    return {"message": "MarketAI Backend Running 🚀"}

@app.get("/health")
async def health():
    return {"status": "OK"}

# =========================
# SCENARIO 1: CAMPAIGN
# =========================
# =========================
# SCENARIO 1: ENHANCED CAMPAIGN
# =========================
class CampaignRequest(BaseModel):
    product: str
    audience: str
    platform: str


@app.post("/campaign")
async def generate_campaign(data: CampaignRequest):

    if not data.product or not data.audience or not data.platform:
        raise HTTPException(status_code=400, detail="Missing fields")

    user_prompt = f"""
Create a detailed professional marketing campaign.

Product: {data.product}
Target Audience: {data.audience}
Platform: {data.platform}

Return clearly structured sections:

1. Campaign Objective
2. Detailed Target Audience Analysis
3. Best Marketing Channel & Why
4. Suggested Pricing Strategy
5. Risk Analysis
6. 5 Content Ideas
7. 3 Ad Copies
8. Call To Action
"""

    result = await generate_response(
        system_prompt="You are a senior marketing strategist.",
        user_prompt=user_prompt
    )

    return {"status": "success", "data": result}
# =========================
# DOWNLOAD CAMPAIGN AS PDF
# =========================
# =========================
# DOWNLOAD FULL REPORT AS PDF
# =========================

class CampaignPdfRequest(BaseModel):
    product: str
    audience: str
    platform: str
    demand_data: str | None = None


@app.post("/campaign/pdf")
async def download_campaign_pdf(data: CampaignPdfRequest):

    if not data.product or not data.audience or not data.platform:
        raise HTTPException(status_code=400, detail="Missing fields")

    # -------- CAMPAIGN GENERATION --------
    campaign_prompt = f"""
Create a detailed professional marketing campaign.

Product: {data.product}
Target Audience: {data.audience}
Platform: {data.platform}

Return clearly structured sections:
1. Campaign Objective
2. Detailed Target Audience Analysis
3. Best Marketing Channel & Why
4. Suggested Pricing Strategy
5. Risk Analysis
6. 5 Content Ideas
7. 3 Ad Copies
8. Call To Action
"""

    campaign_result = await generate_response(
        system_prompt="You are a senior marketing strategist.",
        user_prompt=campaign_prompt
    )

    # -------- DEMAND ANALYSIS (OPTIONAL) --------
    demand_result = ""

    if data.demand_data:
        demand_prompt = f"""
Analyze the following business data and predict future demand.

Data: {data.demand_data}

Return:
1. Demand Trend
2. Reason
3. Estimated Growth (%)
4. Recommendation
"""

        demand_result = await generate_response(
            system_prompt="You are a market analyst.",
            user_prompt=demand_prompt
        )

    # -------- PDF CREATION --------
    file_name = f"marketai_report_{uuid.uuid4().hex}.pdf"

    doc = SimpleDocTemplate(file_name, pagesize=A4)
    elements = []

    styles = getSampleStyleSheet()
    normal = styles["Normal"]
    heading = styles["Heading1"]
    subheading = styles["Heading2"]

    # Title
    elements.append(Paragraph("<b>MarketAI Business Report</b>", heading))
    elements.append(Spacer(1, 0.3 * inch))

    # Basic Info
    elements.append(Paragraph(f"<b>Product:</b> {data.product}", normal))
    elements.append(Paragraph(f"<b>Target Audience:</b> {data.audience}", normal))
    elements.append(Paragraph(f"<b>Platform:</b> {data.platform}", normal))
    elements.append(Spacer(1, 0.4 * inch))

    # Campaign Section
    elements.append(Paragraph("<b>Marketing Campaign Strategy</b>", subheading))
    elements.append(Spacer(1, 0.2 * inch))
    elements.append(Preformatted(campaign_result, normal))
    elements.append(Spacer(1, 0.5 * inch))

    # Demand Section (if exists)
    if demand_result:
        elements.append(Paragraph("<b>Demand Analysis & Forecast</b>", subheading))
        elements.append(Spacer(1, 0.2 * inch))
        elements.append(Preformatted(demand_result, normal))
        elements.append(Spacer(1, 0.5 * inch))

    doc.build(elements)

    return FileResponse(
        path=file_name,
        filename="MarketAI_Report.pdf",
        media_type="application/pdf"
    )
# =========================
# SCENARIO 2: SALES PITCH
# =========================
class PitchRequest(BaseModel):
    product: str
    audience: str
    problem: str


@app.post("/pitch")
async def generate_pitch(data: PitchRequest):

    if not data.product or not data.audience or not data.problem:
        raise HTTPException(status_code=400, detail="Missing fields")

    prompt = f"""
Create a compelling investor pitch.

Product: {data.product}
Target Audience: {data.audience}
Problem: {data.problem}

Structure:
1. Hook
2. Problem
3. Solution
4. Market Opportunity
5. Revenue Model
6. Closing
"""

    result = await generate_response(
        system_prompt="You are a startup pitch expert.",
        user_prompt=prompt
    )

    return {"status": "success", "data": result}

# =========================
# SCENARIO 3: LEAD SCORING
# =========================
from pydantic import BaseModel

class CompareRequest(BaseModel):
    clientA_budget: float
    clientA_probability: float
    clientA_urgency: float

    clientB_budget: float
    clientB_probability: float
    clientB_urgency: float


@app.post("/compare-leads")
async def compare_leads(data: CompareRequest):

    expected_a = (
        data.clientA_budget *
        data.clientA_probability *
        data.clientA_urgency
    )

    expected_b = (
        data.clientB_budget *
        data.clientB_probability *
        data.clientB_urgency
    )

    recommendation = (
        "Prioritize Client A"
        if expected_a > expected_b
        else "Prioritize Client B"
    )

    return {
        "clientA": {
            "expected_value": expected_a
        },
        "clientB": {
            "expected_value": expected_b
        },
        "recommendation": recommendation
    }

# =========================
# SCENARIO 4: DEMAND PREDICTION
# =========================
class DemandRequest(BaseModel):
    data: str

@app.post("/predict-demand")
async def predict_demand(req: DemandRequest):

    if not req.data:
        raise HTTPException(status_code=400, detail="Data is required")

    user_prompt = f"""
Analyze the following business data and predict future demand.

Data: {req.data}

Return:
1. Demand Trend (Increase / Decrease / Stable)
2. Reason
3. Estimated Growth (%)
4. Recommendation
"""

    result = await generate_response(
        system_prompt="You are a market analyst.",
        user_prompt=user_prompt
    )

    return {"status": "success", "data": result}

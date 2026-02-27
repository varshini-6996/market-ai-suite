from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import os
from dotenv import load_dotenv
from groq import Groq

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
# CORS (FOR FLUTTER WEB)
# =========================
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # change in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# =========================
# COMMON AI FUNCTION
# =========================
def generate_response(system_prompt: str, user_prompt: str):
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
def home():
    return {"message": "MarketAI Backend Running 🚀"}


@app.get("/health")
def health():
    return {"status": "OK"}


# =========================
# SCENARIO 1: CAMPAIGN
# =========================
class CampaignRequest(BaseModel):
    product: str
    audience: str
    platform: str


@app.post("/campaign")
def generate_campaign(data: CampaignRequest):

    if not data.product or not data.audience or not data.platform:
        raise HTTPException(status_code=400, detail="Missing fields")

    user_prompt = f"""
Create a professional marketing campaign.

Product: {data.product}
Target Audience: {data.audience}
Platform: {data.platform}

Return:

1. Campaign Objective
2. 5 Content Ideas
3. 3 Ad Copies
4. Call to Action
"""

    result = generate_response(
        system_prompt="You are a marketing expert.",
        user_prompt=user_prompt
    )

    return {
        "status": "success",
        "data": result
    }


# =========================
# SCENARIO 2: SALES PITCH
# =========================
class PitchRequest(BaseModel):
    product: str
    target_company: str
    role: str


@app.post("/pitch")
def generate_pitch(data: PitchRequest):

    if not data.product or not data.target_company or not data.role:
        raise HTTPException(status_code=400, detail="Missing fields")

    user_prompt = f"""
Create a personalized B2B sales pitch.

Product: {data.product}
Target Company: {data.target_company}
Person Role: {data.role}

Return:

1. Elevator Pitch (30 sec)
2. Value Proposition
3. Key Differentiators
4. Call to Action
"""

    result = generate_response(
        system_prompt="You are a professional sales expert.",
        user_prompt=user_prompt
    )

    return {
        "status": "success",
        "data": result
    }


# =========================
# SCENARIO 3: LEAD SCORING
# =========================
class LeadRequest(BaseModel):
    budget: int
    urgency: str
    company_size: str
    requirement: str


@app.post("/lead-score")
def score_lead(data: LeadRequest):

    user_prompt = f"""
Analyze this sales lead:

Budget: {data.budget}
Urgency: {data.urgency}
Company Size: {data.company_size}
Requirement: {data.requirement}

Return:

1. Lead Score (0-100)
2. Reasoning
3. Conversion Probability (%)
4. Recommended Action (High / Medium / Low)
"""

    result = generate_response(
        system_prompt="You are a sales analyst.",
        user_prompt=user_prompt
    )

    return {
        "status": "success",
        "data": result
    }


# =========================
# SCENARIO 4: DEMAND PREDICTION 🔥 NEW
# =========================
class DemandRequest(BaseModel):
    data: str


@app.post("/predict-demand")
def predict_demand(req: DemandRequest):

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

    result = generate_response(
        system_prompt="You are a market analyst.",
        user_prompt=user_prompt
    )

    return {
        "status": "success",
        "data": result
    }
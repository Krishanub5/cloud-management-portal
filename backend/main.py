
import logging
import sys
import json

class JsonFormatter(logging.Formatter):
    def format(self, record):
        log_record = {
            "time": self.formatTime(record),
            "level": record.levelname,
            "name": record.name,
            "message": record.getMessage()
        }
        if record.exc_info:
            log_record["exception"] = self.formatException(record.exc_info)
        return json.dumps(log_record)

handler = logging.StreamHandler(sys.stdout)
handler.setFormatter(JsonFormatter())

logging.basicConfig(level=logging.INFO, handlers=[handler])
logger = logging.getLogger("cloud-mgmt-backend")


from ddtrace import patch_all, tracer
patch_all()

import os
tracer.configure(
    hostname=os.getenv("DATADOG_AGENT_HOST", "127.0.0.1"),
    port=8126,
    env=os.getenv("DD_ENV", "dev"),
    service="cloud-mgmt-backend",
)

from ddtrace import tracer
from fastapi import FastAPI, Request, HTTPException
from pydantic import BaseModel
import os
import httpx
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()
requests_db = []

class SubscriptionRequest(BaseModel):
    subscriptionName: str
    businessUnit: str
    environment: str
    managementGroup: str
    costCenter: str
    purpose: str
    requestedBy: str

@app.post("/request-subscription")
async def request_subscription(req: SubscriptionRequest):
    requests_db.append(req.dict())
    logger.info(f"Received request from {req.requestedBy}")
    print(f"Received request from {req.requestedBy}")
    if os.getenv("TRIGGER_PROVISIONING") == "true":
        await trigger_bitbucket_pipeline(req)
    return {"status": "Request received"}

@app.get("/requests")
async def get_all_requests():
    return requests_db

async def trigger_bitbucket_pipeline(req: SubscriptionRequest):
    url = f"https://api.bitbucket.org/2.0/repositories/{os.getenv('BITBUCKET_WORKSPACE')}/{os.getenv('BITBUCKET_REPO')}/pipelines/"
    headers = {
        "Authorization": f"Bearer {os.getenv('BITBUCKET_TOKEN')}",
        "Content-Type": "application/json"
    }
    payload = {
        "target": {
            "ref_type": "branch",
            "type": "pipeline_ref_target",
            "ref_name": "main"
        },
        "variables": [
            {"key": "SUBSCRIPTION_NAME", "value": req.subscriptionName},
            {"key": "MANAGEMENT_GROUP_ID", "value": req.managementGroup},
            {"key": "ENVIRONMENT", "value": req.environment},
            {"key": "COST_CENTER", "value": req.costCenter},
            {"key": "PURPOSE", "value": req.purpose},
            {"key": "REQUESTED_BY", "value": req.requestedBy}
        ]
    }
    async with httpx.AsyncClient() as client:
        response = await client.post(url, headers=headers, json=payload)
    if response.status_code >= 300:
        raise HTTPException(status_code=500, detail="Bitbucket pipeline trigger failed")
# (appended to existing FastAPI main.py, not overwriting entirely)
from fastapi import Body
from ai_utils import call_openai
import csv

@app.post("/generate-tfvars")
async def generate_tfvars(request: dict = Body(...)):
    prompt = f"Generate Terraform .tfvars and reusable CSV based on this JSON: {request}"
    result = call_openai(prompt)
    return {"result": result}

@app.post("/validate-config")
async def validate_config(config: dict = Body(...)):
    prompt = f"Validate the following Terraform configuration for correctness and completeness: {config}"
    result = call_openai(prompt)
    return {"validation": result}

@app.post("/summarize-plan")
async def summarize_plan(plan_text: str = Body(...)):
    prompt = f"Summarize this Terraform plan or drift output:

{plan_text}"
    result = call_openai(prompt)
    return {"summary": result}
# Add to bottom of main.py
from fastapi import UploadFile, File
from form_recognizer import analyze_document

@app.post("/upload-infra-template/")
async def extract_tfvars_from_file(file: UploadFile = File(...)):
    return await analyze_document(file)

@app.post("/generate-readme")
async def generate_readme(data: dict = Body(...)):
    prompt = f"Generate a professional README.md for the following Terraform-based project:

{data}"
    summary = call_openai(prompt)
    return {"readme": summary}

@app.post("/ask-assistant")
async def ask_ai(request: dict = Body(...)):
    q = request.get("question")
    prompt = f"You are an Azure Terraform assistant. Answer this: {q}"
    return {"answer": call_openai(prompt)}

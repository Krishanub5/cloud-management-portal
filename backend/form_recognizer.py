import os
import asyncio
import httpx
from fastapi import UploadFile, File

async def analyze_document(file: UploadFile):
    content = await file.read()
    headers = {
        "Ocp-Apim-Subscription-Key": os.getenv("FORM_RECOGNIZER_KEY"),
        "Content-Type": "application/pdf"
    }
    async with httpx.AsyncClient() as client:
        poll = await client.post(
            os.getenv("FORM_RECOGNIZER_ENDPOINT") + "/formrecognizer/documentModels/prebuilt-layout:analyze?api-version=2023-07-31",
            content=content,
            headers=headers
        )
        result_url = poll.headers["operation-location"]
        await asyncio.sleep(5)
        result = await client.get(result_url, headers={"Ocp-Apim-Subscription-Key": os.getenv("FORM_RECOGNIZER_KEY")})
    return result.json()

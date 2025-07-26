import os
from openai import AzureOpenAI

ai = AzureOpenAI(
    api_key=os.getenv("AZURE_OPENAI_KEY"),
    endpoint=os.getenv("AZURE_OPENAI_ENDPOINT"),
    api_version="2024-03-01-preview"
)

def call_openai(prompt: str, model: str = "gpt-4") -> str:
    response = ai.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        temperature=0.2
    )
    return response.choices[0].message.content

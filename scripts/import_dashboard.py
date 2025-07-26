import requests
import json

api_key = "YOUR_DD_API_KEY"
app_key = "YOUR_DD_APP_KEY"

with open("datadog_cloud_portal_dashboard.json") as f:
    dashboard = json.load(f)

resp = requests.post(
    "https://api.datadoghq.com/api/v1/dashboard",
    headers={
        "DD-API-KEY": api_key,
        "DD-APPLICATION-KEY": app_key,
        "Content-Type": "application/json"
    },
    data=json.dumps(dashboard)
)

print(resp.status_code, resp.json())

import os
from fastapi import FastAPI
import uvicorn

app = FastAPI(title="API Server", description="Python API with data endpoint")

@app.get("/")
def read_root():
    return {"message": "Hello from Python API!"}

@app.post("/data")
def get_data():
    """REST API endpoint that returns sample data"""
    return {
        "data": [
            {"id": 1, "name": "Item 1", "value": "Sample value 1"},
            {"id": 2, "name": "Item 2", "value": "Sample value 2"},
            {"id": 3, "name": "Item 3", "value": "Sample value 3"}
        ],
        "status": "success",
        "count": 3
    }

def main() -> None:
    port = int(os.environ.get("PORT", 4000))
    uvicorn.run(app, host="0.0.0.0", port=port)

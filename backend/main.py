import os
from fastapi import FastAPI, HTTPException
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
import pandas as pd

load_dotenv(os.path.join(os.path.dirname(__file__), '../.windsurf/mcp/.env'))

DB_HOST = os.getenv('DB_HOST')
DB_PORT = os.getenv('DB_PORT')
DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')
DB_NAME = os.getenv('DB_NAME')

DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

from fastapi.middleware.cors import CORSMiddleware

# Friendly mapping for preventative maintenance suggestions
FRIENDLY_PM_SUGGESTIONS = {
    "A/C Not working": "Create a PM plan to service all locations A/C units",
}


app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

from fastapi import Query, Request
from typing import List, Dict

DEBUG_MODE = os.getenv('DEBUG_MODE', 'false').lower() == 'true'

@app.get("/stats/overview")
def overview_stats(request: Request, year: int = Query(2024), month: int = Query(8), debug: bool = Query(False)):
    try:
        with engine.connect() as conn:
            query = "SELECT * FROM summary WHERE created_at LIKE %s"
            date_prefix = f"{year:04d}-{month:02d}-%"
            df = pd.read_sql(query, conn, params=(date_prefix,))
        debug_mode = DEBUG_MODE or debug
        debug_info = {}
        if debug_mode:
            debug_info = {
                "sql_query": query,
                "row_count": len(df),
                "columns": list(df.columns),
            }
            print(f"[DEBUG] SQL: {query}")
            print(f"[DEBUG] Rows: {len(df)}")
            print(f"[DEBUG] Columns: {list(df.columns)}")
        if df.empty or 'addition_request_info' not in df.columns:
            resp = {
                "total_requests": 0,
                "most_common_request": None,
                "most_common_request_count": 0,
            }
            if debug_mode:
                resp['debug'] = debug_info
            return resp
        total_requests = len(df)
        most_common_request = df['addition_request_info'].value_counts().idxmax()
        most_common_request_count = df['addition_request_info'].value_counts().max()
        resp = {
            "total_requests": total_requests,
            "most_common_request": most_common_request,
            "most_common_request_count": int(most_common_request_count),
        }
        if debug_mode:
            resp['debug'] = debug_info
        return resp
    except Exception as e:
        print(f"[ERROR] Exception: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/stats/trends")
def trends(year: int = Query(2024), month: int = Query(8)):
    try:
        with engine.connect() as conn:
            query = "SELECT * FROM summary WHERE created_at LIKE %s"
            date_prefix = f"{year:04d}-{month:02d}-%"
            df = pd.read_sql(query, conn, params=(date_prefix,))
        if df.empty or 'created_at' not in df.columns or 'addition_request_info' not in df.columns:
            return {
                "monthly_request_counts": {},
                "top_growing_requests": {},
            }
        df['created_at'] = pd.to_datetime(df['created_at'])
        monthly = df.groupby(df['created_at'].dt.to_period('M')).size().to_dict()
        growing_requests = df['addition_request_info'].value_counts().head(3).to_dict()
        return {
            "monthly_request_counts": {str(k): int(v) for k, v in monthly.items()},
            "top_growing_requests": growing_requests
        }
    except Exception as e:
        print(f"[ERROR] Exception: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/stats/preventative")
def preventative_maintenance(year: int = Query(2024), month: int = Query(8)):
    try:
        with engine.connect() as conn:
            query = "SELECT * FROM summary WHERE created_at LIKE %s"
            date_prefix = f"{year:04d}-{month:02d}-%"
            df = pd.read_sql(query, conn, params=(date_prefix,))
        if df.empty or 'addition_request_info' not in df.columns:
            return {"preventative_maintenance_candidates": []}
        repeated = df['addition_request_info'].value_counts()
        likely_pm = repeated[repeated > 2].index.tolist()
        # Apply friendly descriptions
        friendly = [FRIENDLY_PM_SUGGESTIONS.get(item, item) for item in likely_pm]
        return {"preventative_maintenance_candidates": friendly}
    except Exception as e:
        print(f"[ERROR] Exception: {e}")
        raise HTTPException(status_code=500, detail=str(e))

# New endpoint to get all (year, month) pairs with data
@app.get("/stats/available_months")
def available_months() -> List[Dict[str, int]]:
    try:
        with engine.connect() as conn:
            query = "SELECT DISTINCT DATE_FORMAT(created_at, '%Y') AS year, DATE_FORMAT(created_at, '%m') AS month FROM summary ORDER BY year DESC, month DESC"
            result = conn.execute(text(query))
            months = [ {"year": int(row[0]), "month": int(row[1])} for row in result ]
        return months
    except Exception as e:
        print(f"[ERROR] Exception: {e}")
        raise HTTPException(status_code=500, detail=str(e))

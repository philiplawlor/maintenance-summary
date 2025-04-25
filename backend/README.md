# Maintenance Summary Backend

This is a FastAPI backend for analyzing facilities management logs from a MariaDB database.

## Setup

1. Install dependencies:
    ```bash
    pip install -r requirements.txt
    ```
2. Ensure the `.env` file is present at `.windsurf/mcp/.env` with the following variables:
    - DB_HOST
    - DB_PORT
    - DB_USER
    - DB_PASSWORD
    - DB_NAME

3. Run the API:
    ```bash
    uvicorn main:app --reload
    ```

## API Endpoints

- `/stats/overview` — High-level statistics
- `/stats/trends` — Trends and growing request types
- `/stats/preventative` — Preventative maintenance suggestions

---

The backend connects to the `summary` table and analyzes user request data for actionable insights.

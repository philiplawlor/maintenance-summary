# Facilities Management Dashboard

This project provides a full-stack Facilities Management Dashboard, designed to analyze and visualize maintenance and service request data from a MariaDB database. It consists of a Python FastAPI backend and a Flutter frontend.

## Features
- **Backend (FastAPI, Python):**
  - Connects to a MariaDB database
  - Provides endpoints for statistics, trends, and preventative maintenance
  - Filters and aggregates data by month and year
  - Robust error handling and debug mode for development
- **Frontend (Flutter):**
  - Displays key statistics and trends in a user-friendly dashboard
  - (Planned) Month/year picker for interactive analysis

## Directory Structure
```
maintenance-summary/
├── backend/            # FastAPI backend
│   ├── main.py         # Main API application
│   ├── requirements.txt
│   └── ...
├── frontend/           # Flutter frontend app
│   └── ...
├── .env                # Environment variables (excluded from git)
├── .gitignore
└── README.md           # Project documentation
```

## Setup
### Backend
1. Create and activate a virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Configure your `.env` file with MariaDB credentials (see `.env.example` if provided).
4. Run the backend:
   ```bash
   uvicorn main:app --reload --port 8000
   ```

### Frontend
1. Install [Flutter](https://flutter.dev/docs/get-started/install) if not already installed.
2. Navigate to the `frontend` directory.
3. Run the app:
   ```bash
   flutter run
   ```

## Git & Security
- `.env` and development artifacts are excluded from git (see `.gitignore`).
- Do **not** commit secrets or credentials.

## Contributing
Pull requests and feature suggestions are welcome!

## License
Specify your license here (MIT, Apache 2.0, etc.)

---

For more details, see the source code in `backend/` and `frontend/`.

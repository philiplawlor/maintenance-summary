# Facilities Management Dashboard

**Version:** 1.0.1 (2025-04-24)

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
├── README.md           # Project documentation
├── CHANGES.md          # Changelog
├── TODO.md             # Project tasks and roadmap
└── .windsurfrules      # IDE and workflow rules
```

## MCP Servers and Tools Used

This project was built using the following MCP (Model Context Protocol) servers and tools:

### MCP Servers
- **filesystem MCP server**: Provides file and directory operations for project automation and IDE features.
- **github MCP server**: Enables GitHub integration for issues, pull requests, and repository management.
- **sequential-thinking MCP server**: Powers advanced reasoning, planning, and multi-step workflow automation.
- **brave-search MCP server**: Adds web and local business search capabilities.

### Tools Provided by MCP Servers
- File management (read, write, move, search, list, etc.)
- GitHub automation (issues, PRs, commits, repo management)
- Sequential thinking and problem-solving chains
- Web and local search
- Codebase and code item search
- Terminal command execution
- Browser preview for local web servers

For more details about MCP servers and their features, visit the [Model Context Protocol website](https://modelcontextprotocol.io/).

## MCP Server Setup

The MCP (Model Context Protocol) server enables advanced IDE, automation, and AI assistant features for this project. To set up and use the MCP server:

1. **Install MCP Server**
   - Visit the [Model Context Protocol website](https://modelcontextprotocol.io/) for installation instructions or use your preferred MCP server distribution.

2. **Start the MCP Server**
   - Run the MCP server in the root directory of your project:
     ```bash
     mcp-server --workspace .
     ```
   - Or, if using Docker:
     ```bash
     docker run -it -v $(pwd):/workspace -p 8080:8080 mcp/server:latest
     ```

3. **Connect your IDE or AI assistant**
   - Use an MCP-compatible client (see the [list of supported clients](https://modelcontextprotocol.io/clients)) to connect to your running server.
   - Typical connection URL: `http://localhost:8080`

4. **Troubleshooting**
   - Ensure you have the necessary ports open.
   - Check logs for errors and consult the [MCP documentation](https://modelcontextprotocol.io/docs) if needed.

---

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

## Project Management
- Track changes with a version number in the README.md file (major.minor.patch format)
- Always update the README.md file with any changes made to the codebase
- Document changes between versions in CHANGES.md
- Add new feature requests/changes to TODO.md
- ~~Strikethrough items from the TODO.md list that are done, include the version number~~

## Contributing
Pull requests and feature suggestions are welcome!

## License
Specify your license here (MIT, Apache 2.0, etc.)

---

For more details, see the source code in `backend/` and `frontend/`.

# FRC QR Scouting App

description: >
  A lightweight, local-first scouting system for FIRST Robotics Competition (FRC).
  Scouts record match data, generate QR codes, and send results to a hub device for aggregation.
  Designed for offline use and later data analysis.

overview:
  - Scouts open the local web page (frontend/scouting_form.html) on a phone or tablet.
  - They record scoring actions using a reef image and simple count fields.
  - The page encodes data into a QR code for scanning.
  - A hub device scans or imports the QR to aggregate match data.
  - Collected data is stored for later analysis or export.

structure:
  frc-qr-scouting-app/
    frontend/
      scouting_form.html   # Main UI for data entry and QR generation
    hub/
      main.py              # Backend for data collection
    certs/                 # HTTPS certificates (generated locally)
      localhost.pem
      localhost-key.pem
    data/                  # Stored scouting data
    setup_certs.py        # Certificate generation script
    requirements.txt
    README.md
    .gitignore

features:
  - Interactive reef image for scoring input by level
  - Barge algae and processor count tracking
  - QR code generation for fast offline data transfer
  - Offline-first design for competition environments
  - Hub for data aggregation and export

setup:
  1. Clone repository:
      git clone https://github.com/cp3277/frc-qr-scouting-app.git
      cd frc-qr-scouting-app

  2. Install mkcert (required for HTTPS/camera access):
     Windows (using Chocolatey):
       choco install mkcert
     
     Windows (manual):
       - Download from https://github.com/FiloSottile/mkcert/releases
       - Add the executable to your PATH

  3. Create and activate virtual environment:
     Windows:
       python -m venv venv
       .\venv\Scripts\Activate.ps1

     macOS/Linux:
       python -m venv venv
       source venv/bin/activate

  4. Install dependencies:
       pip install -r requirements.txt

  5. Setup HTTPS certificates:
       python setup_certs.py
     This will:
     - Install local Certificate Authority
     - Generate certificates in ./certs directory
     - Configure Flask to use the certificates
     - Update .gitignore if needed

  6. Run the application:
     Start the backend hub:
       python hub/main.py
     
     Access the scouting form:
     - On hub device: https://localhost:5000
     - On other devices: https://<hub-ip>:5000
       (Accept the security certificate when prompted)

tech_stack:
  frontend: HTML, CSS, JavaScript
  backend: Python (Flask or FastAPI)
  storage: JSON, CSV, or SQLite
  qr_handling: JavaScript (frontend), Python (backend)
  version_control: Git

security_notes:
  https_certificates:
    - Certificates are required for HTTPS and camera access
    - Generated automatically by setup_certs.py using mkcert
    - Stored in ./certs directory (not tracked by git)
    - Never commit certificate files to the repository
    - Files generated:
        certs/localhost.pem
        certs/localhost-key.pem
    
  first_time_setup:
    - Run setup_certs.py to generate certificates
    - Accept the certificate in your browser
    - For iOS devices, install the root CA:
      Settings -> General -> About -> Certificate Trust Settings

gitignore:
  - venv/
  - __pycache__/
  - data/
  - reef.png
  - reef_base64.txt

development_notes:
  - Primary environment: VS Code on Windows
  - GitHub Copilot assists with:
      - HTML/JS interactivity
      - Flask endpoints for data handling
      - Data formatting and QR parsing logic
  - Focus on maintainability and offline compatibility

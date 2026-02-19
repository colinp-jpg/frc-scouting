#!/usr/bin/env bash
set -euo pipefail

# start.sh - create/activate venv, install requirements, load .env, and run the Flask app
# Note: ngrok is managed by the application (main.py); do NOT start ngrok from this script.
# Usage:
#  bash start.sh            # create venv (if needed), install reqs, load .env, run server
#  VENV_DIR=env bash start.sh   # use a custom venv directory

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🔧 Starting FRC scouting app..."

# find Python
if command -v python3 >/dev/null 2>&1; then
  PYTHON=python3
elif command -v python >/dev/null 2>&1; then
  PYTHON=python
else
  echo "❌ Python not found in PATH. Please install Python 3.8+ and retry." >&2
  exit 1
fi

VENV_DIR="${VENV_DIR:-venv}"

if [ ! -d "$VENV_DIR" ]; then
  echo "🛠 Creating virtual environment in '$VENV_DIR'..."
  $PYTHON -m venv "$VENV_DIR"
fi

# Activate virtualenv (support Unix and Git Bash on Windows)
if [ -f "$VENV_DIR/bin/activate" ]; then
  # POSIX
  # shellcheck disable=SC1090
  source "$VENV_DIR/bin/activate"
elif [ -f "$VENV_DIR/Scripts/activate" ]; then
  # Git Bash on Windows
  # shellcheck disable=SC1091
  source "$VENV_DIR/Scripts/activate"
else
  echo "❌ Could not find the activation script under $VENV_DIR." >&2
  exit 1
fi

echo "📦 Upgrading pip and installing requirements (if present)..."
python -m pip install --upgrade pip
if [ -f "requirements.txt" ]; then
  pip install -r requirements.txt
else
  echo "⚠️  requirements.txt not found — skipping pip install." 
fi

# Load .env if present
if [ -f ".env" ]; then
  echo "🔐 Loading environment variables from .env"
  # Export variables in .env into the environment
  set -o allexport
  # shellcheck disable=SC1091
  source .env
  set +o allexport
fi

# Note: ngrok is started by the Flask application (via main.py's start_ngrok()). Do not start it here.
echo "ℹ️  ngrok will be managed by the application (main.py)."

# Choose server mode: set USE_GUNICORN=1 to use gunicorn, otherwise use Flask dev server
USE_GUNICORN="${USE_GUNICORN:-1}"

if [ "$USE_GUNICORN" = "1" ]; then
  echo "🚀 Launching Flask app with Gunicorn (production mode)"
  exec gunicorn --bind 127.0.0.1:5000 --workers 4 --threads 2 --timeout 120 hub.main:app
else
  echo "🚀 Launching Flask app (development mode)"
  exec python -u -m hub.main
fi

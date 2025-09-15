#!/usr/bin/env python3
"""
Startup script for PawfectCare FastAPI backend.
This script handles environment setup and starts the server.
"""

import os
import sys
import subprocess
from pathlib import Path

def check_python_version():
    """Check if Python version is compatible."""
    if sys.version_info < (3, 8):
        print("Error: Python 3.8 or higher is required")
        sys.exit(1)

def check_dependencies():
    """Check if required dependencies are installed."""
    try:
        import fastapi
        import uvicorn
        import sqlalchemy
        import pydantic
        print("✓ All required dependencies are installed")
    except ImportError as e:
        print(f"Error: Missing dependency - {e}")
        print("Please install dependencies with: pip install -r requirements.txt")
        sys.exit(1)

def setup_environment():
    """Setup environment variables if .env file doesn't exist."""
    env_file = Path(".env")
    if not env_file.exists():
        print("Creating .env file from template...")
        env_example = Path("env.example")
        if env_example.exists():
            with open(env_example, 'r') as f:
                content = f.read()
            with open(env_file, 'w') as f:
                f.write(content)
            print("✓ Created .env file. Please edit it with your configuration.")
        else:
            print("Warning: env.example not found. Creating basic .env file...")
            with open(env_file, 'w') as f:
                f.write("""# Basic configuration
SECRET_KEY=your-secret-key-change-this-in-production
DATABASE_URL=sqlite:///./pawfect_care.db
ALLOWED_ORIGINS=["http://localhost:3000","http://localhost:8080"]
""")
    else:
        print("✓ .env file exists")

def create_upload_directory():
    """Create upload directory if it doesn't exist."""
    upload_dir = Path("uploads")
    upload_dir.mkdir(exist_ok=True)
    print("✓ Upload directory ready")

def start_server():
    """Start the FastAPI server."""
    print("\n" + "="*50)
    print("Starting PawfectCare FastAPI Backend")
    print("="*50)
    print("Server will be available at:")
    print("  - API: http://localhost:8000")
    print("  - Docs: http://localhost:8000/docs")
    print("  - ReDoc: http://localhost:8000/redoc")
    print("\nPress Ctrl+C to stop the server")
    print("="*50)
    
    try:
        subprocess.run([
            sys.executable, "-m", "uvicorn", 
            "app.main:app", 
            "--reload", 
            "--host", "0.0.0.0", 
            "--port", "8000"
        ])
    except KeyboardInterrupt:
        print("\nServer stopped by user")
    except Exception as e:
        print(f"Error starting server: {e}")
        sys.exit(1)

def main():
    """Main function."""
    print("PawfectCare Backend Startup")
    print("-" * 30)
    
    # Check Python version
    check_python_version()
    
    # Check dependencies
    check_dependencies()
    
    # Setup environment
    setup_environment()
    
    # Create upload directory
    create_upload_directory()
    
    # Start server
    start_server()

if __name__ == "__main__":
    main()




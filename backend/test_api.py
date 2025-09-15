#!/usr/bin/env python3
"""
Simple test script to verify the FastAPI backend is working correctly.
Run this after starting the server with: python -m uvicorn app.main:app --reload
"""

import requests
import json

BASE_URL = "http://localhost:8000"

def test_health_check():
    """Test the health check endpoint."""
    print("Testing health check...")
    response = requests.get(f"{BASE_URL}/health")
    print(f"Status: {response.status_code}")
    print(f"Response: {response.json()}")
    print()

def test_root():
    """Test the root endpoint."""
    print("Testing root endpoint...")
    response = requests.get(f"{BASE_URL}/")
    print(f"Status: {response.status_code}")
    print(f"Response: {response.json()}")
    print()

def test_register_user():
    """Test user registration."""
    print("Testing user registration...")
    user_data = {
        "name": "Test User",
        "email": "test@example.com",
        "password": "testpassword123",
        "phone": "+1234567890",
        "role": "pet_owner"
    }
    
    response = requests.post(f"{BASE_URL}/api/v1/auth/register", json=user_data)
    print(f"Status: {response.status_code}")
    if response.status_code == 200:
        print(f"User created: {response.json()}")
    else:
        print(f"Error: {response.json()}")
    print()

def test_login():
    """Test user login."""
    print("Testing user login...")
    login_data = {
        "email": "test@example.com",
        "password": "testpassword123"
    }
    
    response = requests.post(f"{BASE_URL}/api/v1/auth/login", json=login_data)
    print(f"Status: {response.status_code}")
    if response.status_code == 200:
        token_data = response.json()
        print(f"Login successful: {token_data}")
        return token_data["access_token"]
    else:
        print(f"Error: {response.json()}")
        return None

def test_protected_endpoint(token):
    """Test a protected endpoint."""
    if not token:
        print("No token available, skipping protected endpoint test")
        return
    
    print("Testing protected endpoint...")
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(f"{BASE_URL}/api/v1/auth/me", headers=headers)
    print(f"Status: {response.status_code}")
    if response.status_code == 200:
        print(f"User info: {response.json()}")
    else:
        print(f"Error: {response.json()}")
    print()

def test_get_products():
    """Test getting products."""
    print("Testing get products...")
    response = requests.get(f"{BASE_URL}/api/v1/products/")
    print(f"Status: {response.status_code}")
    if response.status_code == 200:
        products = response.json()
        print(f"Found {len(products)} products")
    else:
        print(f"Error: {response.json()}")
    print()

if __name__ == "__main__":
    print("Testing PawfectCare FastAPI Backend")
    print("=" * 40)
    
    try:
        test_health_check()
        test_root()
        test_register_user()
        token = test_login()
        test_protected_endpoint(token)
        test_get_products()
        
        print("All tests completed!")
        
    except requests.exceptions.ConnectionError:
        print("Error: Could not connect to the server.")
        print("Make sure the server is running with: python -m uvicorn app.main:app --reload")
    except Exception as e:
        print(f"Error: {e}")

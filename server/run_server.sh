#!/bin/bash
cd /Users/fadil/repo/capstone/smart-caregiver/server
python3 -m uvicorn src.main:app --host 0.0.0.0 --port 8000

#!/bin/bash
echo "Running smoke tests..."
python3 app.py
if [ $? -eq 0 ]; then
  echo "Smoke test passed"
  exit 0
else
  echo "Smoke test failed"
  exit 1
fi

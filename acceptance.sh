#!/bin/bash
echo "Running acceptance tests..."
if python3 app.py | grep -q "Hello World"; then
  echo "Acceptance test passed"
  exit 0
else
  echo "Acceptance test failed"
  exit 1
fi

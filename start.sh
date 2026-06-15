#!/bin/bash
set -e

echo "🚀 Starting Student Degree Outcome Prediction App..."
exec streamlit run app.py \
  --server.port=8501 \
  --server.address=0.0.0.0 \
  --server.enableCORS=false \
  --server.enableXsrfProtection=true \
  --logger.level=info \
  --client.showErrorDetails=true

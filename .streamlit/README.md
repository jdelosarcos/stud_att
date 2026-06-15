# Deployment Configuration for Streamlit Cloud

## File Purpose
This file contains deployment-specific configuration. For production deployment on Streamlit Cloud,
ensure this directory has the proper configuration files.

## Config files included:
- `config.toml` - Server and client settings optimized for limited resources
- `.gitignore` - To prevent committing secrets

## Environment Variables
Set these in Streamlit Cloud's Secrets management:
- `LIMIT_ML_RESOURCES=true` (auto-detected for Streamlit Cloud deployments)

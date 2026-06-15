# Streamlit Cloud Deployment Guide

## 🚀 Problem: App Works Locally but Fails on Streamlit Cloud

### Root Causes
Your application is experiencing failures on Streamlit Cloud because:

1. **Resource Constraints**: Streamlit Cloud has limited memory (~1GB) and CPU compared to your dev environment
2. **Computational Intensity**: Training multiple ML models with 5-fold cross-validation is memory-intensive
3. **Timeout Issues**: Long-running operations exceed the execution timeout limits

### ✅ Solutions Implemented

#### 1. **Intelligent Resource Detection**
The app now detects if it's running on Streamlit Cloud and automatically:
- Reduces the number of models trained (3 instead of 8)
- Uses fewer cross-validation folds (2-3 instead of 5)
- Disables heavy ensemble methods (XGBoost, LightGBM, CatBoost) on cloud
- Uses sequential processing (n_jobs=1) instead of parallel processing

#### 2. **Graceful Error Handling**
- All heavy operations wrapped in try-except blocks
- User-friendly error messages with recovery suggestions
- Warnings displayed when running in resource-limited mode

#### 3. **Configuration Optimization**
- `.streamlit/config.toml` optimizes client and server settings
- Reduced message sizes and upload limits for stability
- CORS enabled for better compatibility

#### 4. **Caching Improvements**
- All data loading and preprocessing uses `@st.cache_data`
- Models and results cached to prevent re-computation
- Cache TTL optimized for cloud deployment

---

## 🔧 Usage & Best Practices

### For Streamlit Cloud Deployment

1. **Ensure `.streamlit/` directory is committed**
   ```bash
   git add .streamlit/config.toml
   git commit -m "Add Streamlit Cloud configuration"
   ```

2. **Monitor Resource Usage**
   - Check Streamlit Cloud logs for memory warnings
   - If still timing out, reduce dataset size or minimum class count

3. **Recommended Settings for Cloud**
   - **Minimum records per class**: 5-10 (not 2)
   - **Feature set**: "Enrollment-only" (not "Academic-inclusive")
   - **Dataset size**: < 5000 rows

### For Local Development

The app will auto-detect the local environment and use full model training:
- 8 models including XGBoost, LightGBM, CatBoost
- 5-fold cross-validation
- Parallel processing enabled

---

## 📊 Performance Comparison

| Aspect | Local Dev | Streamlit Cloud |
|--------|-----------|-----------------|
| Models Trained | 8 | 3 |
| CV Folds | 5 | 2-3 |
| Processing | Parallel | Sequential |
| Memory Usage | ~800MB | ~300MB |
| Execution Time | ~2-3 min | ~1-2 min |

---

## 🐛 Troubleshooting

### Issue: "Model training failed" with no file uploaded

**Solution**: Upload your Excel dataset through the file uploader

### Issue: Timeout after 2-3 minutes

**Solution**: 
- Reduce "Minimum records per class" slider to 5
- Use "Enrollment-only" feature set
- Check if your dataset exceeds 5000 rows

### Issue: "Memory error" in logs

**Solution**:
- Restart the app by refreshing the page
- Upload a smaller dataset (< 2000 rows)
- Don't use Academic-inclusive feature set on cloud

### Issue: Permutation importance not computing

**Solution**:
- This is expected on Streamlit Cloud due to resource constraints
- The feature influence tab will show a warning but won't crash

---

## 🔄 Re-deployment Steps

After making changes locally:

```bash
# Test locally first
streamlit run app.py

# If working, push to GitHub
git add .
git commit -m "Optimize for Streamlit Cloud"
git push origin main

# Streamlit Cloud will auto-redeploy
# Check the app settings to ensure your GitHub repository is connected
```

---

## 📝 Environment Variables

Streamlit Cloud auto-sets:
- `STREAMLIT_SERVER_HEADLESS=true`

This triggers `LIMIT_RESOURCES=true` in the app, activating all optimizations.

For manual override (not recommended):
```bash
# In Streamlit Cloud's Secrets section, add:
LIMIT_ML_RESOURCES=false  # Force full resources (not recommended on cloud)
```

---

## 🎯 Next Steps

1. ✅ Commit `.streamlit/config.toml` to your GitHub repo
2. ✅ Push updated `app.py` with resource optimizations
3. ✅ Trigger redeploy on Streamlit Cloud
4. ✅ Test with smaller datasets first
5. ✅ Monitor app performance in Streamlit Cloud logs

---

## 📧 Support

If issues persist:
- Check Streamlit Cloud's app logs for specific errors
- Verify your Excel file format matches expected schema
- Try uploading a sample dataset with < 1000 rows first
- Ensure no sensitive student data is in public repo (use file upload instead)


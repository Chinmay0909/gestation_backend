# Gestational Diabetes ML API - Render Deployment Guide

## Manual Upload Method (No Git Required)

Follow these steps to deploy your Python ML backend on Render.

---

## Step 1: Prepare Your Files

Make sure your `gestation_backend` folder contains:
- ✅ `fastapi_backend_modified.py` (main application)
- ✅ `requirements.txt` (dependencies)
- ✅ `render.yaml` (Render configuration)
- ✅ `start.sh` (start script)
- ✅ `latest/` folder with all model files:
  - `ensemble_model.pkl`
  - `knn_model.pkl`
  - `logisticregression_model.pkl`
  - `model_metadata.json`
  - `preprocessing.pkl`
  - `randomforest_model.pkl`
  - `xgboost_model.pkl`

---

## Step 2: Create a Render Account

1. Go to https://render.com
2. Click "Get Started" or "Sign Up"
3. Sign up using:
   - GitHub (recommended)
   - GitLab
   - Google
   - Email

---

## Step 3: Create a New Web Service

### Option A: Using GitHub (Recommended)

1. **Push your code to GitHub first:**
   - Go to https://github.com/new
   - Create a new repository (e.g., "gestational-ml-backend")
   - Follow GitHub's instructions to push your `gestation_backend` folder

2. **In Render Dashboard:**
   - Click "New +" button
   - Select "Web Service"
   - Click "Connect to GitHub"
   - Authorize Render to access your repositories
   - Select your repository
   - Click "Connect"

### Option B: Manual Upload (Alternative)

1. **Create a Git repository locally:**
   ```bash
   cd /Users/altamsh04/Desktop/gestational/gestation_backend
   git init
   git add .
   git commit -m "Initial commit"
   ```

2. **Push to a Git hosting service** (GitHub, GitLab, or Bitbucket)

**Note:** Render requires a Git repository. Manual file upload is not supported. You must use Git.

---

## Step 4: Configure Your Web Service

Once connected, configure the following settings:

### Basic Settings:
- **Name:** `gestational-ml-api` (or your preferred name)
- **Region:** Choose closest to your users (e.g., Oregon, Frankfurt, Singapore)
- **Branch:** `main` or `master`
- **Root Directory:** Leave empty (or set to `gestation_backend` if you pushed entire project)
- **Runtime:** `Python 3`

### Build & Deploy Settings:
- **Build Command:**
  ```
  pip install -r requirements.txt
  ```

- **Start Command:**
  ```
  uvicorn fastapi_backend_modified:app --host 0.0.0.0 --port $PORT
  ```

### Instance Type:
- **Free Tier:** Select "Free" (limited resources, spins down after inactivity)
- **Starter:** $7/month (better for production)

### Environment Variables:
- **PYTHON_VERSION:** `3.11.0`

---

## Step 5: Deploy

1. Click "Create Web Service"
2. Render will:
   - Clone your repository
   - Install dependencies from `requirements.txt`
   - Start your FastAPI application
   - This takes 5-10 minutes

3. Monitor the deployment logs in real-time

---

## Step 6: Verify Deployment

Once deployed, you'll get a URL like: `https://gestational-ml-api.onrender.com`

Test your endpoints:

### Health Check:
```bash
curl https://your-app-name.onrender.com/health
```

### API Documentation:
Visit: `https://your-app-name.onrender.com/docs`

### Test Prediction:
```bash
curl -X POST "https://your-app-name.onrender.com/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "Age": 28,
    "No of Pregnancy": 2,
    "Gestation in previous Pregnancy": 38,
    "HDL": 45,
    "Family History": 1,
    "unexplained prenetal loss": 0,
    "Large Child or Birth Default": 0,
    "PCOS": 0,
    "Sys BP": 120,
    "Dia BP": 80,
    "Hemoglobin": 12.5,
    "Sedentary Lifestyle": 0,
    "Prediabetes": 0
  }'
```

---

## Step 7: Update Your Frontend/Node.js Backend

Update the ML API URL in your Node.js backend ([server.js:33](server.js:33)):

```javascript
// Before
const ML_API_URL = 'http://localhost:8000';

// After
const ML_API_URL = 'https://your-app-name.onrender.com';
```

Or use environment variable:
```javascript
const ML_API_URL = process.env.ML_API_URL || 'http://localhost:8000';
```

---

## Important Notes

### Free Tier Limitations:
- ⚠️ **Spins down after 15 minutes of inactivity**
- ⚠️ **First request after spin-down takes ~30 seconds**
- ⚠️ **750 hours/month free** (enough for one service)
- ✅ **Good for testing and development**

### Production Recommendations:
- Use **Starter plan** ($7/month) for always-on service
- Add **custom domain** for professional URLs
- Enable **auto-deploy** for CI/CD
- Monitor **logs and metrics** in Render dashboard

### Model Files Warning:
- Model files (~2MB total) are included in deployment
- If you get size errors, consider using cloud storage (AWS S3, Google Cloud Storage)

---

## Troubleshooting

### Deployment Fails:
1. Check build logs in Render dashboard
2. Verify `requirements.txt` is correct
3. Ensure `latest/` folder has all model files

### Model Not Loading:
1. Check if `latest/model_metadata.json` exists
2. Verify file paths in `fastapi_backend_modified.py`
3. Check logs for model loading errors

### 502 Bad Gateway:
1. Service is still starting (wait 1-2 minutes)
2. Check if app is listening on `0.0.0.0:$PORT`
3. Verify start command is correct

### Slow First Request:
- Normal for free tier (cold start)
- Upgrade to paid plan for always-on service

---

## Quick Reference

### Your Deployed Endpoints:
- **Root:** `https://your-app-name.onrender.com/`
- **Health:** `https://your-app-name.onrender.com/health`
- **Docs:** `https://your-app-name.onrender.com/docs`
- **Predict:** `https://your-app-name.onrender.com/predict`
- **Model Info:** `https://your-app-name.onrender.com/model-info`

### Useful Commands:
```bash
# Check service status
curl https://your-app-name.onrender.com/health

# View API documentation
open https://your-app-name.onrender.com/docs

# Test prediction
curl -X POST "https://your-app-name.onrender.com/predict" \
  -H "Content-Type: application/json" \
  -d @test_patient.json
```

---

## Need Help?

- Render Docs: https://render.com/docs
- Render Community: https://community.render.com
- FastAPI Docs: https://fastapi.tiangolo.com

---

**Deployment Date:** December 11, 2025
**Python Version:** 3.11.0
**FastAPI Version:** 0.109.0

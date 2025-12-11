# Gestational Diabetes Prediction API

A FastAPI-based backend service for predicting gestational diabetes risk using machine learning.

## Model Information

- **Model Type**: Gradient Boosting Classifier
- **Accuracy**: 62.50%
- **ROC AUC**: 0.6306
- **Features**: 18 clinical and demographic features
- **Training Date**: December 9, 2025

## Features

- ✅ Real-time prediction API
- ✅ Batch prediction support
- ✅ Input validation with Pydantic
- ✅ Risk factor analysis
- ✅ CORS enabled for frontend integration
- ✅ Comprehensive error handling
- ✅ API documentation (Swagger/ReDoc)
- ✅ Health check endpoints

## Installation

### Prerequisites

- Python 3.8 or higher
- pip package manager

### Setup

1. **Navigate to the backend directory**:
```bash
cd gestation_backend
```

2. **Create a virtual environment** (recommended):
```bash
python -m venv venv

# On Windows
venv\Scripts\activate

# On macOS/Linux
source venv/bin/activate
```

3. **Install dependencies**:
```bash
pip install -r requirements.txt
```

## Running the Server

### Development Mode

```bash
python main.py
```

Or using uvicorn directly:

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Production Mode

```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4
```

The API will be available at: `http://localhost:8000`

## API Documentation

Once the server is running, access the interactive documentation:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## API Endpoints

### 1. Health Check

**GET** `/` or `/health`

Check if the API and model are loaded successfully.

**Response**:
```json
{
  "status": "healthy",
  "model_loaded": true,
  "timestamp": "2025-12-10T12:00:00",
  "version": "1.0.0"
}
```

### 2. Single Prediction

**POST** `/predict`

Predict gestational diabetes risk for a single patient.

**Request Body**:
```json
{
  "Age": 28,
  "No of Pregnancy": 2,
  "Gestation in previous Pregnancy": 38,
  "BMI": 26.5,
  "HDL": 45,
  "Family History": 1,
  "unexplained prenetal loss": 0,
  "Large Child or Birth Default": 0,
  "PCOS": 0,
  "Sys BP": 125,
  "Dia BP": 82,
  "OGTT": 145,
  "Hemoglobin": 11.5,
  "Sedentary Lifestyle": 1,
  "Prediabetes": 0
}
```

**Response**:
```json
{
  "success": true,
  "prediction": "GDM",
  "gdm_probability": 0.72,
  "non_gdm_probability": 0.28,
  "risk_category": "High Risk",
  "confidence": 0.72,
  "risk_factors": {
    "high_bmi": false,
    "family_history": true,
    "pcos": false,
    "prediabetes": false,
    "advanced_age": false,
    "high_bp": false,
    "previous_complications": false,
    "sedentary_lifestyle": true,
    "high_ogtt": true,
    "low_hdl": true
  },
  "timestamp": "2025-12-10T12:00:00",
  "message": "Prediction completed successfully"
}
```

### 3. Batch Prediction

**POST** `/batch-predict`

Predict for multiple patients at once.

**Request Body**:
```json
[
  {
    "Age": 28,
    "No of Pregnancy": 2,
    ...
  },
  {
    "Age": 32,
    "No of Pregnancy": 1,
    ...
  }
]
```

**Response**:
```json
{
  "total_patients": 2,
  "successful_predictions": 2,
  "results": [
    {
      "patient_index": 0,
      "success": true,
      "prediction": "GDM",
      "gdm_probability": 0.72,
      "risk_category": "High Risk",
      "confidence": 0.72
    },
    ...
  ],
  "timestamp": "2025-12-10T12:00:00"
}
```

### 4. Model Information

**GET** `/model-info`

Get details about the loaded model.

**Response**:
```json
{
  "model_type": "Gradient Boosting",
  "accuracy": 0.6250,
  "roc_auc": 0.6306,
  "num_features": 18,
  "feature_names": ["Age", "No of Pregnancy", ...],
  "classes": ["Non GDM", "GDM"],
  "training_date": "2025-12-09",
  "version": "1.0.0"
}
```

## Input Features

All 15 required input features with their valid ranges:

| Feature | Type | Range | Description |
|---------|------|-------|-------------|
| Age | float | 15-60 | Patient age in years |
| No of Pregnancy | int | 0-20 | Number of pregnancies |
| Gestation in previous Pregnancy | float | 0-45 | Weeks of gestation (0 if none) |
| BMI | float | 10-60 | Body Mass Index |
| HDL | float | 10-150 | HDL cholesterol level |
| Family History | int | 0-1 | Family history of diabetes |
| unexplained prenetal loss | int | 0-1 | History of unexplained prenatal loss |
| Large Child or Birth Default | int | 0-1 | History of large child or birth defects |
| PCOS | int | 0-1 | PCOS diagnosis |
| Sys BP | float | 70-200 | Systolic Blood Pressure |
| Dia BP | float | 40-130 | Diastolic Blood Pressure |
| OGTT | float | 50-300 | Oral Glucose Tolerance Test result |
| Hemoglobin | float | 5-20 | Hemoglobin level (g/dL) |
| Sedentary Lifestyle | int | 0-1 | Sedentary lifestyle indicator |
| Prediabetes | int | 0-1 | Prediabetes diagnosis |

**Note**: The model automatically engineers 3 additional features:
- BP_Ratio (Sys BP / Dia BP)
- Age_BMI_Interaction (Age × BMI)
- Risk_Score (composite risk score)

## Risk Categories

- **Low Risk**: GDM probability < 30%
- **Moderate Risk**: GDM probability 30-60%
- **High Risk**: GDM probability > 60%

## Risk Factors Analyzed

The API analyzes 10 key risk factors:

1. High BMI (> 30)
2. Family history of diabetes
3. PCOS diagnosis
4. Prediabetes
5. Advanced maternal age (> 35)
6. High blood pressure
7. Previous pregnancy complications
8. Sedentary lifestyle
9. High OGTT result (> 140)
10. Low HDL cholesterol (< 40)

## Example Usage

### Using cURL

```bash
curl -X POST "http://localhost:8000/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "Age": 28,
    "No of Pregnancy": 2,
    "Gestation in previous Pregnancy": 38,
    "BMI": 26.5,
    "HDL": 45,
    "Family History": 1,
    "unexplained prenetal loss": 0,
    "Large Child or Birth Default": 0,
    "PCOS": 0,
    "Sys BP": 125,
    "Dia BP": 82,
    "OGTT": 145,
    "Hemoglobin": 11.5,
    "Sedentary Lifestyle": 1,
    "Prediabetes": 0
  }'
```

### Using Python

```python
import requests

url = "http://localhost:8000/predict"

patient_data = {
    "Age": 28,
    "No of Pregnancy": 2,
    "Gestation in previous Pregnancy": 38,
    "BMI": 26.5,
    "HDL": 45,
    "Family History": 1,
    "unexplained prenetal loss": 0,
    "Large Child or Birth Default": 0,
    "PCOS": 0,
    "Sys BP": 125,
    "Dia BP": 82,
    "OGTT": 145,
    "Hemoglobin": 11.5,
    "Sedentary Lifestyle": 1,
    "Prediabetes": 0
}

response = requests.post(url, json=patient_data)
result = response.json()

print(f"Prediction: {result['prediction']}")
print(f"Risk Category: {result['risk_category']}")
print(f"Probability: {result['gdm_probability']:.2%}")
```

### Using JavaScript (Fetch API)

```javascript
const url = "http://localhost:8000/predict";

const patientData = {
  "Age": 28,
  "No of Pregnancy": 2,
  "Gestation in previous Pregnancy": 38,
  "BMI": 26.5,
  "HDL": 45,
  "Family History": 1,
  "unexplained prenetal loss": 0,
  "Large Child or Birth Default": 0,
  "PCOS": 0,
  "Sys BP": 125,
  "Dia BP": 82,
  "OGTT": 145,
  "Hemoglobin": 11.5,
  "Sedentary Lifestyle": 1,
  "Prediabetes": 0
};

fetch(url, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify(patientData),
})
  .then(response => response.json())
  .then(data => {
    console.log('Prediction:', data.prediction);
    console.log('Risk Category:', data.risk_category);
    console.log('Probability:', data.gdm_probability);
  })
  .catch(error => console.error('Error:', error));
```

## Error Handling

The API provides detailed error messages:

- **422 Unprocessable Entity**: Invalid input data
- **503 Service Unavailable**: Model not loaded
- **500 Internal Server Error**: Server-side error

Example error response:
```json
{
  "detail": "Diastolic BP must be less than Systolic BP"
}
```

## Frontend Integration

To integrate with your React frontend:

1. Update the CORS origins in `main.py` if needed
2. Use the API base URL: `http://localhost:8000`
3. Handle the response structure in your frontend components

Example React integration:

```javascript
const predictGDM = async (patientData) => {
  try {
    const response = await fetch('http://localhost:8000/predict', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(patientData),
    });

    if (!response.ok) {
      throw new Error('Prediction failed');
    }

    const result = await response.json();
    return result;
  } catch (error) {
    console.error('Error:', error);
    throw error;
  }
};
```

## Dataset Information

The model was trained on the **Gestational Diabetic Data Set** which includes:

- **Total Samples**: 1000
- **Training Samples**: 800
- **Test Samples**: 200
- **Features**: 15 clinical + 3 engineered
- **Classes**: GDM / Non GDM (balanced)

Dataset file: `Gestational Diabetic Dat Set.xlsx`

## Model Files

- `gdm_prediction_model.pkl`: Main trained model
- `gdm_prediction_model_backup.pkl`: Backup model file
- `model_summary.txt`: Performance metrics
- `model_usage_instructions.txt`: Detailed usage guide

## Logging

The API logs all requests and predictions for monitoring:

- Request timestamp
- Patient age (for privacy-safe logging)
- Prediction results
- Errors and exceptions

## Important Disclaimers

⚠️ **Medical Disclaimer**: This model is for research and educational purposes only. Always consult healthcare professionals for medical decisions.

⚠️ **Data Privacy**: Ensure compliance with HIPAA, GDPR, or other relevant healthcare data regulations when deploying in production.

⚠️ **Model Limitations**: The model was trained on specific data and may not generalize to all populations.

## Troubleshooting

### Model Not Loading

If you see "Model not loaded" error:

1. Ensure `gdm_prediction_model.pkl` is in the `gestation_backend` directory
2. Check file permissions
3. Verify scikit-learn version compatibility

### Import Errors

If you encounter import errors:

```bash
pip install --upgrade -r requirements.txt
```

### Port Already in Use

If port 8000 is in use:

```bash
uvicorn main:app --port 8001
```

## Development

### Project Structure

```
gestation_backend/
├── main.py                                 # FastAPI application
├── requirements.txt                        # Python dependencies
├── README.md                              # This file
├── gdm_prediction_model.pkl               # Trained model
├── gdm_prediction_model_backup.pkl        # Backup model
├── model_summary.txt                      # Model metrics
├── model_usage_instructions.txt           # Usage guide
└── Gestational Diabetic Dat Set.xlsx      # Training dataset
```

### Running Tests

You can test the API using the built-in Swagger UI at `/docs` or create test scripts.

### Contributing

1. Follow PEP 8 style guidelines
2. Add type hints to functions
3. Update documentation for new features
4. Test thoroughly before committing

## License

This project is for educational and research purposes.

## Contact

For issues or questions, please contact the development team.

---

**Version**: 1.0.0
**Last Updated**: December 10, 2025

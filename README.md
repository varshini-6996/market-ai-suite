MarketAI Suite

An AI-powered platform designed to generate **marketing campaigns, sales pitches, and lead analysis** using advanced LLMs.

This repository contains **two different implementations** of the same idea:

1. **Full-Stack App (Flutter + FastAPI)**
2. **Web App (HTML + Gemini Canvas + Groq API)**

---

#  Project Overview

MarketAI Suite helps users:

* Generate marketing campaigns
* Create sales pitches
* Analyze potential leads

The system leverages **LLM APIs (Groq / Gemini)** to produce high-quality outputs instantly.

---

# Project Structure

```
market-ai-suite/
│
├── flutter_fastapi_app/     # Full-stack mobile/web app
│   ├── frontend (Flutter)
│   ├── backend (FastAPI)
│
├── web_canvas_app/          # HTML + JS web app
│   ├── index.html
│   ├── scripts
│
└── README.md
```

---

# 1. Full Stack App (Flutter + FastAPI)

##  Frontend: Flutter

A cross-platform UI built using Flutter.

### Features:

* Responsive UI
* User input forms
* API integration with backend
* Real-time AI-generated results

---

##  Backend: FastAPI

Handles:

* API requests
* Prompt processing
* Communication with AI models

### Key Technologies:

* FastAPI
* Python
* REST APIs

---

## Running the Backend

```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
```

Server will run at:

```
http://127.0.0.1:8000
```

---

##  Running the Flutter App

```bash
cd frontend
flutter pub get
flutter run
```

---

# 2. Web App (HTML + Gemini Canvas + Groq API)

A lightweight web-based interface for AI content generation.

---

##  Features

* Marketing Campaign Generator
* Sales Pitch Generator
* Lead Scoring Tool
* Clean UI using Tailwind CSS
* Markdown rendering of AI responses
* API integration with Groq

---

## Running the Web App

### Option 1: Open directly

```
Open index.html in browser
```

### Option 2 (Recommended): Live Server

* Open project in VS Code
* Right click `index.html`
* Click **Open with Live Server**

---

## API Configuration

The app uses Groq API.

Example:

```js
const GROQ_API_KEY = "your_api_key_here";
```

 Note:

* API key is exposed in frontend
* Not secure for production use

---

#  AI Models Used

* Groq LLM API
* Gemini API (Canvas-based workflow)

Used for:

* Text generation
* Prompt completion
* Business insights

---

# Functional Modules

## 1. Marketing Campaign

Generates platform-specific marketing campaigns based on:

* Product
* Audience
* Platform

---

## 2. Sales Pitch

Creates persuasive sales pitches based on:

* Product/Solution
* Target Role

---

## 3. Lead Scoring

Analyzes lead quality using:

* Budget
* Timeline

---

#  Limitations

* API key stored in frontend (not secure)
* No authentication system
* Limited error handling
* No database integration

---

#  Future Improvements

* Secure backend API integration
* User authentication
* Data storage (Firebase / DB)
* Chat history
* Deployment automation
* Better UI/UX

---

# How This Repo is Used

This repository demonstrates:

* Multi-architecture implementation
* AI integration in real-world applications
* Full-stack and frontend-only approaches

---

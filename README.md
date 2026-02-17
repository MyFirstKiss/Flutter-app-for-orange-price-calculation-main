# 🍊 Orange Calculator Application

**Flutter + FastAPI + Firebase** | Android & iOS

A mobile application for orange price calculation, real-time market data tracking, and cloud-synced calculation history.

## 📚 Additional Documentation
- 📘 [Installation Guide](INSTALLATION.md)
- ⚙️ [Backend Documentation](backend/README.md)
- 📝 [Changelog](CHANGELOG.md)

---

## 📋 Summary

This project is a **cross-platform mobile application** combining a Flutter frontend with a FastAPI backend and Firebase Cloud Firestore for seamless cloud data sync. The system scrapes real-time market data from Talaadthai.com, persists calculation history to Firestore, and presents everything through a modern gradient-based UI.

**Key Highlights:**
- 🍊 3 orange types supported (Tangerine, Green Sweet Orange, Mandarin Orange)
- 💰 Real-time price scraping from Talaadthai.com
- 🧮 Weight-based price calculator with Firestore save
- 📜 Cloud-synced calculation history (Firebase Cloud Firestore)
- 📱 Native Android & iOS apps
- 🔄 1-hour data caching with fallback mechanism
- 🎨 Unified gradient UI across all screens (Material Design 3)

**Technologies:** Flutter (Dart), FastAPI (Python), Firebase Cloud Firestore, BeautifulSoup4, SQLite, Material Design 3

---

## 📄 Table of Contents
- [Project Overview](#-project-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [System Architecture](#-system-architecture)
- [Project Structure](#-project-structure)
- [Installation & Setup](#-installation--setup)
- [Database Design](#-database-design)
- [Application Workflow](#-application-workflow)
- [Data Source & Caching](#-data-source--caching)
- [API Endpoints](#-api-endpoints)
- [Future Improvements](#-future-improvements)
- [Version](#-version)

---

## 📌 Project Overview

The Orange Calculator Application helps users browse orange information, calculate prices by weight, and check the latest market prices. Calculation history is saved to Firebase Cloud Firestore and streamed in real-time to the History screen.

### Main Objectives
- Present orange data (dimensions, sizes, prices) in a clear, organized way
- Provide quick price calculation based on weight (kilograms)
- Save every calculation to Firebase Cloud Firestore automatically
- Show real-time market prices from Talaadthai.com
- Support mobile platforms (Android & iOS)

### Supported Orange Types
1. **Tangerine** — Sweet and juicy, soft texture, high water content
2. **Green Sweet Orange** — Sweet and crispy, refreshing, not sour
3. **Mandarin Orange** — Sweet aroma, easy to peel, fine texture

---

## 🚀 Features

- 📊 **Orange Data** — View dimensions and sizes of 3 orange types
- 🧮 **Price Calculator** — Calculate price based on weight (kg); results saved to Firestore
- 📜 **History** — Real-time stream of past calculations from Cloud Firestore (swipe to delete)
- 💰 **Live Prices** — Real-time price updates from Talaadthai.com via FastAPI
- 🌐 **Web Scraping** — Automated data fetching with 1-hour cache and fallback
- 📱 **Mobile-First** — Android and iOS support
- 🎨 **Gradient UI** — Each screen has a matching gradient hero (orange/green/blue/purple)

---

## 🛠 Tech Stack

**Frontend (Flutter)**
- Flutter 3.0+ (Dart)
- Material Design 3
- \http: ^1.2.2- \intl: ^0.19.0- \irebase_core: ^4.4.0- \cloud_firestore: ^6.1.2
**Backend (Python)**
- FastAPI 0.115.0
- BeautifulSoup4 4.12.3 (Web Scraping)
- SQLAlchemy 2.0.25
- Uvicorn 0.32.0 (ASGI Server)
- Requests 2.32.3
- Pydantic 2.9.2

**Cloud / Database**
- Firebase Cloud Firestore (calculation history)
- SQLite (backend orange data)

---

## 🏗 System Architecture

**Layered Architecture:**

1. **UI Layer** — Flutter Screens (Home, Data, Calculator, Live Prices, History)
2. **Service Layer** — \ApiService\ (HTTP to FastAPI) + \FirebaseService\ (Firestore CRUD)
3. **Backend Layer** — FastAPI (REST API + Web Scraping)
4. **Data Layer** — Cloud Firestore + SQLite

**Data Flow:**
\User → Flutter UI
  ├─► ApiService      → FastAPI → Talaadthai.com / SQLite
  └─► FirebaseService → Cloud Firestore
\
---

## 📂 Project Structure

\lib/
├── firebase_options.dart
├── main.dart
├── models/
│   ├── orange_type.dart
│   └── price_calculation.dart
├── screens/
│   ├── home_screen.dart
│   ├── data_screen.dart
│   ├── calculator_screen.dart
│   ├── history_screen.dart
│   ├── live_prices_screen.dart
│   └── firebase_service.dart
├── services/
│   └── api_service.dart
├── utils/
│   └── app_theme.dart
└── widgets/
    └── common_widgets.dart

backend/
├── main.py
├── database.py
├── seed_db.py
└── requirements.txt
\
---

## ⚙️ Installation & Setup

\\ash
git clone https://github.com/MyFirstKiss/Flutter-app-for-orange-price-calculation-main.git
cd Flutter-app-for-orange-price-calculation-main
flutter pub get
flutter run
\
**Backend:**
\\ash
cd backend
pip install -r requirements.txt
python seed_db.py    # Seed initial orange data
python main.py       # Start FastAPI server on port 8001
\
> **Note:** For Android emulator, the app connects to the backend at .0.2.2:8001
**Firebase:**
- Firebase project must be configured with \google-services.json\ (Android) and \GoogleService-Info.plist\ (iOS)
- Firestore collection used: \calculations
---

## 📊 Database Design

**Cloud Firestore — \calculations\ collection:**

| Field | Type | Description |
|-------|------|-------------|
| \orangeType\ | String | Orange type ID (e.g. \	angerine\) |
| \orangeName\ | String | Display name |
| \weightKg\ | Number | Weight in kg |
| \pricePerKg\ | Number | Price per kg |
| \	otalPrice\ | Number | Calculated total |
| \	imestamp\ | Timestamp | Server timestamp |

**SQLite — Backend:**
- \orange_types\ — id, name, price_per_kg, color, grade
- \orange_measurements\ — orange_id, height_cm, radius_cm, diameter_cm, weight_avg_g

---

## 🔄 Application Workflow

1. Launch App → Home screen with stats and 2×2 grid menu
2. **Orange Data** → Browse size/dimension info of each orange type
3. **Calculate Price** → Enter weight → result calculated and saved to Firestore
4. **Live Prices** → Fetch real-time prices from Talaadthai.com via FastAPI
5. **History** → View all past calculations streamed live from Firestore; swipe to delete

---

## 🧾 Data Source & Caching

- Price data fetched from Talaadthai.com via BeautifulSoup4
- Prices cached for 1 hour to reduce scraping load
- Fallback static data used if website is unavailable

---

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | \/\ | Health check |
| GET | \/oranges\ | Filtered prices from Talaadthai |
| GET | \/api/oranges\ | Orange data for the app |
| GET | \/api/oranges/{id}\ | Single orange data |
| POST | \/api/calculate\ | Price calculation |
| GET | \/api/prices\ | Real-time prices |

---

## 🚀 Deployment Diagram

\[ Android / iOS Device ]
         |
         ▼
[ Flutter Application ]
    |            |
    ▼            ▼
[ FastAPI ]   [ Firebase Cloud Firestore ]
   |    |
   ▼    ▼
[SQLite] [Talaadthai.com]
          (Web Scraping)
\
---

## 📈 Future Improvements

- Price trend charts
- Push notifications for price alerts
- User authentication
- Offline mode with local cache
- Export history to CSV

---

## 🏷 Version

**1.0.0** (2026)

---

## 👨‍💻 Developer

Student Project — Information Technology

---

## 📄 License

MIT License — Educational use only

---

Made with ❤️ and 🍊

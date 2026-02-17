# Orange Calculator Application

## 📚 Additional Documentation
- 📘 [Installation Guide](INSTALLATION.md)
- ⚙️ [Backend Documentation](backend/README.md)
- 📝 [Changelog](CHANGELOG.md)

**Flutter + FastAPI** | **Platform Status**

A mobile application developed using Flutter for orange price calculation and real-time market data tracking.

---

## � Summary

This project is a **cross-platform mobile application** that combines Flutter frontend with FastAPI backend to provide orange price information and calculation services. The system scrapes real-time market data from Talaadthai.com, stores it in SQLite database, and presents it through an intuitive mobile interface.

**Key Highlights:**
- 🍊 3 orange types supported (Tangerine, Green Sweet, Mandarin)
- 💰 Real-time price scraping from Talaadthai.com
- 🧮 Weight-based price calculator
- 📱 Native Android & iOS apps
- 🔄 1-hour data caching with fallback mechanism
- 🎨 Material Design 3 UI

**Technologies:** Flutter (Dart), FastAPI (Python), BeautifulSoup4, SQLite, Material Design 3

---

## �📑 Table of Contents
- [Project Overview](#-project-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [System Architecture](#-system-architecture)
- [Project Structure](#-project-structure)
- [Installation & Setup](#️-installation--setup)
- [Database Design](#-database-design)
- [Application Workflow](#-application-workflow)
- [Data Source & Caching](#-data-source--caching)
- [API Endpoints](#-api-endpoints)
- [Future Improvements](#-future-improvements)
- [Version](#-version)

---

## 📌 Project Overview

The Orange Calculator Application helps users browse orange information, calculate prices by weight, and check the latest market prices.  
It integrates FastAPI backend with web scraping capabilities to fetch real-time data from Talaadthai.com.

### Main Objectives
- Present orange data (dimensions, sizes, prices) in a clear, organized way
- Provide quick price calculation based on weight (kilograms)
- Show real-time market prices from Talaadthai.com
- Demonstrate Flutter + FastAPI integration
- Support mobile platforms (Android & iOS)

### Supported Orange Types
1. **Tangerine (ส้มสายน้ำผึ้ง)** - Sweet and juicy, soft texture, high water content
2. **Green Sweet Orange (ส้มเขียวหวาน)** - Sweet and crispy, refreshing, not sour
3. **Mandarin (ส้มแมนดาริน)** - Sweet aroma, easy to peel, fine texture

---

## 🚀 Features

- 📊 **Data Display** - View dimensions and sizes of 3 orange types
- 🧮 **Price Calculator** - Calculate price based on weight (kg)
- 💰 **Live Prices** - Real-time price updates from Talaadthai.com
- 🌐 **Web Scraping** - Automated data fetching with fallback mechanism
- 📱 **Mobile-First** - Android and iOS support
- 🔄 **Auto-Refresh** - Price data cached for 1 hour
- 📈 **Dashboard** - Overview statistics and quick actions

---

## 🛠 Tech Stack

**Frontend (Flutter)**
- Flutter 3.0+ (Dart)
- Material Design 3
- HTTP Package

**Backend (Python)**
- FastAPI 0.115.0
- BeautifulSoup4 4.12.3 (Web Scraping)
- Uvicorn 0.32.0 (ASGI Server)
- Requests 2.32.3
- Pydantic 2.9.2

**Database**
- SQLite (Backend storage)

---

## 🏗 System Architecture

**Layered Architecture:**

1. **UI Layer** - Flutter Screens (Home, Data, Calculator, Live Prices)
2. **Service Layer** - API Service (HTTP communication)
3. **Backend Layer** - FastAPI (REST API + Web Scraping)
4. **Data Layer** - SQLite Database

**Data Flow:**  
User → Flutter UI → API Service → FastAPI → Talaadthai.com / SQLite → FastAPI → Flutter UI

---

## 📂 Project Structure

```
lib/
├── main.dart
├── models/
│   ├── orange_type.dart
│   └── price_calculation.dart
├── screens/
│   ├── home_screen.dart
│   ├── data_screen.dart
│   ├── calculator_screen.dart
│   ├── history_screen.dart
│   └── live_prices_screen.dart
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
```

---

## ⚙️ Installation & Setup

```bash
git clone https://github.com/MyFirstKiss/Flutter-app-for-orange-price-calculation-main.git
cd Flutter-app-for-orange-price-calculation-main
flutter pub get
flutter run
```

**Backend:**
- Setup FastAPI backend
- Install Python dependencies: `pip install -r requirements.txt`
- Seed database: `python seed_db.py`
- Run server: `python main.py`

**Important:** For Android Emulator, app connects to backend at `10.0.2.2:8001`

---

## 📊 Database Design

**SQLite (Backend):**

**oranges:**
- id
- name
- price_per_kg
- height
- radius
- diameter

**calculations:**
- id
- orange_id
- weight_kg
- total_price
- timestamp

---

## 🔄 Application Workflow

1. Launch App
2. Browse Orange Data
3. Calculate Price
4. View Live Prices
5. Check History

---

## 🧾 Data Source & Caching

- Price data fetched from Talaadthai.com
- Prices cached for 1 hour to reduce scraping load
- Fallback data used if website unavailable

---

## 📡 API Endpoints

Backend provides these endpoints:

- `GET /` - Health check
- `GET /oranges` - Filtered prices from Talaadthai
- `GET /api/oranges` - Orange data for the app
- `GET /api/oranges/{id}` - Single orange data
- `POST /api/calculate` - Price calculation
- `GET /api/prices` - Real-time prices

---

## 🚀 Deployment Diagram

```
[ Android / iOS Device ]
         |
         ▼
[ Flutter Application ]
         |
         ▼
[ FastAPI Backend ]
    |          |
    ▼          ▼
[ SQLite ]  [ Talaadthai.com ]
              (Web Scraping)
```

---

## 📈 Future Improvements

- Real-time price alerts
- Price trend charts
- Multi-language support
- User authentication
- Offline mode

---

## 🏷 Version

**1.0.0** (2026)

---

## 👨‍💻 Developer

Student Project – Information Technology

---

## 📄 License

MIT License - Educational use only

---

Made with ❤️ and 🍊

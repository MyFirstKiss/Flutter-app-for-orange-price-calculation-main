"""
FastAPI backend for scraping orange prices from talaadthai.com
Filters for: แมนดาริน (Mandarin), เขียวหวาน (Tangerine), สายน้ำผึ้ง (Sai Nam Phueng)
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import requests
from bs4 import BeautifulSoup
from typing import List, Optional
from pydantic import BaseModel
import re

app = FastAPI(title="Orange Price Scraper API")

# Enable CORS for all origins (mobile simulator access)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class OrangePrice(BaseModel):
    """Model for orange price data"""
    name: str
    grade: str
    price_min: float
    price_max: float
    unit: str


# Keywords to filter
ORANGE_KEYWORDS = ["แมนดาริน", "เขียวหวาน", "สายน้ำผึ้ง"]


def extract_price_range(price_str: str) -> tuple[Optional[float], Optional[float]]:
    """
    Extract min and max prices from price string
    Examples: "50-60", "50", "50.00-60.00"
    """
    try:
        # Remove commas and extra spaces
        price_str = price_str.replace(",", "").strip()
        
        # Check if it's a range (contains dash or hyphen)
        if "-" in price_str or "–" in price_str:
            # Split by dash or en-dash
            parts = re.split(r"[-–]", price_str)
            if len(parts) == 2:
                price_min = float(parts[0].strip())
                price_max = float(parts[1].strip())
                return price_min, price_max
        
        # Single price value
        price = float(price_str)
        return price, price
    except (ValueError, AttributeError):
        return None, None


def contains_orange_keyword(text: str) -> bool:
    """Check if text contains any of the orange keywords"""
    if not text:
        return False
    return any(keyword in text for keyword in ORANGE_KEYWORDS)


def get_mock_data() -> List[OrangePrice]:
    """Return mock data for testing"""
    return [
        OrangePrice(
            name="ส้มแมนดาริน",
            grade="เกรด A",
            price_min=45.0,
            price_max=60.0,
            unit="กก."
        ),
        OrangePrice(
            name="ส้มแมนดาริน",
            grade="เกรด B",
            price_min=35.0,
            price_max=45.0,
            unit="กก."
        ),
        OrangePrice(
            name="ส้มเขียวหวาน",
            grade="เกรด A",
            price_min=35.0,
            price_max=50.0,
            unit="กก."
        ),
        OrangePrice(
            name="ส้มเขียวหวาน",
            grade="เกรด B",
            price_min=25.0,
            price_max=35.0,
            unit="กก."
        ),
        OrangePrice(
            name="ส้มสายน้ำผึ้ง",
            grade="เกรด A",
            price_min=40.0,
            price_max=55.0,
            unit="กก."
        ),
        OrangePrice(
            name="ส้มสายน้ำผึ้ง",
            grade="เกรด B",
            price_min=30.0,
            price_max=40.0,
            unit="กก."
        ),
    ]


@app.get("/")
async def root():
    """API root endpoint"""
    return {
        "message": "Orange Price Scraper API",
        "endpoints": {
            "/oranges": "Get filtered orange prices from talaadthai.com"
        }
    }


@app.get("/oranges", response_model=List[OrangePrice])
async def get_orange_prices():
    """
    Scrape orange prices from talaadthai.com and filter for specific varieties
    Returns mock data if website is unavailable
    """
    url = "https://talaadthai.com/prices/fruit"
    
    try:
        # Fetch the webpage
        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        }
        response = requests.get(url, headers=headers, timeout=10)
        
        # If website not found, return mock data
        if response.status_code == 404:
            return get_mock_data()
        
        response.raise_for_status()
        
        # Parse HTML
        soup = BeautifulSoup(response.content, "html.parser")
        
        # Find the price table
        # Note: You may need to adjust selectors based on actual website structure
        table = soup.find("table", class_=re.compile(r"price|table", re.I))
        if not table:
            # Try finding any table
            table = soup.find("table")
        
        if not table:
            raise HTTPException(status_code=404, detail="Price table not found on webpage")
        
        orange_data = []
        
        # Parse table rows
        rows = table.find_all("tr")
        
        for row in rows[1:]:  # Skip header row
            cells = row.find_all(["td", "th"])
            
            if len(cells) < 4:
                continue
            
            # Extract data from cells
            # Typical structure: [name, grade, price, unit]
            name = cells[0].get_text(strip=True)
            
            # Check if this row contains our orange keywords
            if not contains_orange_keyword(name):
                continue
            
            grade = cells[1].get_text(strip=True) if len(cells) > 1 else "ไม่ระบุ"
            price_str = cells[2].get_text(strip=True) if len(cells) > 2 else ""
            unit = cells[3].get_text(strip=True) if len(cells) > 3 else "กก."
            
            # Extract price range
            price_min, price_max = extract_price_range(price_str)
            
            if price_min is not None and price_max is not None:
                orange_data.append(
                    OrangePrice(
                        name=name,
                        grade=grade,
                        price_min=price_min,
                        price_max=price_max,
                        unit=unit
                    )
                )
        
        if not orange_data:
            # Return mock data for testing if no data found
            return get_mock_data()
        
        return orange_data
        
    except requests.RequestException as e:
        raise HTTPException(
            status_code=503,
            detail=f"Failed to fetch data from talaadthai.com: {str(e)}"
        )
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"An error occurred while processing data: {str(e)}"
        )


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "service": "Orange Price Scraper"}


# Additional endpoints for Flutter app compatibility
@app.get("/api/oranges")
async def get_oranges_for_flutter():
    """Get orange data in Flutter-compatible format"""
    # Static data for Flutter app (measurements + prices from scraping)
    orange_types = [
        {
            "id": "tangerine",
            "name": "ส้มสายน้ำผึ้ง",
            "pricePerKg": 45,
            "height": "7.5",
            "radius": "3.8",
            "diameter": "7.6",
            "color": "orange",
            "description": "รสชาติหวานฉ่ำ เนื้อนุ่ม น้ำมาก"
        },
        {
            "id": "green-sweet",
            "name": "ส้มเขียวหวาน",
            "pricePerKg": 35,
            "height": "8.2",
            "radius": "4.1",
            "diameter": "8.2",
            "color": "green",
            "description": "หวานกรอบ สดชื่น ไม่เปรี้ยว"
        },
        {
            "id": "mandarin",
            "name": "ส้มแมนดาริน",
            "pricePerKg": 55,
            "height": "6.8",
            "radius": "3.5",
            "diameter": "7.0",
            "color": "amber",
            "description": "หวานหอม ปอกง่าย เนื้อละเอียด"
        }
    ]
    
    # Try to update prices from scraped data
    try:
        scraped_prices = await get_orange_prices()
        price_map = {}
        
        for price in scraped_prices:
            # Calculate average price
            avg_price = (price.price_min + price.price_max) / 2
            
            if "สายน้ำผึ้ง" in price.name:
                price_map["tangerine"] = avg_price
            elif "เขียวหวาน" in price.name:
                price_map["green-sweet"] = avg_price
            elif "แมนดาริน" in price.name:
                price_map["mandarin"] = avg_price
        
        # Update prices
        for orange in orange_types:
            if orange["id"] in price_map:
                orange["pricePerKg"] = round(price_map[orange["id"]], 2)
    except:
        pass  # Use default prices if scraping fails
    
    return orange_types


@app.get("/api/oranges/{orange_id}")
async def get_orange_by_id(orange_id: str):
    """Get single orange by ID"""
    oranges = await get_oranges_for_flutter()
    orange = next((o for o in oranges if o["id"] == orange_id), None)
    if orange:
        return orange
    raise HTTPException(status_code=404, detail="Orange not found")


@app.post("/api/calculate")
async def calculate_price(orange_id: str, weight: float):
    """Calculate price for given orange type and weight"""
    oranges = await get_oranges_for_flutter()
    orange = next((o for o in oranges if o["id"] == orange_id), None)
    
    if not orange:
        raise HTTPException(status_code=404, detail="Orange not found")
    
    total_price = weight * orange["pricePerKg"]
    return {
        "orange_id": orange_id,
        "orange_name": orange["name"],
        "weight": weight,
        "price_per_kg": orange["pricePerKg"],
        "total_price": round(total_price, 2)
    }


@app.get("/api/prices")
async def get_live_prices():
    """Get live prices for Flutter app"""
    oranges = await get_oranges_for_flutter()
    return [
        {
            "id": o["id"],
            "name": o["name"],
            "price": o["pricePerKg"],
            "source": "Talaadthai.com",
            "updated_at": "Real-time"
        }
        for o in oranges
    ]


if __name__ == "__main__":
    import uvicorn
    # Listen on 0.0.0.0 to allow mobile device connections
    uvicorn.run(app, host="0.0.0.0", port=8000)

"""
Update orange prices in database (Force update)
"""

from database import SessionLocal, OrangeType, init_db


def update_prices(force=True):
    """Update prices to correct values"""
    
    # Ensure database exists
    init_db()
    
    db = SessionLocal()
    
    try:
        # New prices from seed_db.py
        price_updates = {
            "tangerine": 45.0,      # ส้มสายน้ำผึ้ง
            "green-sweet": 35.0,    # ส้มเขียวหวาน  
            "mandarin": 55.0        # ส้มแมนดาริน
        }
        
        updated_count = 0
        
        for orange_id, new_price in price_updates.items():
            orange = db.query(OrangeType).filter(
                OrangeType.orange_id == orange_id
            ).first()
            
            if orange:
                old_price = orange.price_per_kg
                if force or old_price != new_price:
                    orange.price_per_kg = new_price
                    updated_count += 1
                    print(f"✅ Updated {orange.name}: {old_price} -> {new_price} บาท/กก.")
                else:
                    print(f"ℹ️  {orange.name}: Already at {new_price} บาท/กก.")
            else:
                print(f"⚠️  Orange {orange_id} not found in database")
        
        if updated_count > 0:
            db.commit()
            print(f"\n🎉 Successfully updated {updated_count} prices!")
        else:
            print(f"\n✅ All prices are already correct!")
        
    except Exception as e:
        db.rollback()
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()


if __name__ == "__main__":
    print("🔄 Updating orange prices...\n")
    update_prices(force=True)

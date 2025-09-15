from sqlalchemy import Column, Integer, String, Float, DateTime, Enum, JSON
from sqlalchemy.sql import func
import enum
from app.database import Base


class ProductCategory(str, enum.Enum):
    FOOD = "food"
    GROOMING = "grooming"
    TOYS = "toys"
    HEALTH = "health"
    ACCESSORIES = "accessories"
    OTHER = "other"


class Product(Base):
    __tablename__ = "products"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(200), nullable=False)
    description = Column(String(2000), nullable=True)
    price = Column(Float, nullable=False)
    rating = Column(Float, default=0.0)
    image_urls = Column(JSON, nullable=True)  # List of image URLs
    category = Column(Enum(ProductCategory), nullable=False, default=ProductCategory.OTHER)
    stock = Column(Integer, default=0)
    brand = Column(String(100), nullable=True)
    weight = Column(Float, nullable=True)  # Weight in kg
    external_url = Column(String(500), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())




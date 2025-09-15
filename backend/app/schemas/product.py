from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from app.models.product import ProductCategory


class ProductBase(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    category: ProductCategory
    stock: int = 0
    brand: Optional[str] = None
    weight: Optional[float] = None
    external_url: Optional[str] = None


class ProductCreate(ProductBase):
    image_urls: Optional[List[str]] = None


class ProductUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    price: Optional[float] = None
    rating: Optional[float] = None
    image_urls: Optional[List[str]] = None
    category: Optional[ProductCategory] = None
    stock: Optional[int] = None
    brand: Optional[str] = None
    weight: Optional[float] = None
    external_url: Optional[str] = None


class ProductInDB(ProductBase):
    id: int
    rating: float = 0.0
    image_urls: Optional[List[str]] = None
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class Product(ProductInDB):
    pass

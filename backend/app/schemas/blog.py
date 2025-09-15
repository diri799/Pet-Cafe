from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from app.models.blog import BlogCategory


class BlogPostBase(BaseModel):
    title: str
    content: str
    category: BlogCategory
    tags: Optional[str] = None
    image_url: Optional[str] = None
    published: bool = False


class BlogPostCreate(BlogPostBase):
    pass


class BlogPostUpdate(BaseModel):
    title: Optional[str] = None
    content: Optional[str] = None
    category: Optional[BlogCategory] = None
    tags: Optional[str] = None
    image_url: Optional[str] = None
    published: Optional[bool] = None


class BlogPostInDB(BlogPostBase):
    id: int
    author_id: int
    likes_count: int = 0
    comments_count: int = 0
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class BlogPost(BlogPostInDB):
    pass




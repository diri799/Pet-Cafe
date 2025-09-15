from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
import enum
from app.database import Base


class BlogCategory(str, enum.Enum):
    HEALTH = "health"
    NUTRITION = "nutrition"
    TRAINING = "training"
    GROOMING = "grooming"
    BEHAVIOR = "behavior"
    GENERAL = "general"


class BlogPost(Base):
    __tablename__ = "blog_posts"

    id = Column(Integer, primary_key=True, index=True)
    author_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    title = Column(String(200), nullable=False)
    content = Column(String(10000), nullable=False)
    category = Column(Enum(BlogCategory), nullable=False, default=BlogCategory.GENERAL)
    tags = Column(String(500), nullable=True)  # Comma-separated tags
    image_url = Column(String(500), nullable=True)
    published = Column(String(1), default="0")  # SQLite boolean workaround
    likes_count = Column(Integer, default=0)
    comments_count = Column(Integer, default=0)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    author = relationship("User", back_populates="blog_posts")

    @property
    def published_bool(self) -> bool:
        return self.published == "1"

    @published_bool.setter
    def published_bool(self, value: bool):
        self.published = "1" if value else "0"




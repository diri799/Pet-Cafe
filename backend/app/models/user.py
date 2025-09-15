from sqlalchemy import Column, Integer, String, DateTime, Enum
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
import enum
from app.database import Base


class UserRole(str, enum.Enum):
    PET_OWNER = "pet_owner"
    VETERINARIAN = "veterinarian"
    SHELTER_ADMIN = "shelter_admin"


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    email = Column(String(255), unique=True, index=True, nullable=False)
    phone = Column(String(20), nullable=True)
    role = Column(Enum(UserRole), nullable=False, default=UserRole.PET_OWNER)
    hashed_password = Column(String(255), nullable=False)
    is_active = Column(String(1), default="1")  # SQLite doesn't have boolean
    is_verified = Column(String(1), default="0")
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    pets = relationship("Pet", back_populates="owner")
    blog_posts = relationship("BlogPost", back_populates="author")
    adoption_requests = relationship("AdoptionRequest", back_populates="requester")
    shelter_pets = relationship("ShelterPet", back_populates="shelter")

    @property
    def is_active_bool(self) -> bool:
        return self.is_active == "1"

    @is_active_bool.setter
    def is_active_bool(self, value: bool):
        self.is_active = "1" if value else "0"

    @property
    def is_verified_bool(self) -> bool:
        return self.is_verified == "1"

    @is_verified_bool.setter
    def is_verified_bool(self, value: bool):
        self.is_verified = "1" if value else "0"

from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
import enum
from app.database import Base


class PetGender(str, enum.Enum):
    MALE = "male"
    FEMALE = "female"
    OTHER = "other"


class AdoptionStatus(str, enum.Enum):
    AVAILABLE = "available"
    PENDING = "pending"
    ADOPTED = "adopted"


class RequestStatus(str, enum.Enum):
    PENDING = "pending"
    APPROVED = "approved"
    REJECTED = "rejected"


class ShelterPet(Base):
    __tablename__ = "shelter_pets"

    id = Column(Integer, primary_key=True, index=True)
    shelter_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    name = Column(String(100), nullable=False)
    species = Column(String(50), nullable=False)
    breed = Column(String(100), nullable=True)
    age = Column(Integer, nullable=False, default=0)
    gender = Column(Enum(PetGender), nullable=False, default=PetGender.OTHER)
    photo = Column(String(500), nullable=True)
    description = Column(String(1000), nullable=True)
    health_status = Column(String(200), nullable=True)
    adoption_status = Column(Enum(AdoptionStatus), nullable=False, default=AdoptionStatus.AVAILABLE)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    shelter = relationship("User", back_populates="shelter_pets")
    adoption_requests = relationship("AdoptionRequest", back_populates="shelter_pet")


class AdoptionRequest(Base):
    __tablename__ = "adoption_requests"

    id = Column(Integer, primary_key=True, index=True)
    shelter_pet_id = Column(Integer, ForeignKey("shelter_pets.id"), nullable=False)
    requester_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    request_date = Column(DateTime(timezone=True), nullable=False)
    status = Column(Enum(RequestStatus), nullable=False, default=RequestStatus.PENDING)
    notes = Column(String(1000), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    shelter_pet = relationship("ShelterPet", back_populates="adoption_requests")
    requester = relationship("User", back_populates="adoption_requests")




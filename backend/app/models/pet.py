from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
import enum
from app.database import Base


class PetGender(str, enum.Enum):
    MALE = "male"
    FEMALE = "female"
    OTHER = "other"


class HealthRecordType(str, enum.Enum):
    VACCINATION = "vaccination"
    CHECKUP = "checkup"
    TREATMENT = "treatment"
    DEWORMING = "deworming"


class Pet(Base):
    __tablename__ = "pets"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    name = Column(String(100), nullable=False)
    species = Column(String(50), nullable=False)
    breed = Column(String(100), nullable=True)
    age = Column(Integer, nullable=False, default=0)
    gender = Column(Enum(PetGender), nullable=False, default=PetGender.OTHER)
    photo = Column(String(500), nullable=True)
    description = Column(String(1000), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    owner = relationship("User", back_populates="pets")
    appointments = relationship("Appointment", back_populates="pet")
    health_records = relationship("PetHealthRecord", back_populates="pet")


class PetHealthRecord(Base):
    __tablename__ = "pet_health_records"

    id = Column(Integer, primary_key=True, index=True)
    pet_id = Column(Integer, ForeignKey("pets.id"), nullable=False)
    veterinarian_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    visit_date = Column(DateTime(timezone=True), nullable=False)
    diagnosis = Column(String(500), nullable=True)
    prescription = Column(String(1000), nullable=True)
    treatment_notes = Column(String(2000), nullable=True)
    next_due_date = Column(DateTime(timezone=True), nullable=True)
    record_type = Column(Enum(HealthRecordType), nullable=False, default=HealthRecordType.CHECKUP)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    pet = relationship("Pet", back_populates="health_records")
    veterinarian = relationship("User", foreign_keys=[veterinarian_id])




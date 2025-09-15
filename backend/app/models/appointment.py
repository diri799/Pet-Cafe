from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
import enum
from app.database import Base


class AppointmentStatus(str, enum.Enum):
    SCHEDULED = "scheduled"
    CONFIRMED = "confirmed"
    COMPLETED = "completed"
    CANCELLED = "cancelled"
    RESCHEDULED = "rescheduled"


class Appointment(Base):
    __tablename__ = "appointments"

    id = Column(Integer, primary_key=True, index=True)
    pet_id = Column(Integer, ForeignKey("pets.id"), nullable=False)
    veterinarian_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    shelter_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    appointment_date = Column(DateTime(timezone=True), nullable=False)
    appointment_time = Column(String(10), nullable=False)  # Format: "HH:MM"
    status = Column(Enum(AppointmentStatus), nullable=False, default=AppointmentStatus.SCHEDULED)
    reason = Column(String(500), nullable=True)
    notes = Column(String(1000), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    pet = relationship("Pet", back_populates="appointments")
    veterinarian = relationship("User", foreign_keys=[veterinarian_id])
    shelter = relationship("User", foreign_keys=[shelter_id])

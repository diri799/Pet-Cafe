from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from app.models.appointment import AppointmentStatus


class AppointmentBase(BaseModel):
    appointment_date: datetime
    appointment_time: str
    reason: Optional[str] = None
    notes: Optional[str] = None


class AppointmentCreate(AppointmentBase):
    pet_id: int
    veterinarian_id: Optional[int] = None
    shelter_id: Optional[int] = None


class AppointmentUpdate(BaseModel):
    appointment_date: Optional[datetime] = None
    appointment_time: Optional[str] = None
    status: Optional[AppointmentStatus] = None
    reason: Optional[str] = None
    notes: Optional[str] = None
    veterinarian_id: Optional[int] = None


class AppointmentInDB(AppointmentBase):
    id: int
    pet_id: int
    veterinarian_id: Optional[int] = None
    shelter_id: Optional[int] = None
    status: AppointmentStatus
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class Appointment(AppointmentInDB):
    pass

from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from app.models.pet import PetGender, HealthRecordType


class PetBase(BaseModel):
    name: str
    species: str
    breed: Optional[str] = None
    age: int = 0
    gender: PetGender
    photo: Optional[str] = None
    description: Optional[str] = None


class PetCreate(PetBase):
    pass


class PetUpdate(BaseModel):
    name: Optional[str] = None
    species: Optional[str] = None
    breed: Optional[str] = None
    age: Optional[int] = None
    gender: Optional[PetGender] = None
    photo: Optional[str] = None
    description: Optional[str] = None


class PetInDB(PetBase):
    id: int
    user_id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class Pet(PetInDB):
    pass


class PetHealthRecordBase(BaseModel):
    visit_date: datetime
    diagnosis: Optional[str] = None
    prescription: Optional[str] = None
    treatment_notes: Optional[str] = None
    next_due_date: Optional[datetime] = None
    record_type: HealthRecordType = HealthRecordType.CHECKUP


class PetHealthRecordCreate(PetHealthRecordBase):
    veterinarian_id: Optional[int] = None


class PetHealthRecordUpdate(BaseModel):
    visit_date: Optional[datetime] = None
    diagnosis: Optional[str] = None
    prescription: Optional[str] = None
    treatment_notes: Optional[str] = None
    next_due_date: Optional[datetime] = None
    record_type: Optional[HealthRecordType] = None
    veterinarian_id: Optional[int] = None


class PetHealthRecordInDB(PetHealthRecordBase):
    id: int
    pet_id: int
    veterinarian_id: Optional[int] = None
    created_at: datetime

    class Config:
        from_attributes = True


class PetHealthRecord(PetHealthRecordInDB):
    pass




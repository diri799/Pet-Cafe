from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from app.models.shelter import PetGender, AdoptionStatus, RequestStatus


class ShelterPetBase(BaseModel):
    name: str
    species: str
    breed: Optional[str] = None
    age: int = 0
    gender: PetGender
    photo: Optional[str] = None
    description: Optional[str] = None
    health_status: Optional[str] = None


class ShelterPetCreate(ShelterPetBase):
    pass


class ShelterPetUpdate(BaseModel):
    name: Optional[str] = None
    species: Optional[str] = None
    breed: Optional[str] = None
    age: Optional[int] = None
    gender: Optional[PetGender] = None
    photo: Optional[str] = None
    description: Optional[str] = None
    health_status: Optional[str] = None
    adoption_status: Optional[AdoptionStatus] = None


class ShelterPetInDB(ShelterPetBase):
    id: int
    shelter_id: int
    adoption_status: AdoptionStatus
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class ShelterPet(ShelterPetInDB):
    pass


class AdoptionRequestBase(BaseModel):
    request_date: datetime
    notes: Optional[str] = None


class AdoptionRequestCreate(AdoptionRequestBase):
    shelter_pet_id: int


class AdoptionRequestUpdate(BaseModel):
    status: Optional[RequestStatus] = None
    notes: Optional[str] = None


class AdoptionRequestInDB(AdoptionRequestBase):
    id: int
    shelter_pet_id: int
    requester_id: int
    status: RequestStatus
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class AdoptionRequest(AdoptionRequestInDB):
    pass




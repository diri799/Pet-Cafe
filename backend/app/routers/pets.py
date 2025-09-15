from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List, Optional

from app.database import get_db
from app.models.pet import Pet, PetHealthRecord
from app.models.user import User
from app.schemas.pet import (
    Pet as PetSchema, 
    PetCreate, 
    PetUpdate,
    PetHealthRecord as PetHealthRecordSchema,
    PetHealthRecordCreate,
    PetHealthRecordUpdate
)
from app.routers.auth import get_current_user

router = APIRouter()


@router.get("/", response_model=List[PetSchema])
async def get_pets(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    user_id: Optional[int] = None,
    species: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get list of pets with optional filtering."""
    query = db.query(Pet)
    
    if user_id:
        query = query.filter(Pet.user_id == user_id)
    if species:
        query = query.filter(Pet.species.ilike(f"%{species}%"))
    
    pets = query.offset(skip).limit(limit).all()
    return pets


@router.get("/{pet_id}", response_model=PetSchema)
async def get_pet(
    pet_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get pet by ID."""
    pet = db.query(Pet).filter(Pet.id == pet_id).first()
    if not pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pet not found"
        )
    return pet


@router.post("/", response_model=PetSchema)
async def create_pet(
    pet_data: PetCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new pet."""
    db_pet = Pet(
        user_id=current_user.id,
        **pet_data.dict()
    )
    
    db.add(db_pet)
    db.commit()
    db.refresh(db_pet)
    
    return db_pet


@router.put("/{pet_id}", response_model=PetSchema)
async def update_pet(
    pet_id: int,
    pet_update: PetUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update pet information."""
    pet = db.query(Pet).filter(Pet.id == pet_id).first()
    if not pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pet not found"
        )
    
    # Users can only update their own pets
    if pet.user_id != current_user.id and current_user.role != "shelter_admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    
    # Update fields
    update_data = pet_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(pet, field, value)
    
    db.commit()
    db.refresh(pet)
    return pet


@router.delete("/{pet_id}")
async def delete_pet(
    pet_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Delete pet."""
    pet = db.query(Pet).filter(Pet.id == pet_id).first()
    if not pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pet not found"
        )
    
    # Users can only delete their own pets
    if pet.user_id != current_user.id and current_user.role != "shelter_admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    
    db.delete(pet)
    db.commit()
    
    return {"message": "Pet deleted successfully"}


# Health Records endpoints
@router.get("/{pet_id}/health-records", response_model=List[PetHealthRecordSchema])
async def get_pet_health_records(
    pet_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get health records for a pet."""
    pet = db.query(Pet).filter(Pet.id == pet_id).first()
    if not pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pet not found"
        )
    
    # Users can only view their own pets' records
    if pet.user_id != current_user.id and current_user.role not in ["veterinarian", "shelter_admin"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    
    health_records = db.query(PetHealthRecord).filter(PetHealthRecord.pet_id == pet_id).all()
    return health_records


@router.post("/{pet_id}/health-records", response_model=PetHealthRecordSchema)
async def create_pet_health_record(
    pet_id: int,
    health_record_data: PetHealthRecordCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new health record for a pet."""
    pet = db.query(Pet).filter(Pet.id == pet_id).first()
    if not pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pet not found"
        )
    
    # Only veterinarians and pet owners can create health records
    if current_user.role not in ["veterinarian", "pet_owner"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    
    db_health_record = PetHealthRecord(
        pet_id=pet_id,
        veterinarian_id=current_user.id if current_user.role == "veterinarian" else health_record_data.veterinarian_id,
        **health_record_data.dict(exclude={"veterinarian_id"})
    )
    
    db.add(db_health_record)
    db.commit()
    db.refresh(db_health_record)
    
    return db_health_record

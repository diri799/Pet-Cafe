from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List, Optional

from app.database import get_db
from app.models.shelter import ShelterPet, AdoptionRequest
from app.models.user import User
from app.schemas.shelter import (
    ShelterPet as ShelterPetSchema,
    ShelterPetCreate,
    ShelterPetUpdate,
    AdoptionRequest as AdoptionRequestSchema,
    AdoptionRequestCreate,
    AdoptionRequestUpdate
)
from app.routers.auth import get_current_user

router = APIRouter()


@router.get("/pets", response_model=List[ShelterPetSchema])
async def get_shelter_pets(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    shelter_id: Optional[int] = None,
    species: Optional[str] = None,
    adoption_status: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Get list of shelter pets with optional filtering."""
    query = db.query(ShelterPet)
    
    if shelter_id:
        query = query.filter(ShelterPet.shelter_id == shelter_id)
    if species:
        query = query.filter(ShelterPet.species.ilike(f"%{species}%"))
    if adoption_status:
        query = query.filter(ShelterPet.adoption_status == adoption_status)
    
    shelter_pets = query.offset(skip).limit(limit).all()
    return shelter_pets


@router.get("/pets/{pet_id}", response_model=ShelterPetSchema)
async def get_shelter_pet(
    pet_id: int,
    db: Session = Depends(get_db)
):
    """Get shelter pet by ID."""
    shelter_pet = db.query(ShelterPet).filter(ShelterPet.id == pet_id).first()
    if not shelter_pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Shelter pet not found"
        )
    return shelter_pet


@router.post("/pets", response_model=ShelterPetSchema)
async def create_shelter_pet(
    pet_data: ShelterPetCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new shelter pet (shelter admin only)."""
    if current_user.role != "shelter_admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only shelter admins can add pets"
        )
    
    db_shelter_pet = ShelterPet(
        shelter_id=current_user.id,
        **pet_data.dict()
    )
    
    db.add(db_shelter_pet)
    db.commit()
    db.refresh(db_shelter_pet)
    
    return db_shelter_pet


@router.put("/pets/{pet_id}", response_model=ShelterPetSchema)
async def update_shelter_pet(
    pet_id: int,
    pet_update: ShelterPetUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update shelter pet."""
    shelter_pet = db.query(ShelterPet).filter(ShelterPet.id == pet_id).first()
    if not shelter_pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Shelter pet not found"
        )
    
    # Only the shelter that owns the pet can update it
    if shelter_pet.shelter_id != current_user.id and current_user.role != "shelter_admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    
    # Update fields
    update_data = pet_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(shelter_pet, field, value)
    
    db.commit()
    db.refresh(shelter_pet)
    return shelter_pet


@router.delete("/pets/{pet_id}")
async def delete_shelter_pet(
    pet_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Delete shelter pet."""
    shelter_pet = db.query(ShelterPet).filter(ShelterPet.id == pet_id).first()
    if not shelter_pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Shelter pet not found"
        )
    
    # Only the shelter that owns the pet can delete it
    if shelter_pet.shelter_id != current_user.id and current_user.role != "shelter_admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    
    db.delete(shelter_pet)
    db.commit()
    
    return {"message": "Shelter pet deleted successfully"}


# Adoption Requests endpoints
@router.get("/adoption-requests", response_model=List[AdoptionRequestSchema])
async def get_adoption_requests(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    requester_id: Optional[int] = None,
    shelter_id: Optional[int] = None,
    status: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get list of adoption requests with optional filtering."""
    query = db.query(AdoptionRequest)
    
    # Filter based on user role
    if current_user.role == "pet_owner":
        # Pet owners can only see their own requests
        query = query.filter(AdoptionRequest.requester_id == current_user.id)
    elif current_user.role == "shelter_admin":
        # Shelter admins can see requests for their pets
        query = query.join(AdoptionRequest.shelter_pet).filter(
            ShelterPet.shelter_id == current_user.id
        )
    
    if requester_id:
        query = query.filter(AdoptionRequest.requester_id == requester_id)
    if shelter_id:
        query = query.join(AdoptionRequest.shelter_pet).filter(
            ShelterPet.shelter_id == shelter_id
        )
    if status:
        query = query.filter(AdoptionRequest.status == status)
    
    adoption_requests = query.offset(skip).limit(limit).all()
    return adoption_requests


@router.get("/adoption-requests/{request_id}", response_model=AdoptionRequestSchema)
async def get_adoption_request(
    request_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get adoption request by ID."""
    adoption_request = db.query(AdoptionRequest).filter(AdoptionRequest.id == request_id).first()
    if not adoption_request:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Adoption request not found"
        )
    
    # Check permissions
    if current_user.role == "pet_owner":
        if adoption_request.requester_id != current_user.id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not enough permissions"
            )
    elif current_user.role == "shelter_admin":
        if adoption_request.shelter_pet.shelter_id != current_user.id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not enough permissions"
            )
    
    return adoption_request


@router.post("/adoption-requests", response_model=AdoptionRequestSchema)
async def create_adoption_request(
    request_data: AdoptionRequestCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new adoption request."""
    # Check if the shelter pet exists
    shelter_pet = db.query(ShelterPet).filter(ShelterPet.id == request_data.shelter_pet_id).first()
    if not shelter_pet:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Shelter pet not found"
        )
    
    # Check if pet is available for adoption
    if shelter_pet.adoption_status != "available":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Pet is not available for adoption"
        )
    
    db_adoption_request = AdoptionRequest(
        requester_id=current_user.id,
        **request_data.dict()
    )
    
    db.add(db_adoption_request)
    db.commit()
    db.refresh(db_adoption_request)
    
    return db_adoption_request


@router.put("/adoption-requests/{request_id}", response_model=AdoptionRequestSchema)
async def update_adoption_request(
    request_id: int,
    request_update: AdoptionRequestUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update adoption request."""
    adoption_request = db.query(AdoptionRequest).filter(AdoptionRequest.id == request_id).first()
    if not adoption_request:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Adoption request not found"
        )
    
    # Check permissions
    can_update = False
    if current_user.role == "pet_owner":
        can_update = adoption_request.requester_id == current_user.id
    elif current_user.role == "shelter_admin":
        can_update = adoption_request.shelter_pet.shelter_id == current_user.id
    
    if not can_update:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    
    # Update fields
    update_data = request_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(adoption_request, field, value)
    
    # If status is approved, update the pet's adoption status
    if request_update.status == "approved":
        adoption_request.shelter_pet.adoption_status = "adopted"
    
    db.commit()
    db.refresh(adoption_request)
    return adoption_request

from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime

from app.database import get_db
from app.models.appointment import Appointment
from app.models.user import User
from app.schemas.appointment import (
    Appointment as AppointmentSchema,
    AppointmentCreate,
    AppointmentUpdate
)
from app.routers.auth import get_current_user

router = APIRouter()


@router.get("/", response_model=List[AppointmentSchema])
async def get_appointments(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    pet_id: Optional[int] = None,
    veterinarian_id: Optional[int] = None,
    status: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get list of appointments with optional filtering."""
    query = db.query(Appointment)
    
    # Filter based on user role
    if current_user.role == "pet_owner":
        # Pet owners can only see appointments for their pets
        query = query.join(Appointment.pet).filter(Appointment.pet.has(user_id=current_user.id))
    elif current_user.role == "veterinarian":
        # Veterinarians can see their own appointments
        query = query.filter(Appointment.veterinarian_id == current_user.id)
    elif current_user.role == "shelter_admin":
        # Shelter admins can see all appointments
        pass
    
    if pet_id:
        query = query.filter(Appointment.pet_id == pet_id)
    if veterinarian_id:
        query = query.filter(Appointment.veterinarian_id == veterinarian_id)
    if status:
        query = query.filter(Appointment.status == status)
    
    appointments = query.offset(skip).limit(limit).all()
    return appointments


@router.get("/{appointment_id}", response_model=AppointmentSchema)
async def get_appointment(
    appointment_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get appointment by ID."""
    appointment = db.query(Appointment).filter(Appointment.id == appointment_id).first()
    if not appointment:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Appointment not found"
        )
    
    # Check permissions
    if current_user.role == "pet_owner":
        if appointment.pet.user_id != current_user.id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not enough permissions"
            )
    elif current_user.role == "veterinarian":
        if appointment.veterinarian_id != current_user.id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not enough permissions"
            )
    
    return appointment


@router.post("/", response_model=AppointmentSchema)
async def create_appointment(
    appointment_data: AppointmentCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new appointment."""
    # Pet owners can create appointments for their pets
    if current_user.role == "pet_owner":
        from app.models.pet import Pet
        pet = db.query(Pet).filter(Pet.id == appointment_data.pet_id).first()
        if not pet or pet.user_id != current_user.id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You can only create appointments for your own pets"
            )
    
    db_appointment = Appointment(**appointment_data.dict())
    
    db.add(db_appointment)
    db.commit()
    db.refresh(db_appointment)
    
    return db_appointment


@router.put("/{appointment_id}", response_model=AppointmentSchema)
async def update_appointment(
    appointment_id: int,
    appointment_update: AppointmentUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update appointment."""
    appointment = db.query(Appointment).filter(Appointment.id == appointment_id).first()
    if not appointment:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Appointment not found"
        )
    
    # Check permissions
    can_update = False
    if current_user.role == "pet_owner":
        can_update = appointment.pet.user_id == current_user.id
    elif current_user.role == "veterinarian":
        can_update = appointment.veterinarian_id == current_user.id
    elif current_user.role == "shelter_admin":
        can_update = True
    
    if not can_update:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    
    # Update fields
    update_data = appointment_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(appointment, field, value)
    
    db.commit()
    db.refresh(appointment)
    return appointment


@router.delete("/{appointment_id}")
async def delete_appointment(
    appointment_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Delete appointment."""
    appointment = db.query(Appointment).filter(Appointment.id == appointment_id).first()
    if not appointment:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Appointment not found"
        )
    
    # Check permissions
    can_delete = False
    if current_user.role == "pet_owner":
        can_delete = appointment.pet.user_id == current_user.id
    elif current_user.role == "veterinarian":
        can_delete = appointment.veterinarian_id == current_user.id
    elif current_user.role == "shelter_admin":
        can_delete = True
    
    if not can_delete:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    
    db.delete(appointment)
    db.commit()
    
    return {"message": "Appointment deleted successfully"}

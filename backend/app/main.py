from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware
from contextlib import asynccontextmanager
import uvicorn

from app.database import engine, Base
from app.routers import auth, users, pets, appointments, products, blog, shelters
from app.core.config import settings

# Import all models to ensure they are registered with SQLAlchemy
from app.models import user, pet, appointment, product, blog, shelter


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    print("Starting up PawfectCare API...")
    # Create database tables
    Base.metadata.create_all(bind=engine)
    print("Database tables created successfully")
    
    yield
    
    # Shutdown
    print("Shutting down PawfectCare API...")


# Create FastAPI app
app = FastAPI(
    title="PawfectCare API",
    description="A comprehensive pet care management API with adoption, veterinary services, and e-commerce features",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Add trusted host middleware for security
app.add_middleware(
    TrustedHostMiddleware,
    allowed_hosts=settings.ALLOWED_HOSTS
)

# Include routers
app.include_router(auth.router, prefix="/api/v1/auth", tags=["Authentication"])
app.include_router(users.router, prefix="/api/v1/users", tags=["Users"])
app.include_router(pets.router, prefix="/api/v1/pets", tags=["Pets"])
app.include_router(appointments.router, prefix="/api/v1/appointments", tags=["Appointments"])
app.include_router(products.router, prefix="/api/v1/products", tags=["Products"])
app.include_router(blog.router, prefix="/api/v1/blog", tags=["Blog"])
app.include_router(shelters.router, prefix="/api/v1/shelters", tags=["Shelters"])


@app.get("/")
async def root():
    return {
        "message": "Welcome to PawfectCare API",
        "version": "1.0.0",
        "docs": "/docs",
        "redoc": "/redoc"
    }


@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "PawfectCare API"}


if __name__ == "__main__":
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )

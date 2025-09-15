# PawfectCare FastAPI Backend

A comprehensive pet care management API built with FastAPI, featuring pet adoption, veterinary services, e-commerce, and blog management.

## Features

- **JWT Authentication** with role-based access control
- **Multi-role System**: Pet Owners, Veterinarians, Shelter Admins
- **Pet Management**: Pet profiles, health records, and medical history
- **Appointment System**: Veterinary appointment booking and management
- **E-commerce**: Product catalog with categories and inventory
- **Blog System**: Pet care articles and tips
- **Adoption System**: Pet adoption requests and management
- **RESTful API** with comprehensive documentation

## Quick Start

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Start the Server

```bash
# Using the startup script (recommended)
python start_server.py

# Or directly with uvicorn
python -m uvicorn app.main:app --reload
```

### 3. Access the API

- **API Base URL**: http://localhost:8000
- **Interactive Docs**: http://localhost:8000/docs
- **ReDoc Documentation**: http://localhost:8000/redoc

### 4. Test the API

```bash
python test_api.py
```

## API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/refresh` - Refresh access token
- `GET /api/v1/auth/me` - Get current user info

### Users
- `GET /api/v1/users/` - List users
- `GET /api/v1/users/{user_id}` - Get user by ID
- `PUT /api/v1/users/{user_id}` - Update user

### Pets
- `GET /api/v1/pets/` - List pets
- `POST /api/v1/pets/` - Create new pet
- `GET /api/v1/pets/{pet_id}` - Get pet by ID
- `PUT /api/v1/pets/{pet_id}` - Update pet
- `DELETE /api/v1/pets/{pet_id}` - Delete pet

### Appointments
- `GET /api/v1/appointments/` - List appointments
- `POST /api/v1/appointments/` - Create appointment
- `PUT /api/v1/appointments/{appointment_id}` - Update appointment

### Products
- `GET /api/v1/products/` - List products
- `POST /api/v1/products/` - Create product (admin only)
- `GET /api/v1/products/{product_id}` - Get product

### Blog
- `GET /api/v1/blog/` - List blog posts
- `POST /api/v1/blog/` - Create blog post
- `GET /api/v1/blog/{post_id}` - Get blog post

### Shelters
- `GET /api/v1/shelters/pets` - List shelter pets
- `POST /api/v1/shelters/pets` - Add shelter pet
- `GET /api/v1/shelters/adoption-requests` - List adoption requests
- `POST /api/v1/shelters/adoption-requests` - Create adoption request

## User Roles

### Pet Owner
- Manage their own pets
- Create and manage appointments
- Request pet adoptions
- View health records

### Veterinarian
- Manage appointments
- Create blog posts
- View and update health records
- Access pet medical information

### Shelter Admin
- Manage shelter pets
- Process adoption requests
- Full system administration
- Manage products and blog posts

## Configuration

### Environment Variables

Create a `.env` file with the following variables:

```env
# Security
SECRET_KEY=your-secret-key-change-this-in-production
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

# Database
DATABASE_URL=sqlite:///./pawfect_care.db

# CORS
ALLOWED_ORIGINS=["http://localhost:3000","http://localhost:8080"]
ALLOWED_HOSTS=["localhost","127.0.0.1"]

# File Upload
MAX_FILE_SIZE=10485760
UPLOAD_DIR=uploads
```

### Database

The application uses SQLite by default. For production, consider PostgreSQL:

```env
DATABASE_URL=postgresql://username:password@localhost/pawfect_care
```

## Development

### Project Structure

```
backend/
├── app/
│   ├── main.py              # FastAPI application
│   ├── database.py          # Database configuration
│   ├── auth.py              # Authentication utilities
│   ├── core/
│   │   └── config.py        # Application settings
│   ├── models/              # SQLAlchemy models
│   ├── schemas/             # Pydantic schemas
│   └── routers/             # API route handlers
├── requirements.txt         # Python dependencies
├── start_server.py          # Server startup script
└── test_api.py             # API testing script
```

### Adding New Endpoints

1. Create a new router in `app/routers/`
2. Define Pydantic schemas in `app/schemas/`
3. Add the router to `app/main.py`
4. Update this README with the new endpoints

### Database Migrations

The application automatically creates database tables on startup. For production, consider using Alembic for proper migrations.

## Testing

### API Testing

```bash
python test_api.py
```

### Manual Testing

Use the interactive API documentation at `/docs` to test endpoints manually.

## Deployment

### Production Considerations

1. **Database**: Use PostgreSQL instead of SQLite
2. **Security**: Set strong SECRET_KEY and configure HTTPS
3. **CORS**: Configure ALLOWED_ORIGINS for your domain
4. **File Storage**: Consider cloud storage for file uploads
5. **Monitoring**: Add logging and monitoring

### Docker Deployment

```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
EXPOSE 8000

CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## Migration from Firebase

This backend replaces Firebase services:

- **Firebase Auth** → JWT Authentication
- **Firestore** → SQLite/PostgreSQL with SQLAlchemy
- **Firebase Storage** → Local file system (extensible to cloud storage)

See `MIGRATION.md` for detailed migration instructions.

## Support

For issues or questions:

1. Check the API documentation at `/docs`
2. Review the test script for usage examples
3. Check the logs for error details
4. Ensure all environment variables are properly set

## License

This project is part of the PawfectCare pet management application.

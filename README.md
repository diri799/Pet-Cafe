# PawfectCare - Pet Care Management App

A comprehensive cross-platform Flutter application for pet care management, veterinary services, and pet adoption.

## Features

### 🐾 Multi-Role Support
- **Pet Owners**: Manage pets, book appointments, shop for supplies
- **Veterinarians**: Manage appointments, medical records, patient care
- **Shelter Admins**: Manage adoptions, volunteers, shelter operations

### 🏠 Core Functionality
- **Pet Profile Management**: Create and manage detailed pet records
- **Appointment Booking**: Schedule and manage veterinary appointments
- **Health Tracking**: Monitor vaccinations, treatments, and health records
- **Pet Store**: Browse and purchase pet supplies with shopping cart
- **Blog & Tips**: Access pet care articles and educational content
- **Animal Feed**: TikTok-style video feed for pet content

### 🛠 Technical Features
- **State Management**: Riverpod for reactive state management
- **Navigation**: GoRouter for declarative routing
- **Database**: SQLite for local data storage
- **Notifications**: Local notifications for reminders
- **Authentication**: Role-based authentication system
- **UI/UX**: Material Design 3 with custom pink theme

## Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd dog
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Demo Credentials
- **Email**: john@example.com
- **Password**: password123
- **Role**: Pet Owner (default)

## Project Structure

```
lib/
├── core/
│   ├── database/          # SQLite database helper
│   ├── models/            # Data models
│   ├── services/          # Core services (auth, notifications)
│   ├── theme/             # App theming
│   └── widgets/           # Reusable widgets
├── features/
│   ├── auth/              # Authentication screens
│   ├── appointment/       # Appointment management
│   ├── blog/              # Blog and content
│   ├── cart/              # Shopping cart functionality
│   ├── home/              # Home screen
│   ├── pet/               # Pet management
│   ├── pet_owner/         # Pet owner dashboard
│   ├── product/           # Product details
│   ├── products/          # Product management
│   ├── shop/              # Pet store
│   ├── shelter/           # Shelter dashboard
│   ├── splash/            # Splash screen
│   └── veterinarian/      # Veterinarian dashboard
├── app_router.dart        # Navigation configuration
└── main.dart              # App entry point
```

## Key Screens

### Authentication
- **Splash Screen**: App loading with animation
- **Login Screen**: User authentication with demo credentials
- **Role Selection**: Choose user role (Pet Owner, Veterinarian, Shelter Admin)

### Pet Owner Dashboard
- **My Pets**: View and manage pet profiles
- **Appointments**: Book and manage veterinary appointments
- **Health**: Track pet health records and vaccinations
- **Profile**: User profile management

### Veterinarian Dashboard
- **Appointments**: Manage daily schedule and patient appointments
- **Patients**: View patient records and medical history
- **Records**: Add and manage medical records
- **Profile**: Veterinarian profile management

### Shelter Dashboard
- **Pets**: Manage adoptable pets
- **Adoptions**: Process adoption requests
- **Volunteers**: Manage volunteer information
- **Profile**: Shelter profile management

### Shopping & Content
- **Pet Store**: Browse products by category with search and filtering
- **Product Details**: Detailed product information with add to cart
- **Shopping Cart**: Manage cart items and checkout
- **Blog**: Read pet care articles and tips
- **Animal Feed**: TikTok-style video content for pets

## Database Schema

The app uses SQLite with the following main tables:
- **users**: User accounts with role-based access
- **pets**: Pet profiles and information
- **appointments**: Veterinary appointment scheduling
- **shelter_pets**: Animals available for adoption
- **adoption_requests**: Adoption application management
- **blog_posts**: Educational content and articles
- **products**: Pet store inventory
- **notifications**: Push notification management

## State Management

The app uses **Riverpod** for state management:
- `cartNotifierProvider`: Shopping cart state
- `productNotifierProvider`: Product catalog state
- `featuredProductsProvider`: Featured products display

## Navigation

**GoRouter** handles all navigation with:
- Role-based route protection
- Deep linking support
- Nested navigation for dashboards
- Error handling for invalid routes

## Styling

**Material Design 3** with custom pink theme:
- Primary Color: Light Pink (#FFB6C1)
- Accent Color: Pink Sherbet (#FF85A2)
- Consistent spacing and typography
- Responsive design for different screen sizes

## Testing

The app includes:
- Sample data for immediate testing
- Demo user accounts
- Mock product catalog
- Sample blog posts and videos

## Future Enhancements

- Firebase integration for real-time data
- Payment gateway integration
- Push notifications
- Offline mode improvements
- Advanced search and filtering
- Social features and sharing

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is developed for educational purposes as part of the Aptech Limited curriculum.

## Support

For support or questions, please contact the development team.

---

**Note**: This is a demo application with sample data. In a production environment, proper backend integration, security measures, and data validation would be implemented.
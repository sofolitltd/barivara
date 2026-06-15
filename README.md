# Barivara

Property management platform for landlords — manage units, renters, billing, invoices, and marketplace listings.

## Features

- **Property & Unit Management** — Add/edit properties and units with rent config, deposit tracking, and status (vacant/occupied/owner)
- **Renter Management** — Track renters with profile info, documents, family members, move-in/move-out dates, and history
- **Billing & Invoicing** — Generate monthly bills with rent + utility charges, record payments per line item, auto-computed statuses (paid/unpaid/due)
- **Invoice Sharing** — Share invoices via share sheet or public read-only invoice link
- **Marketplace** — Post vacant units to a public landing page for prospective tenants
- **Dashboard** — Overview widgets: stats, quick actions, recent activity, revenue chart
- **Admin Panel** — Approve/reject landlord verification requests
- **Firebase Auth** — Email/password authentication with role-based access
- **Dark Mode** — Full dark theme support
- **Responsive Layout** — Optimized for mobile, tablet, and desktop

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.10+ (Dart 3) |
| State Management | Riverpod (with code generation) |
| Routing | go_router |
| Backend | Firebase (Firestore, Auth, Hosting) |
| Serialization | Freezed + json_serializable |
| PDF | pdf + printing |
| Charts | fl_chart |
| Icons | Material Icons, Cupertino Icons |

## Project Structure

```
lib/
├── features/
│   ├── admin/            # Admin panel, verification requests
│   ├── auth/             # Login, profile, providers
│   ├── billing/          # Invoices, payments, PDF generation
│   ├── dashboard/        # Home page, widgets, stats
│   ├── landing/          # Public marketplace, listings
│   ├── onboarding/       # Landlord request flow
│   ├── property/         # Properties, units, unit details
│   └── renters/          # Renter CRUD, history, documents
├── shared/
│   ├── constants/        # App-wide constants
│   ├── providers/        # Global Riverpod providers
│   ├── services/         # Cloudinary, etc.
│   ├── theme/            # App theme (light + dark)
│   └── widgets/          # Shared UI components
├── firebase_options.dart # Firebase config (gitignored)
├── main.dart             # Entry point
└── router.dart           # Route definitions
```

## Getting Started

### Prerequisites

- Flutter SDK ^3.10
- Firebase project (Firestore, Auth, Hosting)
- A `.env` file in the project root with:

```
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
CLOUDINARY_UPLOAD_PRESET=your_upload_preset
```

### Setup

```sh
# Clone the repo
git clone https://github.com/sofolitltd/barivara.git
cd barivara

# Install dependencies
flutter pub get

# Generate Freezed/JSON models
flutter pub run build_runner build

# Run in development
flutter run -d chrome
```

### Firebase Setup

1. Create a Firebase project
2. Enable **Authentication** (Email/Password)
3. Enable **Cloud Firestore**
4. Register a web app and copy `firebase_options.dart` to `lib/`
5. For hosting: `firebase init hosting` (public dir: `build/web`)

## Available Commands

| Command | Description |
|---------|-------------|
| `flutter pub get` | Install dependencies |
| `flutter pub run build_runner build` | Generate models |
| `flutter pub run build_runner watch` | Auto-generate on changes |
| `flutter analyze` | Run static analysis |
| `flutter build web --wasm` | Build for production (WASM) |
| `firebase deploy --only hosting` | Deploy to Firebase |

## Deployment

```sh
flutter build web --wasm
firebase deploy --only hosting
```

The site deploys to **barivarabd.web.app** with WASM compilation enabled. Rewrites route all paths to `index.html` for SPA support.

## License

Private — all rights reserved.

# Follio — Personal Portfolio & Admin Console in Flutter

A production-grade, dual-flavor web application built natively with Flutter, recreating the modern aesthetic, layout, spacing, typography scale, and interaction feel of the [Folio Tailwind design reference](https://themewagon.github.io/folio-tailwind/).

Shipped from a **single codebase without code bifurcation**, Follio builds two specialized application targets using **Flutter Flavors**:
1. **Public Portfolio Site (`user` flavor)**: A dynamic, high-performance portfolio featuring smooth anchor navigation, case studies, blog reader with scroll-driven progress bar, and an EmailJS contact integration.
2. **Folio Admin Console (`admin` flavor)**: A professional, dark/light theme back-office panel for managing inquiries, tracking site visits, and uploading resumes (PDF/Word) to dynamically update live portfolio content with version rollback.

---

## 🎯 Project Types & Roles Details

| Dimension | Public Portfolio (`user` flavor) | Admin Console (`admin` flavor) |
|---|---|---|
| **Target Audience / Role** | Public visitors, potential clients, engineering recruiters | Site Owner / Portfolio Administrator |
| **Default Route** | `/` (Home Showcase) | `/admin/login` (Guarded Console Auth) |
| **Authentication** | None (public access) | SHA-256 hashed credentials + Web Cookie / Secure Storage session |
| **Route Access** | Public portfolio routes only (`/`, `/projects`, `/blog`, etc.). Access to `/admin/*` yields hard `404`. | Admin routes only (`/admin/*`). Access to public routes is shielded and redirected to `/admin/login`. |
| **Key Operations** | View projects, read case studies & articles, submit inquiries (writes to admin store). | Review analytics, filter/read/delete messages, upload resumes, edit & publish dynamic profile drafts. |

---

## 📸 Key Features

### 1. Public Portfolio Site (`user` flavor)
- **Sticky Glassmorphic Navigation**: Frosted glass blur (`sigma: 12.0`), scroll-spy active section indicators, and mobile drawer overlay under 900px.
- **Hero Section**: "Available for work" glowing badge, animated stat counters (Projects Done, Happy Clients, Experience), dual CTAs.
- **Services Showcase**: Interactive service cards with hover lift, border glow, and auto-filling contact section links.
- **Selected Work**: Featured project case study with conversion stats, compact cards, and category filter grid (`/projects`).
- **Dynamic Profile & About**: Biography, design philosophy, and stack badges populated dynamically from the content repository.
- **Testimonials**: Authentic feedback cards with star ratings and client metadata.
- **Blog & Long-form Articles**:
  - Full archive at `/blog` with category filtering.
  - Deep-linked articles at `/blog/:slug` featuring a **scroll-driven top reading progress bar**, author details, Twitter/LinkedIn social sharing, and a **"More from the blog"** related articles grid.
- **Live Contact Form**:
  - REST client for EmailJS with automatic fallback simulation in offline/demo modes.
  - Honeypot anti-spam bot trap.
  - Client-side rate limiting (60s cooldown).
  - Automatically writes submissions to the Admin Messages store for console review.
- **Visitor Tracking**: Lightweight `AnalyticsService` increments visitor counts on page load for the admin dashboard.

### 2. Admin Console (`admin` flavor)
- **Guarded Authentication**:
  - Clean MVVM via `AdminAuthViewModel`, zero `setState`, and password visibility toggle.
  - SHA-256 build-time credential verification (defaults to username `"Madhavan"` and password `"220701"`).
  - Web cookie session persistence (`Secure; SameSite=Strict; Path=/`) with platform fallback to `flutter_secure_storage` on mobile/desktop.
  - `AuthGuard` router protection: missing or expired sessions redirect immediately to `/admin/login`.
- **Admin Dashboard**:
  - Live metric cards: "Messages Received" and "Site Visitors" with weekly trend indicators.
  - Skeleton shimmer loading states during data retrieval.
  - Recent activity feed showing latest submissions with read status dots and quick-navigation links.
  - Quick action CTA button navigating directly to Folio Profile Update.
- **Received Messages Screen**:
  - Paginated inbox of contact form inquiries.
  - Filter by unread status, search by name, email, or subject keywords, and filter by date range.
  - Detail dialog with direct `mailto:` action, toggle read/unread status, and message deletion with confirmation.
- **Folio Profile Update Screen**:
  - **User Image & Avatar Upload**: Cross-platform image picker supporting PNG, JPG, JPEG, WEBP, and GIF up to 5MB (encoded as client-side base64 data URLs), or direct external image URL input.
  - Live photo preview with "Custom" badge, instant update, and one-click "Reset to Default" portrait option.
  - Cross-platform resume document picker accepting PDF and Word (`.doc`, `.docx`) up to 10MB.
  - In-memory document text extraction and structured parsing into an editable `ProfileDraft` (name, role, bios, skills, projects, avatar).
  - Built-in XSS input sanitizer stripping dangerous HTML, script, and style tags.
  - "Publish" commits to the remote/in-memory store, immediately invalidating public cache so changes reflect instantly across `HeroSection` and `AboutSection`.
  - 5-version historical log with one-click **"Revert to this version"** action.
- **Responsive Admin Shell**:
  - Collapsible desktop sidebar with brand header, theme toggle, and sign-out action.
  - Mobile bottom navigation bar for compact screens.

---

## 🏛 Architecture & Code Standards

- **State Management (Provider MVVM)**:
  - Strict separation of concerns: Views observe ViewModels (`ChangeNotifier`) using `context.watch()` or `context.select()`.
  - **Zero `setState`** used for business logic or admin flows.
- **Dependency Injection**:
  - Layered multi-provider structure in `lib/di/`:
    - `core_providers.dart`: Shared instances (`ThemeRepository`, `AuthStorage`).
    - `user_providers.dart`: Public site dependencies (`PortfolioRepository`, `ContactRepository`, `AnalyticsService`).
    - `admin_providers.dart`: Admin console dependencies (`AuthRepository`, `MessagesRepository`, `AnalyticsRepository`, `ProfileContentRepository`).
    - `app_providers.dart`: Root widget injecting providers based on active `FlavorConfig`.
- **Theme & Design Tokens**:
  - Custom Material 3 theme extension `PortfolioColors` paired with `DesignTokens`.
  - Zero hardcoded colors or ad-hoc style values; full light and dark mode support across public and admin interfaces.
- **Routing & Guards**:
  - Declarative routing using `GoRouter` with `ShellRoute` for the admin back-office.
  - `AuthGuard` enforces strict flavor isolation (User flavor cannot reach `/admin/*`, Admin flavor cannot reach public routes).

---

## 📁 Project Structure

```
follio/
├── .env.example                                      # Environment variables & run command templates
├── firestore.rules                                   # Firestore security rules with isAdmin() check
├── lib/
│   ├── main.dart                                     # Default entry point (boots user flavor)
│   ├── main_user.dart                                # User flavor entry point
│   ├── main_admin.dart                               # Admin flavor entry point
│   ├── app.dart                                      # MaterialApp configuration with Theme & Router
│   ├── core/
│   │   ├── bootstrap.dart                            # Shared app bootstrap & error boundaries
│   │   ├── flavor_config.dart                        # Flavor enum (user | admin) & configuration singleton
│   │   ├── auth/                                     # Auth storage abstractions & Web/Native implementations
│   │   │   ├── auth_session.dart
│   │   │   ├── auth_storage.dart
│   │   │   ├── auth_storage_web.dart
│   │   │   └── secure_auth_storage.dart
│   │   ├── router/
│   │   │   ├── app_router.dart                       # Route table & deep-link configurations
│   │   │   └── auth_guard.dart                       # Flavor & authentication route redirect logic
│   │   ├── services/
│   │   │   └── analytics_service.dart                # Public visitor tracking service
│   │   ├── theme/                                    # AppTheme & PortfolioColors ThemeExtension
│   │   └── tokens/                                   # Spacing, radius, duration & typography design tokens
│   ├── data/
│   │   ├── datasources/                              # Remote, local, and Firestore data sources
│   │   │   ├── admin_auth_data_source.dart
│   │   │   ├── admin_firestore_data_source.dart
│   │   │   ├── contact_remote_data_source.dart
│   │   │   ├── portfolio_local_data_source.dart
│   │   │   └── preferences_local_data_source.dart
│   │   ├── models/                                   # Domain data models & DTOs
│   │   └── repositories/                             # Repository implementations with caching & Result<T>
│   ├── domain/
│   │   └── repositories/                             # Abstract repository interfaces
│   ├── di/                                           # Dependency injection trees per flavor
│   │   ├── app_providers.dart
│   │   ├── core_providers.dart
│   │   ├── user_providers.dart
│   │   └── admin_providers.dart
│   └── presentation/
│       ├── admin/                                    # Admin-only presentation layer
│       │   ├── viewmodels/                           # Admin ViewModels (Auth, Dashboard, Messages, Profile)
│       │   └── views/                                # Admin screens (Login, Dashboard, Messages, Profile, Shell)
│       ├── viewmodels/                               # Public site ViewModels (Portfolio, Contact)
│       ├── views/                                    # Public views (Home, Projects, Case Study, Blog, Article, 404)
│       └── widgets/                                  # Common UI components & sections
└── test/
    ├── core/router/auth_guard_test.dart              # Route guard redirect tests
    ├── data/                                         # Repository unit tests
    ├── helpers/                                      # Mock repositories and pump helpers
    ├── viewmodels/                                   # ViewModel unit tests (User & Admin)
    └── widgets/                                      # Widget tests (Public sections & Admin screens)
```

---

## 🚀 How to Run & Build

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.19+ (tested on Flutter 3.41 / Dart 3.11)
- Google Chrome (or any standard browser for Web targets)

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run Public Portfolio Site (`user` flavor)
Launches the public site landing at `/`:
```bash
flutter run -d chrome -t lib/main_user.dart --dart-define=FLAVOR=user
```

### 3. Run Admin Console (`admin` flavor)
Launches the administrative console landing at `/admin/login`:
```bash
flutter run -d chrome -t lib/main_admin.dart \
  --dart-define=FLAVOR=admin \
  --dart-define=ADMIN_USERNAME_HASH=642ed0bca90e038e74de2e45265ead2b5b700642e8a7e9ea02755792c88d73ee \
  --dart-define=ADMIN_PASSWORD_HASH=38d5b2f7cb22e50d72ae183641e1e16bfd666f15f9c5dbfc9d600658ad1110fd
```

> **Default Admin Credentials**:
> - **Username**: `Madhavan`
> - **Password**: `220701`
>
> *(Hashes are computed at build time and compared securely; credentials are never committed in plaintext).*

### 4. Running with Optional Cloud Firestore & EmailJS
You can pass your live backend credentials using `--dart-define` or create a `.env` file from `.env.example`:
```bash
flutter run -d chrome -t lib/main_admin.dart \
  --dart-define=FLAVOR=admin \
  --dart-define=FIRESTORE_PROJECT_ID=your-gcp-project-id \
  --dart-define=EMAILJS_SERVICE_ID=service_xxx \
  --dart-define=EMAILJS_TEMPLATE_ID=template_xxx \
  --dart-define=EMAILJS_PUBLIC_KEY=user_xxx
```
*(If omitted, the application automatically runs against resilient in-memory stores and mock transport).*

### 5. Production Web Builds
Build separate release artifacts for each flavor with dedicated base-href paths:

```bash
# Public Portfolio Build -> build/web-user
flutter build web -t lib/main_user.dart \
  --dart-define=FLAVOR=user \
  --base-href=/ \
  --output=build/web-user

# Admin Console Build -> build/web-admin
flutter build web -t lib/main_admin.dart \
  --dart-define=FLAVOR=admin \
  --base-href=/admin/ \
  --output=build/web-admin
```

---

## 🧪 Testing & Verification

The codebase includes an exhaustive test suite of **94 automated unit and widget tests** covering all viewmodels, repositories, security guards, and UI components.

### Run Static Analysis
Verifies zero lint warnings or errors with strict casting enabled:
```bash
flutter analyze
```

### Run Automated Tests
```bash
flutter test
```

### Test Suite Highlights
- **AuthGuard Suite** (`test/core/router/auth_guard_test.dart`): Verifies cross-flavor barriers, session expiration checks, and login redirects.
- **Admin ViewModel Suites** (`test/viewmodels/admin_*_test.dart`): Validates credential hashing, inbox pagination and deletion, XSS sanitization, and resume text extraction.
- **Admin Widget Suites** (`test/widgets/admin_*_test.dart`): Verifies login form validation, desktop/mobile responsive navigation, and dashboard skeleton loading states.
- **Public Portfolio Suites** (`test/widgets/*`, `test/data/*`, `test/viewmodels/*`): Verifies all 9 public sections, article reader, contact form honeypot, and rate-limiting.

---

## 🔒 Security Specifications & Backend Migration

### Current Architecture
1. **No Plaintext Secrets**: Admin credentials are verified by comparing the SHA-256 hash of the input against build-time defines.
2. **Session Persistence**: Session tokens on Web use browser cookies set with `Secure; SameSite=Strict; Path=/` and short expirations, while native targets utilize the OS Keychain / Keystore via `flutter_secure_storage`.
3. **Firestore Security Rules**: The included `firestore.rules` file restricts message reads, updates, analytics reports, and profile writes to authenticated admin sessions (`request.auth.token.admin == true`).

### Migrating to Firebase Auth Custom Claims
To replace the static SHA-256 check with live Firebase Authentication:
1. Update `lib/data/datasources/admin_auth_data_source.dart`:
   - Replace the static hash check with `FirebaseAuth.instance.signInWithEmailAndPassword(email, password)`.
   - Call `final idTokenResult = await user.getIdTokenResult(true);`.
   - Verify `idTokenResult.claims?['admin'] == true` (minted server-side using the Firebase Admin SDK).
   - Return an `AuthSession` with the ID token and its expiry.
2. No changes are required in `AuthRepository`, `AuthGuard`, `AdminAuthViewModel`, or any of the presentation views.

---

## 📄 License & Attribution

- Design inspiration and aesthetic based on the open-source **Folio Tailwind** portfolio template by [Laurent Begey](https://themewagon.com/) distributed by [ThemeWagon](https://themewagon.com/).
- Re-architected and engineered natively in Flutter with dual-flavor support by Eliott.

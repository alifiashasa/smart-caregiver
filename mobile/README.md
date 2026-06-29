# Smart Caregiver Mobile

Flutter application untuk caregiver dalam memonitor dan merawat lansia.

## Tech Stack

- **Framework**: Flutter 3.9+ / Dart 3.9+
- **State Management, Routing, DI**: GetX
- **Global Dependency Binding**: `InitialBinding`
- **HTTP Client**: Dio
- **Secure Token Storage**: `flutter_secure_storage`
- **Local Cache / Preferences**: GetStorage
- **Environment Config**: `flutter_dotenv` + `--dart-define`
- **Push Notification**: Firebase Messaging + Flutter Local Notifications
- **Charts**: `fl_chart`
- **Images**: `cached_network_image`, `image_picker`
- **Typography**: Google Fonts
- **Testing**: `flutter_test` + `mocktail`
- **UI**: Material Design + centralized `AppTheme`
- **Validation**: reusable `AppValidators`
- **Feedback UI**: reusable `AppFeedback`

## Fitur App

| Module | Deskripsi |
|--------|-----------|
| Splash | Initialisasi app, session check |
| Login/Register | Auth caregiver |
| Home | Dashboard utama caregiver |
| Dashboard Lansia | Ringkasan kondisi lansia |
| Calendar/Jadwal | Jadwal aktivitas, obat, checkup |
| Log Kesehatan | Input dan riwayat data kesehatan |
| Profil Lansia | Detail profil lansia |
| Notifikasi | Push/in-app notification |
| Rekomendasi AI | Rekomendasi aktivitas dari backend |
| Face Register/Verify | Verifikasi wajah |

## Struktur Arsitektur

Project tetap memakai GetX sesuai requirement, tapi dependency global dipusatkan agar lebih maintainable.

```text
lib/
├── main.dart
└── app/
    ├── bindings/
    │   └── initial_binding.dart      # Repository/global dependency
    ├── core/
    │   ├── api_result.dart           # Typed success/failure result wrapper
    │   ├── config.dart               # API_BASE_URL/env config
    │   ├── fcm_service.dart          # Push notification service
    │   ├── logger.dart
    │   ├── theme/                    # Centralized app theme
    │   ├── ui/                       # Feedback/snackbar helpers
    │   └── validators/               # Reusable form validation
    ├── data/
    │   ├── api_client.dart           # Dio client + token refresh
    │   ├── *_api.dart                # Remote data source
    │   ├── models/                   # Typed response models
    │   └── repositories/             # Repository layer
    ├── modules/
    │   └── <feature>/
    │       ├── bindings/
    │       ├── controllers/
    │       └── views/
    └── routes/
        ├── app_pages.dart
        └── app_routes.dart
```

## GetX Pattern

Setiap module terdiri dari:

- `bindings/` — mendaftarkan controller feature
- `controllers/` — state, UI logic, orkestrasi repository
- `views/` — widget/screen

Repository global didaftarkan sekali di:

```text
lib/app/bindings/initial_binding.dart
```

Lalu dipakai via:

```dart
Get.find<AuthRepository>()
```

## API & Auth

- API base URL dibaca dari `--dart-define=API_BASE_URL`, lalu fallback ke `assets/.env`, lalu fallback platform.
- Access token dan refresh token disimpan di `flutter_secure_storage`.
- GetStorage hanya dipakai untuk cache/preference non-sensitif.
- `ApiClient` menggunakan Dio dengan timeout global, debug logging, auth interceptor, dan token refresh retry.
- Repository baru mulai mengembalikan typed `ApiResult<T>` untuk flow yang sudah dimigrasikan.
- Dashboard, schedule, notification, elderly profile, health record, user, dan AI recommendation sudah memiliki typed model.

## Konfigurasi API Base URL

```bash
# Development default
flutter run

# Development device fisik
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:8000

# Staging
flutter run --dart-define=API_BASE_URL=https://api.staging.smartcaregiver.com

# Production
flutter build apk --dart-define=API_BASE_URL=https://api.smartcaregiver.com
```

Fallback default:

- Android emulator: `http://10.0.2.2:8000`
- Platform lain: `http://localhost:8000`

## Quick Start

### Prerequisites

- Flutter SDK 3.9+
- Dart 3.9+

### Install dependencies

```bash
cd mobile
flutter pub get
```

### Run app

```bash
flutter run
```

### Analyze & test

```bash
flutter analyze
flutter test
```

### Build APK

```
```

## 📂 Struktur Folder

```
lib/
├── main.dart                    # Entry point
└── app/
    ├── routes/
    │   ├── app_routes.dart      # Route definitions
    │   └── app_pages.dart       # Page configurations
    └── modules/
        ├── splash/
        │   ├── controllers/
        │   ├── views/
        │   └── bindings/
        ├── home/
        │   ├── controllers/
        │   ├── views/
        │   └── bindings/
        └── patient_detail/
            ├── controllers/
            ├── views/
            └── bindings/
```

## 📝 Catatan

App ini merupakan capstone project yang menggunakan **mock data lokal** untuk seluruh fitur.
Tidak ada service API layer yang terintegrasi — semua data dummy sudah disediakan di masing-masing controller.

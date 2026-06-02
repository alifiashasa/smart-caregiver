# Smart Caregiver Mobile

Flutter application untuk caregiver dalam memonitor dan merawat lansia.

## Tech Stack

- **Framework**: Flutter 3.9+
- **State Management**: GetX
- **Local Storage**: GetStorage
- **Typography**: Google Fonts
- **UI**: Material Design

## Fitur App

| Module | Deskripsi |
|--------|-----------|
| Splash | Initialisasi app, loading screen |
| Home | Dashboard utama untuk caregiver |
| Patient Detail | Detail informasi & data lansia |

## Struktur GetX Pattern

Setiap module terdiri dari:
- `controllers/` - Logic & state management
- `views/` - UI screens
- `bindings/` - Dependency injection

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.9+
- Dart 3.9+

### Instalasi
```bash
cd mobile
flutter pub get
```

### Menjalankan App
```bash
flutter run
```

Untuk mode development dengan hot reload:
```bash
flutter run -d <device_id>
```

> **Override API Base URL** — gunakan `--dart-define`:
> ```bash
> flutter run --dart-define=API_BASE_URL=http://192.168.1.100:8000
> flutter run -d <device_id> --dart-define=API_BASE_URL=https://api.staging.smartcaregiver.com
> ```
> Nilai ini digunakan saat kompilasi. Jika tidak diset, fallback ke:
> - **Android emulator**: `http://10.0.2.2:8000`
> - **Lainnya** (iOS sim, web, real device): `http://localhost:8000`

### Build APK
```bash
flutter build apk --debug
# atau
flutter build apk --release
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

## Konfigurasi

API base URL dibaca dari compile-time constant `API_BASE_URL` via `--dart-define`.

```bash
# Development (default)
flutter run

# Staging
flutter run --dart-define=API_BASE_URL=https://api.staging.smartcaregiver.com

# Production
flutter build apk --dart-define=API_BASE_URL=https://api.smartcaregiver.com
```

Lihat `lib/app/core/config.dart` untuk detail fallback per platform.
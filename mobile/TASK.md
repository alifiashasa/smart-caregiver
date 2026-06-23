# Mobile App — Daftar Tindakan yang Perlu Diselesaikan

Hasil deep-dive review terhadap seluruh kode Flutter di `mobile/lib/`. Ditemukan beberapa area yang masih berupa **dummy**, **belum diimplementasikan**, atau memiliki **bug sintaks**.

---

## 1. ❌ Bug Sintaks: `?variableName` (Compilation Error)

**Lokasi:** 5 file API service — seluruh `lib/app/data/`

**Masalah:** Penggunaan `?variableName` sebagai _value_ di dalam map body request.
Ini **bukan sintaks Dart yang valid** dan akan menyebabkan **compilation error**.

Contoh di `elderly_api.dart`:
```dart
body: {
  'gender': ?gender,         // ❌ syntax error
  'photo_url': ?photoUrl,   // ❌ syntax error
  ...
},
```

Sebaran file & jumlah kemunculan:

| File | Jumlah |
|------|--------|
| `lib/app/data/elderly_api.dart` | 9 |
| `lib/app/data/health_api.dart` | 10 |
| `lib/app/data/schedule_api.dart` | 3 |
| `lib/app/data/ai_api.dart` | 1 |
| `lib/app/data/notification_api.dart` | 3 |

**Perbaikan:** Gunakan collection-if Dart:
```dart
body: {
  'full_name': fullName,
  'age': age,
  if (gender != null) 'gender': gender,
  if (photoUrl != null) 'photo_url': photoUrl,
  ...
}
```

---

## 2. 🕳️ Action Dummy — "Edit Profil" Caregiver

**Lokasi:** `lib/app/modules/profil-caregiver/views/profil_caregiver_view.dart:132`

**Isi kode:**
```dart
_buildMenuItem(
  icon: Icons.edit_outlined,
  text: 'Edit Profil',
  subtitle: 'Perbarui informasi caregiver',
  onTap: () {},  // <-- empty handler
),
```

**Akibat:** Tombol "Edit Profil" di halaman profil caregiver bisa ditekan tetapi **tidak melakukan apa-apa**. Tidak ada navigasi, snackbar, atau aksi apapun.

**Perbaikan:** Implementasikan navigasi ke halaman edit profil (atau hubungkan ke route `EDIT_PROFILE` yang sudah didefinisikan).

---

## 3. 🗺️ Route Didefinisikan Tapi Tidak Terdaftar — `EDIT_PROFILE`

**Lokasi:** `lib/app/routes/app_routes.dart:16`

`EDIT_PROFILE` didefinisikan sebagai konstanta route (`/edit-profile`) tetapi **tidak pernah didaftarkan** di `AppPages.routes` di `app_pages.dart`. Tidak ada module, binding, atau page yang terkait.

**Akibat:** Route ini tidak bisa digunakan meskipun konstanta-nya sudah ada.

**Perbaikan:** Hapus konstanta jika tidak diperlukan, atau buat module untuk edit profil caregiver dan daftarkan route-nya.

---

## 4. 🕳️ Fitur Tidak Terimplementasi — Pencarian & Filter Pasien

**Lokasi:** `lib/app/modules/home/views/home_view.dart:343-380`

**Masalah:** UI elemen "search" berupa dekorasi statis — hanya `Row` berisi ikon search + teks "Cari pasien berdasarkan nama" + ikon filter. **Bukan `TextField`**, tidak ada input, tidak ada fungsi filter.

```dart
Widget _buildSearchSurface(BuildContext ctx) {
  return Semantics(
    child: Container(
      child: Row(
        children: [
          Icon(Icons.search_rounded),
          Text('Cari pasien berdasarkan nama'),
          Icon(Icons.tune_rounded),   // ikon filter (dekorasi saja)
        ],
      ),
    ),
  );
}
```

**Akibat:** Search bar dan filter hanya hiasan — pengguna tidak bisa mencari pasien.

**Perbaikan:** Implementasikan `TextField` dengan fungsi filter pada `elderlyList` di `HomeController`.

---

## 5. 🕳️ Fitur API Tidak Terhubung — Notification Preferences

**Lokasi:** `lib/app/data/notification_api.dart:77-107`

**Masalah:** Method `getPreferences()` dan `updatePreference()` sudah didefinisikan di `NotificationApi`, tetapi:
- Tidak ada repository wrapper (tidak di-export dari `NotificationRepository`)
- Tidak ada controller atau view yang menggunakannya
- Tidak ada UI untuk mengatur preferensi notifikasi

**Akibat:** API endpoint `/notification-preferences` dan `/notification-preferences` tidak pernah dipanggil dari mobile.

**Perbaikan:** Buat UI pengaturan notifikasi (toggle per jenis notifikasi) dan hubungkan ke repository.

---

## 6. 🎨 Inkonsistensi Kode — `detail_history_view.dart`

**Lokasi:** `lib/app/modules/detail-history/views/detail_history_view.dart` (1051 baris)

**Masalah:** View ini memiliki gaya kode yang sangat berbeda dari view lainnya:
- Menggunakan `const TextStyle(...)` inline dengan font hardcoded `'Plus Jakarta Sans'` secara eksplisit
- Menggunakan `Color(0xFF...)` langsung secara inline, bukan dari `AppTheme`
- Layout menggunakan `SizedBox`, `ConstrainedBox`, dan `Container` dengan penulisan yang sangat verbose
- Tidak konsisten dengan sistem tema yang digunakan di view lainnya (`AppTheme`, `Theme.of(context).textTheme`)

**Kemungkinan:** File ini kemungkinan merupakan hasil generate Figma-to-code atau AI coding yang belum di-refactor untuk menggunakan tema aplikasi.

**Perbaikan:** Refactor untuk menggunakan `AppTheme` dan `Theme.of(context).textTheme` seperti view lainnya.

---

## 7. 🎯 Data Default Keras — Nama Pasien Fallback

**Lokasi:**
- `lib/app/modules/dashboard/controllers/dashboard_controller.dart:17` → `'Ibu Siti'`
- `lib/app/modules/profil-lansia/controllers/profil_lansia_controller.dart:48` → `'Ibu Siti'`
- `lib/app/modules/patient_detail/controllers/patient_detail_controller.dart:110` → `'Budi Santoso'`

**Masalah:** Nilai fallback `'Ibu Siti'` dan `'Budi Santoso'` digunakan sebagai default ketika data dari API belum tersedia. Ini bukan bug kritis, tetapi dapat menyebabkan kebingungan saat pertama kali render sebelum data pasien termuat.

**Perbaikan:** Gunakan string kosong atau state loading yang lebih jelas alih-alih nama pasien spesifik.

---

## Ringkasan Prioritas

| Prioritas | Issue | Dampak |
|-----------|-------|--------|
| 🔴 Critical | #1 — `?variableName` syntax error | **Compilation error**, app tidak bisa di-build |
| 🟡 High | #2 — Edit Profil dummy action | UX broken, tombol tidak berfungsi |
| 🟡 High | #4 — Search/filter pasien dummy | Fitur inti tidak berfungsi |
| 🟡 High | #3 — EDIT_PROFILE route mati | Dead code, bisa bikin bingung |
| 🟡 Medium | #5 — Notification Preferences API tidak terpakai | Fitur tidak bisa diakses user |
| 🟢 Low | #6 — Inkonsistensi styling | Maintenance burden |
| 🟢 Low | #7 — Nama fallback hardcoded | Potensi confusion di UI |

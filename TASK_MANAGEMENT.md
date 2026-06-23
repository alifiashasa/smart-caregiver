# Task Management — Smart Caregiver

Project timeline dari awal hingga publikasi Play Store.

| No | Nama Task | Deskripsi | PIC | Prioritas | Status | Tanggal Mulai | Deadline | Progress | Catatan |
|---|---|---|---|---|---|---|---|---|---|
| | **Fase 1: Backend Foundation** | | | | | | | | |
| 1 | Setup proyek backend & database | Inisialisasi FastAPI, PostgreSQL (Neon), SQLAlchemy, Alembic migrations | Wahyu | 🔴 Critical | ✅ Done | 2026-05-09 | 2026-05-20 | 100% | Struktur ada di `server/` |
| 2 | Auth: register & login | Endpoint register (email + password), login, refresh token, OTP email verifikasi | Wahyu | 🔴 Critical | ✅ Done | 2026-05-15 | 2026-05-25 | 100% | JWT-based |
| 3 | Auth: face recognition | Registrasi wajah & verifikasi wajah via InsightFace | Wahyu | 🔴 Critical | ✅ Done | 2026-05-20 | 2026-06-01 | 100% | Endpoint face register/verify |
| 4 | Manajemen profil lansia | CRUD profil lansia (nama, usia, riwayat penyakit, mobilitas, minat) | Shasa | 🔴 Critical | ✅ Done | 2026-05-20 | 2026-06-01 | 100% | Gate owner-access |
| | **Fase 2: Backend Core Features** | | | | | | | | |
| 5 | Pencatatan kesehatan harian | CRUD health record (tekanan darah, gula darah, detak jantung, suhu, berat badan) + trigger notifikasi | Wahyu | 🔴 Critical | ✅ Done | 2026-05-25 | 2026-06-05 | 100% | Auto fuzzy analysis |
| 6 | Fuzzy analysis engine | 3 engine fuzzy (kardiovaskular, metabolik, infeksi) jalan otomatis setelah health record dibuat | Wahyu | 🟡 High | ✅ Done | 2026-05-25 | 2026-06-05 | 100% | Thread-pool executor |
| 7 | Dashboard & tren kesehatan | Overview semua lansia, grafik tren 7/30 hari, riwayat kesehatan lengkap | Shasa | 🟡 High | ✅ Done | 2026-06-01 | 2026-06-10 | 100% | REQ-008,009,010 |
| 8 | Jadwal & alarm pengingat | CRUD jadwal per lansia + alarm reminder otomatis | Shasa | 🟡 High | ✅ Done | 2026-06-01 | 2026-06-10 | 100% | REQ-013,014,015 |
| 9 | Rekomendasi aktivitas AI | Generate + approve/reject rekomendasi via Groq LLM, approve → auto-create jadwal | Wahyu | 🟡 High | ✅ Done | 2026-06-05 | 2026-06-15 | 100% | REQ-016,017,018 |
| 10 | Notifikasi in-app | Notifikasi + preferensi, trigger dari health record & alarm | Shasa | 🟡 High | ✅ Done | 2026-06-01 | 2026-06-10 | 100% | REQ-019,020 |
| 11 | Weekly summary | Ringkasan mingguan otomatis via internal job | Shasa | 🟢 Low | ✅ Done | 2026-06-05 | 2026-06-15 | 100% | REQ-021 |
| 12 | Admin panel backend | Endpoint admin: manajemen caregiver, announcement broadcast, operasional dashboard | Wahyu | 🟡 Medium | ✅ Done | 2026-06-10 | 2026-06-20 | 100% | Ada di `admin.py` router |
| 13 | FCM push notification | Integrasi Firebase Cloud Messaging untuk push notification ke mobile | Shasa | 🟡 Medium | ✅ Done | 2026-06-10 | 2026-06-22 | 100% | Device token + FCM |
| 14 | APScheduler otomatis | Ganti manual job ke scheduler terjadwal untuk alarm & weekly summary | Wahyu | 🟢 Low | ✅ Done | 2026-06-20 | 2026-06-23 | 100% | Di `scheduler.py` |
| | **Fase 3: Mobile App — Flutter** | | | | | | | | |
| 15 | Setup proyek Flutter | Inisialisasi Flutter, GetX, GetStorage, Firebase, routing, tema | Wahyu | 🔴 Critical | ✅ Done | 2026-05-15 | 2026-06-01 | 100% | Struktur di `mobile/` |
| 16 | Halaman splash & onboarding | Splash screen + face registration/verification flow | Shasa | 🔴 Critical | ✅ Done | 2026-05-20 | 2026-06-05 | 100% | |
| 17 | Auth: login & register screens | Halaman register, login, face verify | Shasa | 🔴 Critical | ✅ Done | 2026-05-25 | 2026-06-05 | 100% | |
| 18 | Dashboard & home | List profil lansia, ringkasan status, search & filter | Shasa | 🔴 Critical | ✅ Done | 2026-06-01 | 2026-06-15 | 100% | Search masih dummy task #29 |
| 19 | Detail lansia & pencatatan kesehatan | Halaman detail lansia, form catat kesehatan harian | Shasa | 🔴 Critical | ✅ Done | 2026-06-01 | 2026-06-15 | 100% | |
| 20 | Grafik tren kesehatan | Line chart per parameter (7/30 hari) | Shasa | 🟡 High | ✅ Done | 2026-06-05 | 2026-06-15 | 100% | |
| 21 | Riwayat kesehatan & detail history | List riwayat + detail komplit record kesehatan | Shasa | 🟡 High | ✅ Done | 2026-06-05 | 2026-06-15 | 100% | Refactor styling task #26 |
| 22 | Manajemen jadwal | CRUD jadwal per lansia + tampilan list & calendar | Shasa | 🟡 High | ✅ Done | 2026-06-10 | 2026-06-20 | 100% | |
| 23 | Rekomendasi AI | List rekomendasi, approve → jadwal, reject | Shasa | 🟡 High | ✅ Done | 2026-06-10 | 2026-06-20 | 100% | |
| 24 | Notifikasi | List notifikasi, read/unread, preferensi | Shasa | 🟡 High | ✅ Done | 2026-06-10 | 2026-06-20 | 100% | |
| 25 | **Fix compilation error `?variableName`** | Perbaiki sintaks Dart di 5 file API service | Wahyu | 🔴 Critical | 🟡 In Progress | 2026-06-23 | 2026-06-25 | 0% | Blocker build |
| 26 | **Refactor `detail_history_view.dart`** | Ganti inline style ke AppTheme (1051 baris) | Shasa | 🟢 Low | ⬜ Pending | - | 2026-07-07 | 0% | Hasil Figma-to-code |
| 27 | **Implementasi Edit Profil Caregiver** | Handler onTap kosong di profil caregiver | Shasa | 🟡 High | ⬜ Pending | - | 2026-06-27 | 0% | |
| 28 | **Edit Profile route** | Daftarkan route EDIT_PROFILE di AppPages | Shasa | 🟡 High | ⬜ Pending | - | 2026-06-27 | 0% | |
| 29 | **Search & filter pasien** | Ubah dekorasi statis ke TextField + controller filter | Shasa | 🟡 High | ⬜ Pending | - | 2026-06-30 | 0% | |
| 30 | **Hubungkan Notification Preferences** | UI toggle notifikasi dari API yang sudah ada | Shasa | 🟡 Medium | ⬜ Pending | - | 2026-07-04 | 0% | |
| 31 | **Hapus fallback nama hardcoded** | Ganti 'Ibu Siti'/'Budi Santoso' dengan empty string | Shasa | 🟢 Low | ⬜ Pending | - | 2026-07-07 | 0% | |
| | **Fase 4: Web Admin** | | | | | | | | |
| 32 | Setup proyek Web Admin | React + Vite + TypeScript + shadcn/ui + Tailwind | Wahyu | 🟡 High | ✅ Done | 2026-06-10 | 2026-06-20 | 100% | |
| 33 | Halaman overview dashboard | Kartu statistik: total caregiver, elderly, dll | Shasa | 🟡 High | ✅ Done | 2026-06-15 | 2026-06-22 | 100% | |
| 34 | Manajemen caregiver | Tabel CRUD caregiver admin + toggle aktif/nonaktif | Shasa | 🟡 High | ✅ Done | 2026-06-15 | 2026-06-22 | 100% | |
| 35 | Announcement broadcast | Kirim pengumuman massal ke caregiver via FCM | Shasa | 🟡 Medium | ✅ Done | 2026-06-20 | 2026-06-23 | 100% | |
| | **Fase 5: Testing & QA** | | | | | | | | |
| 36 | Backend unit & integration tests | Tests: auth, health, fuzzy, notification, schedule, recommendation, weekly summary, FCM | Wahyu | 🟡 High | ✅ Done | 2026-05-20 | 2026-06-15 | 100% | 13 test files |
| 37 | **Perbaiki test async issues** | Beberapa test butuh async fix agar lulus semua | Wahyu | 🟡 High | ⬜ Pending | - | 2026-06-28 | 0% | |
| 38 | Mobile unit tests | Test controllers, models, API layer | Shasa | 🟡 Medium | ⬜ Pending | - | 2026-07-14 | 0% | Belum dimulai |
| 39 | E2E testing | Automation test alur lengkap (Cucumber/Playwright) | Shasa | 🟡 Medium | ⬜ Pending | - | 2026-07-21 | 0% | Sesuai BDD scenarios |
| | **Fase 6: Deployment & Publikasi** | | | | | | | | |
| 40 | Setup Docker | Dockerfile untuk server + docker-compose | Wahyu | 🟡 Medium | ⬜ Pending | - | 2026-07-18 | 0% | |
| 41 | Deploy backend (Railway/Render) | Deploy FastAPI ke production hosting | Wahyu | 🟡 High | ⬜ Pending | - | 2026-07-25 | 0% | |
| 42 | Deploy web admin (Vercel) | Build & deploy React app | Shasa | 🟡 Medium | ⬜ Pending | - | 2026-07-25 | 0% | |
| 43 | Build APK & AAB Flutter | Build signed Android release | Wahyu | 🔴 Critical | ⬜ Pending | - | 2026-08-01 | 0% | |
| 44 | Upload ke Play Store | Publikasi ke Google Play Console + testing internal track | Shasa | 🔴 Critical | ⬜ Pending | - | 2026-08-10 | 0% | Butuh akun developer |
| 45 | Dokumentasi & user manual | API docs, user guide, video demo | Shasa | 🟢 Low | ⬜ Pending | - | 2026-08-05 | 0% | |

---

**Keterangan Prioritas:**
- 🔴 Critical — Harus jalan (blocker)
- 🟡 High — Fitur inti
- 🟡 Medium — Penting tapi bisa menyusul
- 🟢 Low — Enhancement / polish

**Status:**
- ✅ Done — Selesai
- 🟡 In Progress — Sedang dikerjakan
- ⬜ Pending — Belum dimulai

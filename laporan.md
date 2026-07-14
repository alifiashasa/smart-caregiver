# Smart Caregiver: Aplikasi Pemandu Caregiver untuk Monitoring, Manajemen Jadwal, dan Rekomendasi Aktivitas Lansia Berbasis AI

Wahyu Akhmad Fadillah <sup>1</sup>, Alifia Shafa Shabrina <sup>2</sup>

<sup>1</sup> Program Studi Teknik Informatika, Fakultas Ilmu Komputer, Universitas Harapan Bangsa, Indonesia  
<sup>2</sup> Program Studi Teknik Informatika, Fakultas Ilmu Komputer, Universitas Harapan Bangsa, Indonesia  

_[wahyu.fadillah@harkatnegeri.ac.id](mailto:wahyu.fadillah@harkatnegeri.ac.id), [alifia.shafa@harkatnegeri.ac.id](mailto:alifia.shafa@harkatnegeri.ac.id)_  

---

| **Info Artikel** | | **_Abstract_ —** The increasing number of elderly individuals requiring daily care presents significant challenges for caregivers in monitoring health conditions, managing schedules, and providing personalized activity recommendations. This capstone project develops Smart Caregiver, an integrated platform consisting of a mobile application and a backend server designed to assist caregivers in monitoring and caring for elderly individuals. The mobile application, built with Flutter and GetX state management, provides features for health recording, schedule management with alarm reminders, AI-based activity recommendations, health trend visualization, and push notifications via Firebase Cloud Messaging. The backend server, built with FastAPI and PostgreSQL, implements JWT-based authentication with email OTP verification, a comprehensive REST API for elderly profile management, health records with fuzzy logic analysis for cardiovascular, metabolic, and infection risk assessment, schedule and alarm management, and AI-powered activity recommendations using the Groq LLM (qwen/qwen3-32b). The results demonstrate a fully functional platform enabling caregivers to monitor multiple elderly individuals simultaneously, with automated health analysis, timely reminders, and personalized activity suggestions to improve the quality of elderly care. |
| --- | --- | --- |
| **_Riwayat Artikel:_**<br><br>Received July 12, 2026<br><br>Revised -<br><br>Accepted - | | **_Keywords:_** **caregiver; elderly monitoring; fuzzy logic; Flutter; FastAPI** |
| **_Corresponding Author:_**<br><br>Wahyu Akhmad Fadillah<br><br>Email: [wahyu.fadillah@harkatnegeri.ac.id](mailto:wahyu.fadillah@harkatnegeri.ac.id) | | **_Abstrak —_** Meningkatnya jumlah lansia yang membutuhkan pendampingan sehari-hari menghadirkan tantangan signifikan bagi caregiver dalam memantau kondisi kesehatan, mengelola jadwal, dan memberikan rekomendasi aktivitas yang dipersonalisasi. Proyek capstone ini mengembangkan Smart Caregiver, sebuah platform terintegrasi yang terdiri dari aplikasi mobile dan server backend yang dirancang untuk membantu caregiver dalam memantau dan merawat lansia. Aplikasi mobile dibangun dengan Flutter dan manajemen state GetX, menyediakan fitur pencatatan kesehatan, manajemen jadwal dengan pengingat alarm, rekomendasi aktivitas berbasis AI, visualisasi tren kesehatan, dan notifikasi push melalui Firebase Cloud Messaging. Server backend dibangun dengan FastAPI dan PostgreSQL, mengimplementasikan autentikasi JWT dengan verifikasi OTP email, REST API komprehensif untuk manajemen profil lansia, pencatatan kesehatan dengan analisis fuzzy logic untuk penilaian risiko kardiovaskular, metabolik, dan infeksi, manajemen jadwal dan alarm, serta rekomendasi aktivitas bertenaga AI menggunakan Groq LLM (qwen/qwen3-32b). Hasilnya menunjukkan platform yang berfungsi penuh yang memungkinkan caregiver memantau banyak lansia secara simultan, dengan analisis kesehatan otomatis, pengingat tepat waktu, dan saran aktivitas personal untuk meningkatkan kualitas perawatan lansia.<br><br>**_Kata Kunci:_** aplikasi mobile; caregiver; FastAPI; Flutter; fuzzy logic; lansia; monitoring kesehatan |

---

## I. PENDAHULUAN

Jumlah penduduk lanjut usia (lansia) yang membutuhkan pendampingan terus meningkat seiring dengan bertambahnya angka harapan hidup. Caregiver, baik keluarga maupun tenaga profesional, sering kali menghadapi kesulitan dalam memantau kondisi kesehatan banyak lansia sekaligus tanpa alat bantu yang terintegrasi. Pencatatan kesehatan lansia sebagian besar masih dilakukan secara manual menggunakan buku catatan atau spreadsheet, yang rentan terhadap kesalahan, inkonsistensi, dan menyulitkan analisis tren kesehatan jangka panjang. Selain itu, rekomendasi aktivitas untuk lansia umumnya bersifat generik dan tidak mempertimbangkan kondisi fisik, riwayat penyakit, serta minat individu masing-masing lansia. Sistem pengingat jadwal minum obat dan pemeriksaan rutin juga masih kurang optimal, meningkatkan risiko terlewatnya perawatan penting.

Penelitian sebelumnya telah mengembangkan berbagai sistem monitoring lansia, namun sebagian besar berfokus pada satu aspek saja, seperti pencatatan kesehatan atau pengingat jadwal secara terpisah. Beberapa sistem juga belum memanfaatkan kecerdasan buatan untuk memberikan rekomendasi aktivitas yang dipersonalisasi berdasarkan profil dan kondisi kesehatan lansia. Dibutuhkan sebuah platform terpadu yang mengintegrasikan pencatatan kesehatan, manajemen jadwal dengan pengingat otomatis, rekomendasi aktivitas berbasis AI, serta analisis risiko kesehatan menggunakan fuzzy logic dalam satu ekosistem yang koheren.

Tujuan dari penelitian ini adalah mengembangkan aplikasi Smart Caregiver yang memudahkan caregiver dalam: (1) memantau dan mencatat kondisi kesehatan harian dari banyak lansia sekaligus dalam satu platform; (2) meningkatkan kepatuhan jadwal minum obat dan rutinitas pemeriksaan melalui sistem pengingat otomatis; (3) menghadirkan rekomendasi aktivitas yang dipersonalisasi untuk setiap lansia menggunakan kecerdasan buatan; serta (4) menganalisis risiko kesehatan secara otomatis menggunakan fuzzy logic.

Kebaruan dari penelitian ini terletak pada integrasi tiga komponen utama dalam satu platform: analisis risiko kesehatan multi-dimensi menggunakan fuzzy logic yang mencakup risiko kardiovaskular, metabolik, dan infeksi secara simultan; sistem rekomendasi aktivitas berbasis Large Language Model (LLM) melalui Groq API yang mempertimbangkan data profil dan kondisi kesehatan lansia secara individual; serta mekanisme trigger otomatis yang menghubungkan pencatatan kesehatan dengan pembuatan notifikasi, analisis fuzzy, dan pembentukan jadwal dari rekomendasi yang disetujui dalam satu alur kerja yang seamless.

## II. METODE

### A. Arsitektur Sistem

Sistem Smart Caregiver dibangun dengan arsitektur client-server yang terdiri dari dua komponen utama: aplikasi mobile sebagai frontend dan server backend API. Aplikasi mobile dikembangkan menggunakan Flutter dengan pola arsitektur GetX untuk state management, routing, dan dependency injection. Server backend dikembangkan menggunakan framework FastAPI dengan Python, yang menyediakan REST API dengan dokumentasi interaktif melalui Swagger UI dan ReDoc. Basis data menggunakan PostgreSQL dengan SQLAlchemy sebagai ORM dan Alembic untuk manajemen migrasi.

![Gambar 1. Arsitektur Sistem Smart Caregiver](https://via.placeholder.com/800x400?text=Arsitektur+Sistem+Smart+Caregiver)

Gambar 1 menunjukkan arsitektur sistem secara keseluruhan. Aplikasi mobile berkomunikasi dengan server backend melalui REST API yang diamankan dengan JWT (JSON Web Token). Server backend terintegrasi dengan beberapa layanan eksternal: PostgreSQL untuk penyimpanan data, Groq API untuk pembangkitan rekomendasi aktivitas berbasis AI, Firebase Cloud Messaging (FCM) untuk notifikasi push, serta layanan SMTP untuk pengiriman email verifikasi OTP.

### B. Metode Pengembangan

Pengembangan sistem menggunakan metode iteratif dengan pendekatan test-driven development (TDD) pada beberapa komponen kritis. Proses pengembangan dibagi menjadi lima sprint:

1. **Sprint 1: Fondasi Autentikasi & Otorisasi** — Implementasi dependency JWT, helper akses caregiver, endpoint registrasi dengan OTP email, login, refresh token, dan profil pengguna.

2. **Sprint 2: Manajemen Profil Lansia & Dashboard** — CRUD profil lansia, dashboard overview, dan tren kesehatan dengan rentang 7 dan 30 hari.

3. **Sprint 3: Pencatatan Kesehatan & Fuzzy Logic** — Pencatatan parameter kesehatan harian, analisis fuzzy logic multi-dimensi, dan deteksi threshold otomatis.

4. **Sprint 4: Jadwal, Alarm & Notifikasi** — CRUD jadwal dengan alarm pengingat, notifikasi in-app dan push, serta ringkasan mingguan.

5. **Sprint 5: Rekomendasi AI & Pengujian** — Integrasi Groq LLM untuk rekomendasi aktivitas, mekanisme approve/reject, pembuatan jadwal otomatis, serta pengujian end-to-end.

### C. Teknologi yang Digunakan

#### C.1. Mobile Application

| Komponen | Teknologi |
|--- |--- |
| Framework | Flutter 3.9+ / Dart 3.9+ |
| State Management | GetX (state management, routing, dependency injection) |
| HTTP Client | Dio dengan interceptor autentikasi dan token refresh |
| Penyimpanan Token | flutter_secure_storage |
| Cache Lokal | GetStorage |
| Notifikasi Push | Firebase Messaging + flutter_local_notifications |
| Chart & Visualisasi | fl_chart |
| Manajemen Gambar | cached_network_image, image_picker |

#### C.2. Server Backend

| Komponen | Teknologi |
|--- |--- |
| Framework | FastAPI (Python) |
| Basis Data | PostgreSQL via asyncpg |
| ORM | SQLAlchemy 2.0 (async) |
| Migrasi | Alembic |
| Autentikasi | JWT (python-jose) + bcrypt (passlib) |
| Fuzzy Logic | scikit-fuzzy, numpy, scipy |
| AI/LLM | Groq API (qwen/qwen3-32b) |
| Notifikasi Push | Firebase Admin SDK |
| Rate Limiting | slowapi |
| Penjadwalan | APScheduler |

### D. Implementasi Fuzzy Logic

Sistem fuzzy logic dikembangkan untuk menganalisis risiko kesehatan lansia secara otomatis berdasarkan parameter vital yang dicatat. Tiga modul analisis diimplementasikan:

- **Risiko Kardiovaskular**: Menganalisis tekanan darah sistolik, detak jantung, dan tingkat SpO2 untuk menentukan tingkat risiko kardiovaskular. Variabel input dievaluasi menggunakan fungsi keanggotaan fuzzy (rendah, normal, tinggi) dan dievaluasi dengan aturan inferensi Mamdani.

- **Risiko Metabolik**: Menganalisis gula darah, kolesterol, asam urat, dan berat badan. Modul ini aktif jika salah satu parameter metabolik tersedia, memungkinkan analisis parsial ketika data tidak lengkap.

- **Risiko Infeksi**: Menganalisis suhu tubuh dan tingkat SpO2. Modul ini aktif ketika kedua parameter tersedia, mendeteksi potensi infeksi melalui demam dan penurunan saturasi oksigen.

Setiap modul menghasilkan skor 0-100 yang dikategorikan menjadi Normal (≤40), Warning (41-70), atau Critical (>70). Skor akhir merupakan rata-rata tidak berbobot dari seluruh modul yang aktif. Analisis dijalankan secara asynchronous dalam thread-pool executor agar tidak memblokir request utama.

### E. Implementasi Rekomendasi AI

Rekomendasi aktivitas berbasis AI menggunakan model bahasa Groq `qwen/qwen3-32b` yang dipanggil melalui REST API. Proses pembangkitan rekomendasi meliputi:

1. **Pembuatan Prompt**: Data profil lansia (nama, usia, riwayat penyakit, kondisi fisik, mobilitas, minat/hobi) dikompilasi menjadi prompt terstruktur yang meminta LLM menghasilkan 5 rekomendasi aktivitas yang sesuai.

2. **Pemanggilan API Groq**: Prompt dikirim ke Groq API dengan pengaturan suhu 0.7 untuk keseimbangan antara kreativitas dan konsistensi.

3. **Parsing Respons**: Respons LLM diparsing untuk mengekstrak judul aktivitas, deskripsi, durasi, dan kategori. Jika parsing JSON gagal, sistem melakukan fallback ke line-parsing.

4. **Penyimpanan**: Rekomendasi disimpan ke database dengan status `pending`. Caregiver dapat menyetujui (approve) atau menolak (reject) rekomendasi. Persetujuan dengan jadwal akan otomatis membuat entri jadwal baru.

### F. Mekanisme Autentikasi & Otorisasi

Sistem autentikasi menggunakan JWT dengan access token (berlaku 30 menit) dan refresh token untuk pembaruan token tanpa login ulang. Alur registrasi meliputi: (1) pengiriman email dan password; (2) validasi format dan kecocokan password; (3) pembuatan akun dengan status email belum terverifikasi; (4) pengiriman OTP 6 digit ke email; (5) verifikasi OTP untuk mengaktifkan akun. Setiap endpoint dilindungi oleh dependency `get_current_user` yang memvalidasi JWT, sementara akses ke data lansia digate oleh `require_caregiver_owner` yang memastikan hanya caregiver pemilik yang dapat mengakses data.

## III. HASIL DAN PEMBAHASAN

### A. Implementasi REST API

Server backend mengimplementasikan 9 router dengan total lebih dari 40 endpoint yang mencakup seluruh fitur aplikasi. Tabel 1 menyajikan ringkasan endpoint API yang telah dikembangkan.

TABEL 1  
RINGKASAN ENDPOINT API

| Router | Prefix | Fungsi Utama | Endpoint Kunci |
|--- |--- |--- |--- |
| Auth | `/auth` | Registrasi, login, refresh token, profil | `POST /auth/register`, `POST /auth/login`, `POST /auth/refresh`, `GET /auth/me` |
| Auth Google | `/auth/google` | Login dengan Google OAuth | `GET /auth/google/login`, `POST /auth/google/callback` |
| Elderly | `/elderly` | CRUD profil lansia | `POST /elderly`, `GET /elderly`, `PUT /elderly/{id}`, `DELETE /elderly/{id}` |
| Health | `/elderly/{id}/health` | Pencatatan & riwayat kesehatan | `POST /elderly/{id}/health`, `GET /elderly/{id}/health`, `POST /elderly/{id}/health/{rid}/reanalyze` |
| Dashboard | `/dashboard` | Overview & tren kesehatan | `GET /dashboard/overview`, `GET /elderly/{id}/health/trends` |
| Schedule | `/elderly/{id}/schedules` | CRUD jadwal & alarm | `POST /elderly/{id}/schedules`, `PUT /schedules/{id}`, `PATCH /schedules/{id}/complete` |
| Recommendation | `/elderly/{id}/recommendations` | Rekomendasi aktivitas AI | `POST generate`, `GET list`, `POST approve`, `POST reject` |
| Notification | `/notifications` | Notifikasi in-app | `GET /notifications`, `PATCH /notifications/{id}/read`, `PUT /preferences` |
| Internal Jobs | `/internal/jobs` | Pekerjaan terjadwal | `POST /dispatch-due-alarms`, `POST /send-weekly-summary` |

### B. Implementasi Aplikasi Mobile

Aplikasi mobile dikembangkan dengan 20 modul yang mencakup seluruh alur pengguna. Setiap modul mengikuti pola arsitektur GetX dengan pemisahan binding, controller, dan view. Tabel 2 menyajikan modul-modul yang telah diimplementasikan.

TABEL 2  
MODUL APLIKASI MOBILE

| Modul | Deskripsi |
|--- |--- |
| Splash | Inisialisasi aplikasi, pengecekan session token |
| Login | Autentikasi caregiver dengan email dan password |
| Register | Pendaftaran caregiver baru dengan verifikasi OTP |
| Home | Dashboard utama dengan ringkasan semua lansia |
| Dashboard | Grafik tren kesehatan per parameter (7/30 hari) |
| Patient Detail | Detail profil dan kondisi lansia |
| Log Kesehatan | Input parameter kesehatan harian |
| Jadwal Lansia | Manajemen jadwal dan alarm pengingat |
| Calendar | Tampilan kalender jadwal bulanan |
| Rekomendasi AI | Daftar rekomendasi aktivitas dengan approve/reject |
| Notifikasi | Riwayat notifikasi dan pengaturan preferensi |
| Profil Lansia | Data profil lengkap lansia |
| Profil Caregiver | Data profil caregiver |
| Edit Profile | Perubahan data profil caregiver |
| Tambah Lansia | Form penambahan profil lansia baru |
| Template Jadwal | Template pembuatan jadwal |

### C. Implementasi Fuzzy Logic untuk Analisis Risiko Kesehatan

Sistem fuzzy logic berhasil diimplementasikan dengan tiga modul analisis yang berjalan secara otomatis setiap kali catatan kesehatan baru dibuat. Mekanisme aktivasi modul bersifat adaptif:

- Modul kardiovaskular aktif jika tekanan darah sistolik, detak jantung, DAN tingkat SpO2 tersedia.
- Modul metabolik aktif jika SALAH SATU dari gula darah, kolesterol, asam urat, atau berat badan tersedia.
- Modul infeksi aktif jika suhu tubuh DAN tingkat SpO2 tersedia.

Setiap modul menghasilkan skor yang kemudian dikategorikan ke dalam status kesehatan: Normal (skor ≤ 40), Warning (skor 41-70), dan Critical (skor > 70). Sistem threshold tambahan membandingkan setiap parameter terhadap ambang batas normal yang telah ditentukan. Jika threshold terlampaui, sistem secara otomatis memicu notifikasi `CRITICAL_ALERT` dengan prioritas tinggi.

### D. Sistem Rekomendasi Aktivitas Berbasis AI

Sistem rekomendasi AI berhasil mengintegrasikan Groq LLM untuk menghasilkan rekomendasi aktivitas yang dipersonalisasi. Setiap rekomendasi mencakup judul aktivitas, deskripsi, estimasi durasi, dan kategori (fisik, kognitif, sosial, atau relaksasi). Proses persetujuan rekomendasi oleh caregiver akan otomatis membuat entri jadwal baru dengan sumber "ai_approved", mengintegrasikan rekomendasi AI langsung ke dalam sistem penjadwalan.

Hasil pengujian menunjukkan bahwa LLM mampu menghasilkan rekomendasi yang relevan berdasarkan data profil lansia. Sebagai contoh, untuk lansia dengan mobilitas terbatas (wheelchair) dan minat musik, sistem merekomendasikan "terapi musik duduk" atau "senam jari". Untuk lansia dengan mobilitas mandiri dan hobi berkebun, sistem merekomendasikan "berkebun ringan" atau "jalan santai di taman".

### E. Mekanisme Trigger Otomatis

Sistem mengimplementasikan serangkaian trigger otomatis yang menghubungkan berbagai fitur:

1. **Health Record → Fuzzy Analysis + Notifikasi**: Setiap pencatatan kesehatan baru secara otomatis memicu analisis fuzzy dan pembuatan notifikasi `HEALTH_RECORDED`. Jika threshold terlampaui, notifikasi `CRITICAL_ALERT` dibuat.

2. **Recommendation Approve → Schedule**: Persetujuan rekomendasi dengan `scheduled_at` otomatis membuat jadwal baru dengan sumber "ai_approved".

3. **Schedule with Alarm → ScheduleAlarm**: Pembuatan jadwal dengan `reminder_minutes` otomatis membuat baris `ScheduleAlarm` yang siap diproses oleh job dispatcher.

4. **Due Alarm → Notification**: Job internal `dispatch-due-alarms` memproses alarm yang jatuh tempo dan membuat notifikasi `ALARM_REMINDER`.

5. **Weekly Summary → Notification**: Job internal `send-weekly-summary` menghitung ringkasan kondisi 7 hari terakhir dan membuat notifikasi `WEEKLY_SUMMARY`.

### F. Pengujian

Pengujian dilakukan pada beberapa layer:
- **Unit Testing (Backend)**: 7+ test mencakup health check, root endpoint, validasi auth, weekly summary job, dan dokumentasi API.
- **Integration Testing (Backend)** : Pengujian authorization caregiver, trigger notifikasi dari health record, trend range 7/30 hari, approve recommendation ke schedule, dan alarm ke notification.
- **Code Analysis (Mobile)**: Analisis kode dengan `flutter analyze` untuk memastikan kualitas kode.

## IV. SIMPULAN

Penelitian ini berhasil mengembangkan Smart Caregiver, sebuah platform terintegrasi untuk membantu caregiver dalam memantau dan merawat lansia. Sistem terdiri dari aplikasi mobile berbasis Flutter dan server backend berbasis FastAPI dengan PostgreSQL. Platform ini mengimplementasikan enam fitur utama: (1) autentikasi caregiver dengan JWT dan verifikasi OTP email; (2) manajemen profil lansia dengan dukungan multi-lansia per caregiver; (3) pencatatan kesehatan harian dengan analisis fuzzy logic multi-dimensi untuk deteksi risiko kardiovaskular, metabolik, dan infeksi; (4) dashboard dan tren kesehatan dengan visualisasi grafik; (5) manajemen jadwal dengan alarm pengingat otomatis dan notifikasi push; serta (6) rekomendasi aktivitas berbasis AI yang dipersonalisasi menggunakan Groq LLM.

Integrasi fuzzy logic memungkinkan deteksi dini kondisi abnormal melalui analisis simultan berbagai parameter kesehatan, sementara sistem rekomendasi AI memberikan saran aktivitas yang disesuaikan dengan profil individu lansia. Mekanisme trigger otomatis antar fitur menciptakan alur kerja yang seamless, di mana satu tindakan (seperti pencatatan kesehatan) dapat memicu analisis, notifikasi, dan alert secara otomatis.

Pengembangan selanjutnya dapat difokuskan pada: implementasi face recognition untuk verifikasi identitas caregiver saat registrasi dan login, integrasi perangkat IoT untuk pengukuran parameter kesehatan secara otomatis, pengembangan aplikasi berbasis web untuk akses dari desktop, serta penerapan algoritma machine learning yang lebih canggih untuk prediksi tren kesehatan jangka panjang.

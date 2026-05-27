# Smart Caregiver — Manual End-to-End Test Cases

Dokumen ini berisi test case manual untuk validasi demo, sidang, dan regression check cepat. Fokusnya bukan hanya endpoint hijau, tapi memastikan alur caregiver di aplikasi mobile benar-benar bisa dipakai end-to-end.

## Prasyarat

### Server

```bash
cd server
source .venv/bin/activate
alembic upgrade head
uvicorn src.main:app --reload
```

Pastikan `.env` berisi nilai valid untuk:

- `DATABASE_URL`
- `SECRET_KEY`
- `ACCESS_TOKEN_EXPIRE_MINUTES`
- `GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET` jika Google OAuth diuji
- `GROQ_API_KEY` jika AI recommendation diuji
- `INTERNAL_API_KEY`
- `FCM_CREDENTIALS_PATH` jika FCM push diuji

### Mobile

```bash
cd mobile
flutter analyze
flutter build apk --debug
flutter run
```

Pastikan `mobile/lib/app/core/config.dart` mengarah ke base URL server yang benar untuk emulator/perangkat.

### Data Awal

Gunakan user baru untuk clean test, atau hapus data test lama dari database. Jangan gunakan kredensial production.

Contoh data caregiver:

| Field | Value |
| --- | --- |
| Nama | Caregiver Demo |
| Email | caregiver.demo@example.com |
| Password | Password123 |

Contoh data lansia:

| Field | Value |
| --- | --- |
| Nama | Ibu Siti Demo |
| Usia | 72 |
| Gender | Perempuan |
| Kondisi fisik | Mudah lelah, mobilitas sedang |
| Riwayat medis | Hipertensi ringan |
| Hobi | Jalan pagi, berkebun |
| Kontak darurat | Budi Demo / 081234567890 |

---

## TC-001 — Registrasi Caregiver + OTP

**Tujuan:** Memastikan caregiver bisa registrasi dan masuk ke flow verifikasi OTP.

**Langkah:**

1. Buka aplikasi.
2. Pilih register/daftar.
3. Isi nama, email, password, dan konfirmasi password.
4. Submit form registrasi.
5. Masukkan OTP sesuai mekanisme aplikasi/dev backend.
6. Submit OTP.

**Expected result:**

- Registrasi berhasil.
- OTP valid mengaktifkan akun.
- User diarahkan ke flow berikutnya, yaitu face registration atau login/home sesuai implementasi.
- Tidak ada crash atau snackbar error yang tidak relevan.

**Negative check:**

- Email invalid ditolak sebelum request dikirim.
- Password pendek ditolak.
- Password dan konfirmasi password yang berbeda ditolak.

---

## TC-002 — Face Registration

**Tujuan:** Memastikan fitur computer vision face recognition bisa menyimpan embedding wajah caregiver.

**Langkah:**

1. Setelah OTP/register berhasil, buka screen face registration.
2. Ambil foto wajah dengan kamera.
3. Pastikan wajah terlihat jelas, satu orang, pencahayaan cukup.
4. Submit face registration.

**Expected result:**

- Aplikasi mengirim gambar ke backend.
- Backend mendeteksi satu wajah dan menyimpan face embedding.
- User mendapat pesan sukses.
- User bisa lanjut ke login/home.

**Negative check:**

- Foto tanpa wajah harus ditolak dengan pesan yang jelas.
- Foto terlalu gelap/blur harus gagal secara aman, bukan crash.
- Foto dengan lebih dari satu wajah idealnya ditolak atau memilih wajah utama secara konsisten sesuai implementasi.

---

## TC-003 — Login Email + Password + Face Verify

**Tujuan:** Memastikan login utama berjalan dan face verification bisa dipakai setelah login.

**Langkah:**

1. Logout jika masih login.
2. Login dengan email dan password yang valid.
3. Jika diarahkan ke face verify, ambil foto wajah caregiver yang sama.
4. Submit verification.

**Expected result:**

- Login email/password berhasil dan token tersimpan.
- Face verification berhasil untuk wajah yang sama.
- User masuk ke halaman utama/home.
- `GET /auth/face/status` menunjukkan face sudah terdaftar.

**Negative check:**

- Password salah ditolak.
- Foto tanpa wajah saat verify ditolak.
- Foto orang berbeda idealnya gagal similarity threshold.

---

## TC-004 — Skip Face Flow Jika Opsional

**Tujuan:** Memastikan face recognition tidak memblokir akses jika desain aplikasi menyediakan skip.

**Langkah:**

1. Login sebagai user yang belum mendaftarkan wajah, atau ulangi dari registrasi baru.
2. Pada screen face registration/verification, pilih skip jika tersedia.

**Expected result:**

- User tetap bisa masuk aplikasi.
- Tidak ada loop navigasi ke face screen.
- Status face tetap “belum terdaftar”.

---

## TC-005 — Tambah Profil Lansia

**Tujuan:** Memastikan caregiver bisa membuat profil lansia.

**Langkah:**

1. Dari home, pilih tambah lansia.
2. Isi data lansia sesuai contoh data awal.
3. Submit.

**Expected result:**

- Profil lansia berhasil dibuat.
- Lansia muncul di list home.
- Detail lansia menampilkan data yang sama dengan input.
- Data tersimpan di backend via `POST /elderly`.

**Negative check:**

- Nama kosong ditolak.
- Usia invalid ditolak.
- Form tidak boleh silently submit data kosong.

---

## TC-006 — Multiple Elderly Profiles

**Tujuan:** Memastikan caregiver bisa punya lebih dari satu profil lansia dan data tidak tercampur.

**Langkah:**

1. Tambahkan lansia kedua, misalnya “Pak Agus Demo”.
2. Kembali ke home.
3. Buka detail masing-masing lansia.

**Expected result:**

- Dua profil muncul di list.
- Masing-masing detail sesuai data sendiri.
- Health record/schedule/recommendation per lansia tidak tercampur.

---

## TC-007 — Input Health Record Normal

**Tujuan:** Memastikan pencatatan kesehatan normal tersimpan dan fuzzy analysis berjalan.

**Langkah:**

1. Pilih lansia “Ibu Siti Demo”.
2. Buka log kesehatan.
3. Isi nilai normal:
   - Tekanan darah: 120/80
   - Heart rate: 75
   - SpO2: 98
   - Gula darah: 110
   - Kolesterol: 180
   - Asam urat: 5
   - Berat badan: 60
   - Suhu tubuh: 36.7
   - Catatan: Kondisi stabil
4. Submit.

**Expected result:**

- Health record tersimpan.
- Status kesehatan normal/stabil sesuai rule fuzzy.
- User diarahkan ke success/detail screen.
- Notification `HEALTH_RECORDED` dibuat.
- Dashboard/latest health ikut berubah.

---

## TC-008 — Input Health Record Abnormal / Critical Alert

**Tujuan:** Memastikan nilai berisiko memicu status perhatian/kritis dan notifikasi.

**Langkah:**

1. Pilih lansia yang sama.
2. Buka log kesehatan.
3. Isi nilai abnormal:
   - Tekanan darah: 180/110
   - Heart rate: 120
   - SpO2: 90
   - Gula darah: 240
   - Kolesterol: 260
   - Asam urat: 9
   - Berat badan: 60
   - Suhu tubuh: 38.5
   - Keluhan: Pusing dan lemas
4. Submit.

**Expected result:**

- Health record tersimpan.
- Fuzzy analysis menghasilkan status needs attention/critical sesuai threshold.
- Notification `CRITICAL_ALERT` atau alert kesehatan dibuat.
- Jika FCM aktif dan device token terdaftar, push notification diterima.
- Dashboard menampilkan kondisi terbaru.

**Catatan:** Jangan pakai nilai tepat di boundary ekstrem membership fuzzy jika ingin hasil stabil. Gunakan nilai abnormal yang masih berada di dalam rentang membership.

---

## TC-009 — Health History dan Detail Fuzzy Analysis

**Tujuan:** Memastikan riwayat kesehatan dan skor fuzzy bisa dilihat.

**Langkah:**

1. Buka detail lansia.
2. Masuk ke history kesehatan.
3. Pilih record normal dan abnormal yang baru dibuat.

**Expected result:**

- List history menampilkan record terbaru.
- Detail record menampilkan parameter kesehatan.
- Skor/hasil fuzzy analysis muncul untuk cardiovascular, metabolic, dan infection jika tersedia.
- Tidak ada data statis/hardcoded seperti nama pasien lama.

---

## TC-010 — Dashboard Overview dan Trend Chart

**Tujuan:** Memastikan dashboard membaca data real dari backend.

**Langkah:**

1. Buka dashboard/home overview.
2. Cek ringkasan semua lansia.
3. Buka trend chart 7 hari dan 30 hari.
4. Ganti parameter chart jika tersedia.

**Expected result:**

- Overview menampilkan jumlah lansia dan status terbaru.
- Chart menampilkan titik data dari health records.
- Selector parameter mengubah data chart.
- Tidak ada placeholder hardcoded yang terlihat sebagai data utama.

---

## TC-011 — CRUD Schedule / Jadwal Lansia

**Tujuan:** Memastikan jadwal lansia bisa dibuat, dilihat, diedit, diselesaikan, dan dihapus.

**Langkah:**

1. Pilih lansia.
2. Buka jadwal lansia.
3. Buat jadwal baru:
   - Judul: Minum obat pagi
   - Tipe: medication
   - Waktu: besok pukul 08:00
   - Reminder: 15 menit sebelum
   - Deskripsi: Obat hipertensi
4. Simpan.
5. Buka detail jadwal.
6. Edit judul/deskripsi.
7. Tandai selesai.
8. Hapus jadwal jika flow delete tersedia.

**Expected result:**

- Jadwal muncul di list dan calendar.
- Edit tersimpan.
- Mark complete mengubah status.
- Delete menghapus jadwal dari list.
- Reminder minutes terkirim ke backend dan membuat alarm row.

---

## TC-012 — Dispatch Due Alarm Internal Job

**Tujuan:** Memastikan alarm reminder bisa membuat notifikasi saat waktunya tiba.

**Langkah:**

1. Buat schedule dengan reminder yang waktunya segera due.
2. Jalankan internal job dari client/API tool:

```bash
curl -X POST http://localhost:8000/internal/jobs/dispatch-due-alarms \
  -H "X-Internal-API-Key: <INTERNAL_API_KEY>"
```

3. Buka halaman notifikasi.

**Expected result:**

- Notification `ALARM_REMINDER` dibuat.
- Notifikasi muncul di mobile.
- Jika FCM aktif, push notification terkirim.
- Job tidak membuat duplicate notification untuk alarm yang sama jika dipanggil ulang.

---

## TC-013 — AI Recommendation Generate

**Tujuan:** Memastikan rekomendasi aktivitas AI bisa dibuat berdasarkan data lansia.

**Langkah:**

1. Pastikan `GROQ_API_KEY` valid di server.
2. Pilih lansia dengan profil dan health records.
3. Buka rekomendasi AI.
4. Klik generate recommendation.
5. Tambahkan context jika ada field tambahan, misalnya “sedang mudah lelah”.

**Expected result:**

- Request ke backend berhasil.
- Rekomendasi muncul di list.
- Isi rekomendasi relevan dengan profil/kondisi lansia.
- Jika LLM response tidak JSON sempurna, fallback parser tetap menghasilkan item rekomendasi.

**Negative check:**

- Jika `GROQ_API_KEY` tidak valid, aplikasi menampilkan error yang bisa dipahami.
- Tidak crash/loading selamanya.

---

## TC-014 — Approve Recommendation Menjadi Schedule

**Tujuan:** Memastikan rekomendasi yang disetujui otomatis masuk ke jadwal.

**Langkah:**

1. Dari list rekomendasi, pilih satu recommendation pending.
2. Klik approve.
3. Pilih `scheduled_at` dan optional reminder.
4. Submit.
5. Buka jadwal lansia/calendar.

**Expected result:**

- Status recommendation berubah menjadi approved.
- Schedule baru dibuat dengan `source = ai_approved`.
- Jadwal muncul di list/calendar.
- Jika reminder dipilih, alarm reminder dibuat.

---

## TC-015 — Reject Recommendation

**Tujuan:** Memastikan caregiver bisa menolak rekomendasi.

**Langkah:**

1. Generate recommendation baru jika perlu.
2. Pilih recommendation pending.
3. Klik reject.
4. Isi reason jika tersedia.
5. Submit.

**Expected result:**

- Status recommendation berubah menjadi rejected.
- Recommendation tidak membuat jadwal.
- List recommendation menampilkan status terbaru.

---

## TC-016 — Notification List, Unread Count, Mark Read

**Tujuan:** Memastikan notifikasi in-app bisa dibaca dan status unread berjalan.

**Langkah:**

1. Buat health record agar notification muncul.
2. Buka halaman notifikasi.
3. Cek unread badge/count.
4. Buka/mark satu notification as read.
5. Klik mark all as read jika tersedia.

**Expected result:**

- Notification list berisi event terbaru.
- Unread count sesuai jumlah notifikasi belum dibaca.
- Mark read mengubah status satu item.
- Mark all mengubah semua item menjadi read.

---

## TC-017 — Notification Preferences

**Tujuan:** Memastikan preferensi notifikasi bisa diambil dan diubah.

**Langkah:**

1. Buka pengaturan notifikasi jika tersedia.
2. Toggle push/email/in-app untuk salah satu tipe notifikasi.
3. Simpan.
4. Reload screen.

**Expected result:**

- Preferensi tersimpan ke backend.
- Reload menampilkan nilai terbaru.
- Notifikasi berikutnya mengikuti preferensi sesuai implementasi.

---

## TC-018 — FCM Device Token Registration

**Tujuan:** Memastikan mobile mendaftarkan FCM token ke backend.

**Langkah:**

1. Login di perangkat/emulator dengan Firebase configured.
2. Izinkan notification permission.
3. Pantau server log atau database `device_tokens`.
4. Trigger health critical alert atau alarm reminder.

**Expected result:**

- Mobile mendapatkan FCM token.
- Token terkirim ke `POST /notifications/register-device`.
- Token tersimpan/aktif di database.
- Push notification diterima saat event dibuat.

**Negative check:**

- Jika Firebase credential belum tersedia, in-app notification tetap bekerja.
- Server tidak crash saat FCM disabled atau credential invalid; error push dicatat secara aman.

---

## TC-019 — JWT Auto Refresh

**Tujuan:** Memastikan access token refresh otomatis saat expired.

**Langkah:**

1. Login dan pastikan refresh token tersimpan.
2. Paksa access token expired, misalnya set expiry pendek di env/dev atau tunggu expiry.
3. Lakukan action authenticated, seperti buka dashboard atau list elderly.

**Expected result:**

- Request pertama mendapat 401.
- Client memanggil `/auth/refresh`.
- Request asli diulang dengan access token baru.
- User tidak langsung logout jika refresh token valid.

**Negative check:**

- Jika refresh token invalid/expired, storage dibersihkan dan user diarahkan ke login.

---

## TC-020 — Logout Flow

**Tujuan:** Memastikan logout membersihkan sesi lokal.

**Langkah:**

1. Login sebagai caregiver.
2. Buka profil/settings.
3. Klik logout.
4. Tutup dan buka ulang aplikasi.

**Expected result:**

- Access token, refresh token, dan data session lokal terhapus.
- User diarahkan ke login.
- Tidak bisa membuka screen authenticated tanpa login ulang.

---

## TC-021 — Access Control Antar Caregiver

**Tujuan:** Memastikan caregiver tidak bisa melihat/mengubah data caregiver lain.

**Langkah:**

1. Buat caregiver A dan lansia A.
2. Buat caregiver B dan login sebagai B.
3. Dengan API tool, coba akses elderly ID milik caregiver A memakai token caregiver B.

```bash
curl http://localhost:8000/elderly/<ELDERLY_A_ID> \
  -H "Authorization: Bearer <TOKEN_CAREGIVER_B>"
```

**Expected result:**

- Backend mengembalikan 403 Forbidden.
- Data caregiver A tidak tampil di akun caregiver B.
- List elderly caregiver B tidak berisi data caregiver A.

---

## TC-022 — Weekly Summary Internal Job

**Tujuan:** Memastikan job weekly summary membuat notifikasi ringkasan.

**Langkah:**

1. Pastikan caregiver punya lansia dan health records dalam periode minggu ini.
2. Jalankan:

```bash
curl -X POST http://localhost:8000/internal/jobs/send-weekly-summary \
  -H "X-Internal-API-Key: <INTERNAL_API_KEY>"
```

3. Buka halaman notifikasi.

**Expected result:**

- Notification `WEEKLY_SUMMARY` dibuat.
- Isi ringkasan sesuai data lansia/health records.
- Job hanya bisa dipanggil dengan internal API key valid.

---

## TC-023 — Navigation Argument Audit

**Tujuan:** Memastikan screen yang butuh `elderly_id` tidak kehilangan context.

**Langkah:**

1. Dari home, buka setiap fitur per lansia:
   - detail profil
   - log kesehatan
   - health history
   - jadwal
   - calendar
   - rekomendasi AI
2. Navigasi bolak-balik antar screen.

**Expected result:**

- Semua screen menerima `elderly_id` dan nama lansia yang benar.
- Tidak ada error null argument.
- Tidak ada fallback nama hardcoded seperti data mock lama.

---

## TC-024 — Fresh Install / App Restart

**Tujuan:** Memastikan state lokal tidak rusak setelah aplikasi ditutup/dibuka.

**Langkah:**

1. Login.
2. Tutup aplikasi sepenuhnya.
3. Buka ulang aplikasi.
4. Navigasi ke home/dashboard.

**Expected result:**

- Jika token masih valid, user tetap login.
- Jika token expired tapi refresh valid, auto-refresh berjalan.
- Jika session invalid, user diarahkan ke login.

---

## TC-025 — Demo Happy Path 5–7 Menit

**Tujuan:** Alur demo cepat untuk presentasi.

**Langkah demo:**

1. Login caregiver.
2. Tunjukkan face verification sebagai implementasi computer vision.
3. Buka/tambahkan profil lansia.
4. Input health record abnormal.
5. Tunjukkan fuzzy analysis/status kesehatan.
6. Tunjukkan notification/critical alert.
7. Generate AI recommendation.
8. Approve recommendation menjadi schedule.
9. Buka calendar/jadwal untuk membuktikan schedule terbuat otomatis.

**Expected result:**

- Semua fitur utama PRD terlihat dalam satu narasi.
- Tidak perlu setup manual panjang saat demo.
- Jika AI/FCM eksternal lambat, masih ada fallback: tampilkan health record, fuzzy analysis, notification in-app, dan schedule.

---

## Final Acceptance Checklist

Sebelum demo/sidang, checklist ini harus hijau:

- [ ] Server bisa start tanpa error.
- [ ] `alembic upgrade head` sudah applied.
- [ ] `pytest` server passed.
- [ ] `flutter analyze` no issues.
- [ ] `flutter build apk --debug` passed.
- [ ] Login/register flow bisa dipakai.
- [ ] Face register/verify tested dengan kamera real.
- [ ] Tambah lansia works.
- [ ] Health record normal dan abnormal works.
- [ ] Fuzzy analysis muncul.
- [ ] Dashboard/history/chart membaca data real.
- [ ] Schedule CRUD works.
- [ ] AI recommendation generate works atau graceful error jika key tidak tersedia.
- [ ] Approve recommendation membuat schedule.
- [ ] Notification list/unread/mark read works.
- [ ] FCM push works jika Firebase credential tersedia.
- [ ] Logout membersihkan session.
- [ ] Tidak ada data mock/hardcoded yang terlihat di flow utama.

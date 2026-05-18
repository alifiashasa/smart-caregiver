# **Template Screen Layout Testing – Capstone Project**

**Nama Proyek:** Smart Caregiver — CareTrack

**Modul/Halaman:** Aplikasi Mobile Caregiver (Flutter) — 14 Halaman

**Dokumen Referensi:** Figma Design System v1.0 / PRD Rev 01

### **1. Preconditions (Prasyarat)**

- Aplikasi Flutter telah berjalan di lingkungan pengujian (emulator/device fisik).
- User sudah login dengan akun caregiver aktif.
- Minimal 1 data lansia telah ditambahkan untuk halaman yang membutuhkan data pasien.
- Koneksi internet aktif (untuk Google OAuth dan AI Recommendation).
- Desain _high-fidelity_ (Figma) tersedia sebagai pembanding.

### **2. Tabel Pengujian Layout**

| No  | ID Test | Komponen / Item Name | Kategori Pengecekan | Prosedur / Kondisi | Hasil yang Diharapkan | Status (OK/NG) | Evidence (Link/Nama File) |
| :-: | :-----: | :------------------: | ------------------- | :----------------: | :-------------------: | :------------: | :-----------------------: |
| **A** | **Label Name Checking** |  |  |  |  |  |  |
| 1 | LY-LB-01 | Splash — Logo CareTrack | Label Name | Cek teks brand "CareTrack" pada splash | Menampilkan teks "CareTrack" dengan font besar (40px), bold, warna hitam. |  |  |
| 2 | LY-LB-02 | Splash — Tagline | Label Name | Cek teks di bawah logo | Menampilkan "Pantau pasien, kelola perawatan dengan tenang" rata tengah. |  |  |
| 3 | LY-LB-03 | Login — Judul "CareTrack" | Label Name | Cek teks brand di halaman login | Menampilkan "CareTrack" dengan font 28px, bold, hitam. |  |  |
| 4 | LY-LB-04 | Login — Subtitle | Label Name | Cek teks di bawah logo | Menampilkan "Masuk untuk memantau kesehatan lansia" rata tengah. |  |  |
| 5 | LY-LB-05 | Login — Label "Email" | Label Name | Cek label field email | Menampilkan teks "Email" dengan font 14px, weight 600. |  |  |
| 6 | LY-LB-06 | Login — Label "Kata Sandi" | Label Name | Cek label field password | Menampilkan teks "Kata Sandi" dengan font 14px, weight 600. |  |  |
| 7 | LY-LB-07 | Login — Teks Tombol "Masuk" | Label Name | Cek teks pada tombol utama | Menampilkan teks "Masuk" dengan font 16px, weight 600. |  |  |
| 8 | LY-LB-08 | Login — Teks Tombol Google | Label Name | Cek teks pada tombol Google | Menampilkan "Masuk dengan Google" dengan ikon Google di samping kiri. |  |  |
| 9 | LY-LB-09 | Login — Text Link "Daftar" | Label Name | Cek teks link di bawah | Menampilkan "Belum punya akun? Daftar" — kata "Daftar" bold. |  |  |
| 10 | LY-LB-10 | Register — Judul "Buat Akun Caregiver" | Label Name | Cek judul halaman registrasi | Menampilkan "Buat Akun Caregiver" rata tengah, 24px, bold. |  |  |
| 11 | LY-LB-11 | Register — Label "Nama Lengkap" | Label Name | Cek label field nama | Menampilkan teks "Nama Lengkap". |  |  |
| 12 | LY-LB-12 | Register — Label "Konfirmasi Kata Sandi" | Label Name | Cek label konfirmasi password | Menampilkan teks "Konfirmasi Kata Sandi". |  |  |
| 13 | LY-LB-13 | Register — Teks Tombol "Daftar Sekarang" | Label Name | Cek teks tombol registrasi | Menampilkan "Daftar Sekarang" dengan background hijau (#BBF246). |  |  |
| 14 | LY-LB-14 | Home — Judul "Selamat Pagi, Sari" | Label Name | Cek sapaan di halaman home | Menampilkan sapaan dinamis dengan nama caregiver. |  |  |
| 15 | LY-LB-15 | Home — Deskripsi "Berikut adalah status pasien..." | Label Name | Cek teks deskripsi | Menampilkan "Berikut adalah status pasien Anda hari ini." |  |  |
| 16 | LY-LB-16 | Home — Label Kartu "Total Pasien" & "Perlu Perhatian" | Label Name | Cek teks pada kartu statistik | Kartu kiri: "Total Pasien". Kartu kanan: "Perlu Perhatian". |  |  |
| 17 | LY-LB-17 | Home — Placeholder Search "Cari Pasien" | Label Name | Cek teks di search bar | Menampilkan "Cari Pasien" dengan ikon search. |  |  |
| 18 | LY-LB-18 | Home — Judul "Pasien Anda" | Label Name | Cek section header daftar pasien | Menampilkan "Pasien Anda" dengan font 24px, weight 600. |  |  |
| 19 | LY-LB-19 | Home — Label Tombol "Filter" | Label Name | Cek teks tombol filter | Menampilkan "Filter" dengan ikon filter_list. |  |  |
| 20 | LY-LB-20 | Home — Nama Pasien & Usia | Label Name | Cek teks nama dan usia pada kartu pasien | Menampilkan nama pasien (misal: "Ibu Siti") dan usia (misal: "55 Tahun"). |  |  |
| 21 | LY-LB-21 | Home — Badge Status "NORMAL" / "PERHATIAN" | Label Name | Cek teks status pada kartu pasien | Status "NORMAL" background hijau, "PERHATIAN" background abu-abu. |  |  |
| 22 | LY-LB-22 | Dashboard — Judul "Data Kesehatan" | Label Name | Cek judul di AppBar | Menampilkan "Data Kesehatan" di AppBar. |  |  |
| 23 | LY-LB-23 | Dashboard — Nama Pasien | Label Name | Cek nama pasien di header | Menampilkan nama pasien (misal: "Ibu Siti") dengan font 32px. |  |  |
| 24 | LY-LB-24 | Dashboard — Label Usia & Gender | Label Name | Cek teks usia dan gender | Format "55 Tahun • Perempuan". |  |  |
| 25 | LY-LB-25 | Dashboard — Badge Status "NORMAL" | Label Name | Cek badge status di dashboard | Menampilkan badge "NORMAL" dengan dot hijau. |  |  |
| 26 | LY-LB-26 | Dashboard — Judul "Tren Kesehatan" | Label Name | Cek judul kartu grafik | Menampilkan "Tren Kesehatan" dengan font 24px. |  |  |
| 27 | LY-LB-27 | Dashboard — Label Metrik (Kolesterol, Tensi, dll) | Label Name | Cek teks nama metrik kesehatan | Setiap kartu menampilkan nama metrik (Kolesterol, Tensi, Asam Urat, Gula Darah, Suhu, Detak Jantung, Saturasi, Berat Badan). |  |  |
| 28 | LY-LB-28 | Dashboard — Label Navigasi Bawah | Label Name | Cek teks bottom nav: Home, Calendar, medical, Person | Item aktif menampilkan label, item non-aktif hanya ikon. |  |  |
| 29 | LY-LB-29 | Log Kesehatan — Judul "Isi Data Kesehatan" | Label Name | Cek judul di AppBar | Menampilkan "Isi Data Kesehatan". |  |  |
| 30 | LY-LB-30 | Log Kesehatan — Judul "Data Kesehatan" | Label Name | Cek judul konten | Menampilkan "Data Kesehatan" dengan font 21px. |  |  |
| 31 | LY-LB-31 | Log Kesehatan — Label Nama Vital Sign | Label Name | Cek setiap label vital (Kolesterol, Tensi, Asam Urat, dll) | Menampilkan label yang sesuai dengan ikon masing-masing. |  |  |
| 32 | LY-LB-32 | Log Kesehatan — Label "Catatan" | Label Name | Cek label field catatan | Menampilkan teks "Catatan". |  |  |
| 33 | LY-LB-33 | Log Kesehatan — Tombol "Simpan Data Kesehatan" | Label Name | Cek teks tombol simpan | Menampilkan "Simpan Data Kesehatan" dengan background hitam (#192126). |  |  |
| 34 | LY-LB-34 | Calendar — Judul "CareTrack" | Label Name | Cek judul AppBar | Menampilkan "CareTrack" di AppBar. |  |  |
| 35 | LY-LB-35 | Calendar — Label Hari (WED, THU, FRI, dll) | Label Name | Cek teks hari di date picker | Menampilkan singkatan hari (WED/THU/FRI/SAT/SUN) dengan nomor tanggal. |  |  |
| 36 | LY-LB-36 | Calendar — Judul "Tambah Kegiatan" | Label Name | Cek judul bottom sheet | Menampilkan "Tambah Kegiatan" saat FAB ditekan. |  |  |
| 37 | LY-LB-37 | Calendar — Opsi Bottom Sheet | Label Name | Cek teks opsi (Input Manual, Pilih dari Template, Rekomendasi AI) | Masing-masing menampilkan judul dan deskripsi singkat. |  |  |
| 38 | LY-LB-38 | Jadwal Lansia — Title "Jadwal Oleh Caregiver" | Label Name | Cek judul AppBar | Menampilkan "Jadwal Oleh Caregiver". |  |  |
| 39 | LY-LB-39 | Jadwal Lansia — Label Field | Label Name | Cek label "Nama Aktivitas", "Tipe", "Tanggal", "Waktu", "Mengulang" | Semua label muncul sesuai urutan. |  |  |
| 40 | LY-LB-40 | Jadwal Lansia — Teks "Pemberitahuan Alarm" | Label Name | Cek teks kartu notifikasi alarm | Menampilkan "Pemberitahuan Alarm" dan "Dapatkan pemberitahuan 15 menit sebelumnya". |  |  |
| 41 | LY-LB-41 | Jadwal Lansia — Tombol "Simpan Jadwal" | Label Name | Cek teks tombol | Menampilkan "Simpan Jadwal". |  |  |
| 42 | LY-LB-42 | Notifikasi — Judul "Notifikasi" | Label Name | Cek judul AppBar | Menampilkan "Notifikasi". |  |  |
| 43 | LY-LB-43 | Notifikasi — Nama Pengirim Notifikasi | Label Name | Cek teks header notifikasi | Menampilkan nama (misal: "Kritis - Oma Maria", "Semua Lansia", "Ibu Siti"). |  |  |
| 44 | LY-LB-44 | Profile — Judul "Profile Caregiver" | Label Name | Cek judul AppBar | Menampilkan "Profile Caregiver". |  |  |
| 45 | LY-LB-45 | Profile — Nama Caregiver & Email | Label Name | Cek teks nama dan email | Menampilkan nama caregiver (misal: "Sri Setyani") dan email di bawahnya. |  |  |
| 46 | LY-LB-46 | Profile — Menu Item | Label Name | Cek teks "Edit Profile", "Undang", "Log Out" | Semua menu muncul dengan ikon yang sesuai. |  |  |
| 47 | LY-LB-47 | Tambah Lansia — Judul "Tambah Lansia Baru" | Label Name | Cek judul AppBar | Menampilkan "Tambah Lansia Baru". |  |  |
| 48 | LY-LB-48 | Tambah Lansia — Section Title | Label Name | Cek judul section: "Informasi Dasar", "Latar Belakang Kesehatan", "Personal & Minat" | Ketiga section title muncul dengan font 20px, weight 600. |  |  |
| 49 | LY-LB-49 | Tambah Lansia — Label Field | Label Name | Cek label "Nama Lengkap", "Usia (Tahun)", "Jenis Kelamin", dll | Semua label field muncul dengan benar. |  |  |
| 50 | LY-LB-50 | Tambah Lansia — Tombol "Simpan Data" & "Batal" | Label Name | Cek teks tombol footer | Tombol "Simpan Data" dan link "Batal" muncul. |  |  |
| 51 | LY-LB-51 | Rekomendasi AI — Judul "Rekomendasi AI" | Label Name | Cek judul AppBar | Menampilkan "Rekomendasi AI". |  |  |
| 52 | LY-LB-52 | Rekomendasi AI — Tombol "Tambahkan ke Jadwal" | Label Name | Cek teks tombol pada kartu rekomendasi | Menampilkan "Tambahkan ke Jadwal" dengan ikon add_task. |  |  |
| 53 | LY-LB-53 | Patient Detail — Judul "Riwayat Kesehatan" | Label Name | Cek judul AppBar dan konten | AppBar: "Riwayat Kesehatan". Konten: "Riwayat Kesehatan" + deskripsi. |  |  |
| 54 | LY-LB-54 | Success Log — Judul "Data Berhasil Disimpan!" | Label Name | Cek teks sukses | Menampilkan "Data Berhasil Disimpan!" dengan font 24px, bold. |  |  |
| 55 | LY-LB-55 | Success Log — Label "STATUS KESEHATAN SAAT INI" | Label Name | Cek teks status card | Menampilkan "STATUS KESEHATAN SAAT INI" uppercase, kecil. |  |  |
| 56 | LY-LB-56 | Success Log — Tombol "Selesai" | Label Name | Cek teks tombol | Menampilkan "Selesai". |  |  |
| **B** | **Field Type Checking** |  |  |  |  |  |  |
| 57 | LY-FT-01 | Login — Input Email | Field Type | Cek jenis input email | Keyboard type: emailAddress. Placeholder "contoh@gmail.com". |  |  |
| 58 | LY-FT-02 | Login — Input Kata Sandi | Field Type | Cek jenis input password | Karakter tersembunyi (obscureText). Ada ikon toggle visibility. |  |  |
| 59 | LY-FT-03 | Login — Tombol "Masuk" | Field Type | Cek jenis elemen | Berupa ElevatedButton dengan border radius 30. |  |  |
| 60 | LY-FT-04 | Login — Tombol Google | Field Type | Cek jenis elemen | Berupa OutlinedButton dengan ikon Google. |  |  |
| 61 | LY-FT-05 | Register — Input Nama Lengkap | Field Type | Cek jenis input | Text field biasa, placeholder "Masukkan nama lengkap". |  |  |
| 62 | LY-FT-06 | Register — Input Email | Field Type | Cek jenis input email | Keyboard type: emailAddress. |  |  |
| 63 | LY-FT-07 | Register — Input Kata Sandi | Field Type | Cek jenis input password | Karakter tersembunyi, ada toggle visibility. Placeholder "Minimal 8 karakter". |  |  |
| 64 | LY-FT-08 | Register — Input Konfirmasi Password | Field Type | Cek jenis input | Karakter tersembunyi, ada toggle visibility. Placeholder "Ulangi kata sandi". |  |  |
| 65 | LY-FT-09 | Home — Search Bar | Field Type | Cek jenis elemen | Berupa Container (bukan TextFormField), dengan ikon search dan teks "Cari Pasien". |  |  |
| 66 | LY-FT-10 | Home — Kartu Pasien | Field Type | Cek jenis elemen | Berupa Container dengan GestureDetector, menampilkan foto, nama, usia, badge status, chevron. |  |  |
| 67 | LY-FT-11 | Home — FAB Tambah Lansia | Field Type | Cek jenis elemen | FloatingActionButton dengan ikon "+". |  |  |
| 68 | LY-FT-12 | Dashboard — Grafik Tren Kesehatan | Field Type | Cek jenis elemen grafik | Menggunakan fl_chart LineChart dengan garis hijau (#BBF246). |  |  |
| 69 | LY-FT-13 | Dashboard — Kartu Metrik | Field Type | Cek jenis elemen | GridView 2 kolom dengan Container, masing-masing berisi ikon, nilai, unit. |  |  |
| 70 | LY-FT-14 | Dashboard — Dropdown Filter Tren | Field Type | Cek jenis elemen | DropdownButton dengan opsi "7 Hari" dan "30 Hari". |  |  |
| 71 | LY-FT-15 | Dashboard — Bottom Navigation Bar | Field Type | Cek jenis navigasi | Custom Container dengan Row, 4 item (Home, Calendar, medical, Person). |  |  |
| 72 | LY-FT-16 | Log Kesehatan — Input Vital Sign | Field Type | Cek jenis input angka | TextField dengan keyboard numerik, dilengkapi satuan (mg/dL, mmHg, °C, dll). |  |  |
| 73 | LY-FT-17 | Log Kesehatan — Input Catatan | Field Type | Cek jenis input | TextFormField multiline (4 baris) untuk catatan. |  |  |
| 74 | LY-FT-18 | Calendar — Date Picker Horizontal | Field Type | Cek jenis elemen | Row horizontal tanggal dengan Container per hari, ada yang aktif (black) dan non-aktif (hijau). |  |  |
| 75 | LY-FT-19 | Calendar — Kartu Jadwal | Field Type | Cek jenis elemen | Container dengan Row: ikon, judul, durasi, waktu, radio button/check. |  |  |
| 76 | LY-FT-20 | Calendar — FAB Tambah Kegiatan | Field Type | Cek jenis elemen | FloatingActionButton hitam dengan ikon "+". |  |  |
| 77 | LY-FT-21 | Calendar — Bottom Sheet | Field Type | Cek jenis elemen | BottomSheet dengan 3 opsi (Input Manual, Template, Rekomendasi AI). |  |  |
| 78 | LY-FT-22 | Jadwal Lansia — Input Field | Field Type | Cek jenis input | Container dengan Row (teks hint + ikon), bukan TextFormField. |  |  |
| 79 | LY-FT-23 | Jadwal Lansia — Chip Tipe Aktivitas | Field Type | Cek jenis elemen | Wrap dengan chip yang bisa dipilih (Medis, Pemeriksaan, Aktivitas). |  |  |
| 80 | LY-FT-24 | Jadwal Lansia — Switch Alarm | Field Type | Cek jenis elemen | Custom switch Container hijau dengan circle putih. |  |  |
| 81 | LY-FT-25 | Notifikasi — Kartu Notifikasi | Field Type | Cek jenis elemen | Container dengan background gelap (#384046), border merah untuk kritis. |  |  |
| 82 | LY-FT-26 | Profile — Foto Profil | Field Type | Cek jenis elemen | Container lingkaran 96px dengan Stack kamera di pojok. |  |  |
| 83 | LY-FT-27 | Profile — Menu List | Field Type | Cek jenis elemen | Container putih dengan Column berisi InkWell items. |  |  |
| 84 | LY-FT-28 | Profile — Tombol Logout | Field Type | Cek jenis elemen | Container hitam dengan Row (ikon logout + teks "Log Out"). |  |  |
| 85 | LY-FT-29 | Tambah Lansia — Upload Foto | Field Type | Cek jenis elemen | GestureDetector dengan Container lingkaran, ikon kamera, teks "Unggah Foto Profil". |  |  |
| 86 | LY-FT-30 | Tambah Lansia — Radio Button | Field Type | Cek jenis elemen | Custom chip selectable (bukan RadioButton bawaan Flutter). |  |  |
| 87 | LY-FT-31 | Tambah Lansia — Input Multiline | Field Type | Cek jenis input | TextFormField maxLines: 3 untuk riwayat medis dan minat hobi. |  |  |
| 88 | LY-FT-32 | Patient Detail — Timeline Card | Field Type | Cek jenis elemen | TimelineCard dengan ikon, nilai, dan waktu. |  |  |
| 89 | LY-FT-33 | Success Log — Ikon Sukses | Field Type | Cek jenis elemen | Container lingkaran 100px, background hijau muda, ikon check_circle hijau. |  |  |
| 90 | LY-FT-34 | Success Log — Status Badge | Field Type | Cek jenis elemen | Container hijau (#BBF246) dengan ikon sentiment dan teks "Normal". |  |  |
| 91 | LY-FT-35 | Splash — Logo | Field Type | Cek jenis elemen | Container lingkaran putih 120px dengan ikon eco hijau. |  |  |
| **C** | **Coloring & Styling** |  |  |  |  |  |  |
| 92 | LY-CL-01 | Global — Warna Brand Utama | Color Branding | Cek kode warna | Warna utama: #192126 (hitam kebiruan) dan #BBF246 (hijau neon). |  |  |
| 93 | LY-CL-02 | Global — Background Halaman | Color Branding | Cek background tiap halaman | Login/Register: putih (#FFFFFF). Home: #FDF8F8. Dashboard/Log/Notif: #FAFAFA. |  |  |
| 94 | LY-CL-03 | Splash — Background Biru Melengkung | Color Branding | Cek warna dan bentuk | Container #192126 dengan border radius besar (800). |  |  |
| 95 | LY-CL-04 | Login — Tombol "Masuk" | Color Branding | Cek warna tombol | Background #BBF246, teks hitam. Border radius 30. |  |  |
| 96 | LY-CL-05 | Login — Border Input Fokus | Color Branding | Cek warna border saat fokus | Berubah menjadi #A5F482 saat field aktif. |  |  |
| 97 | LY-CL-06 | Register — Tombol "Daftar Sekarang" | Color Branding | Cek warna tombol | Background #BBF246, teks hitam. Border radius 30. |  |  |
| 98 | LY-CL-07 | Home — FAB Tambah | Color Branding | Cek warna FAB | Background #18181B (hitam) dengan ikon putih. |  |  |
| 99 | LY-CL-08 | Home — Badge Status | Color Branding | Cek warna badge | NORMAL: background #BBF246, dot hijau. PERHATIAN: background #E4E4E7, dot hitam. |  |  |
| 100 | LY-CL-09 | Dashboard — Grafik Area | Color Branding | Cek warna line chart | Line: #BBF246, area fill: #BBF246 dengan alpha 0.2. |  |  |
| 101 | LY-CL-10 | Dashboard — FAB | Color Branding | Cek warna FAB | Background hitam, ikon putih. Border radius 16. |  |  |
| 102 | LY-CL-11 | Dashboard — Bottom Nav | Color Branding | Cek warna navigasi bawah | Background #192126, item aktif: #BBF246 dengan label. |  |  |
| 103 | LY-CL-12 | Log Kesehatan — Warna Ikon Vital | Color Branding | Cek warna ikon per vital | Kolesterol: #E88B63, Tensi: #6A9963, Gula Darah: #D35555, dll. |  |  |
| 104 | LY-CL-13 | Calendar — Tanggal Aktif | Color Branding | Cek warna tanggal terpilih | Container hitam dengan teks putih. |  |  |
| 105 | LY-CL-14 | Calendar — Tanggal Non-Aktif | Color Branding | Cek warna tanggal lain | Container #BBF246 dengan teks hitam. |  |  |
| 106 | LY-CL-15 | Notifikasi — Kartu Kritis | Color Branding | Cek border notifikasi kritis | Border merah (#EF4444) dengan teks judul merah. |  |  |
| 107 | LY-CL-16 | Notifikasi — Dot Notifikasi | Color Branding | Cek warna dot | Normal: #BBF246. Kritis: #EF4444. |  |  |
| 108 | LY-CL-17 | Profile — Tombol Logout | Color Branding | Cek warna tombol logout | Background #192126, teks dan ikon putih. |  |  |
| 109 | LY-CL-18 | Tambah Lansia — Radio Terpilih | Color Branding | Cek warna chip aktif | Informasi Dasar: #192126 teks putih. Kesehatan: #BBF246 teks hitam. |  |  |
| 110 | LY-CL-19 | Tambah Lansia — Background Input | Color Branding | Cek warna field input | Fill color #F7F3F2 (krem) dengan border #C8C5CB. |  |  |
| 111 | LY-CL-20 | Jadwal Lansia — Chip Tipe Terpilih | Color Branding | Cek warna chip aktif | Background #192126 dengan teks dan ikon putih. |  |  |
| 112 | LY-CL-21 | Jadwal Lansia — Switch ON | Color Branding | Cek warna switch alarm | Background #BBF246 dengan thumb putih. |  |  |
| 113 | LY-CL-22 | Success Log — Kartu Status | Color Branding | Cek warna status card | Background #F9F9F9, border #E5E5E5. Badge #BBF246. |  |  |
| **D** | **Placeholder & Information** |  |  |  |  |  |  |
| 114 | LY-PH-01 | Login — Placeholder Email | Placeholder | Cek teks di dalam field email | Menampilkan "contoh@gmail.com". |  |  |
| 115 | LY-PH-02 | Login — Placeholder Password | Placeholder | Cek teks di dalam field password | Menampilkan "****************". |  |  |
| 116 | LY-PH-03 | Register — Placeholder Nama | Placeholder | Cek teks di field nama | Menampilkan "Masukkan nama lengkap". |  |  |
| 117 | LY-PH-04 | Register — Placeholder Password | Placeholder | Cek teks di field password | Menampilkan "Minimal 8 karakter". |  |  |
| 118 | LY-PH-05 | Register — Placeholder Konfirmasi | Placeholder | Cek teks di field konfirmasi | Menampilkan "Ulangi kata sandi". |  |  |
| 119 | LY-PH-06 | Home — Search Placeholder | Placeholder | Cek placeholder search bar | Menampilkan "Cari Pasien" dengan ikon search. |  |  |
| 120 | LY-PH-07 | Log Kesehatan — Placeholder Vital | Placeholder | Cek nilai default tiap vital | Contoh: Kolesterol "180", Tensi "120/80", Gula Darah "98.6", dst. |  |  |
| 121 | LY-PH-08 | Log Kesehatan — Placeholder Catatan | Placeholder | Cek teks di field catatan | Menampilkan "Ada catatan atau keluhan tambahan hari ini?" |  |  |
| 122 | LY-PH-09 | Jadwal Lansia — Placeholder Aktivitas | Placeholder | Cek teks di field nama aktivitas | Menampilkan "Contoh: Jalan Pagi, Minum Obat". |  |  |
| 123 | LY-PH-10 | Jadwal Lansia — Placeholder Tanggal | Placeholder | Cek teks field tanggal | Menampilkan "mm/dd/yyyy". |  |  |
| 124 | LY-PH-11 | Jadwal Lansia — Placeholder Waktu | Placeholder | Cek teks field waktu | Menampilkan "09:00 AM". |  |  |
| 125 | LY-PH-12 | Jadwal Lansia — Placeholder Ulang | Placeholder | Cek teks field repeat | Menampilkan "Sekali". |  |  |
| 126 | LY-PH-13 | Tambah Lansia — Placeholder Nama | Placeholder | Cek teks field nama | Menampilkan "Masukkan nama lengkap". |  |  |
| 127 | LY-PH-14 | Tambah Lansia — Placeholder Usia | Placeholder | Cek teks field usia | Menampilkan "Contoh: 75". |  |  |
| 128 | LY-PH-15 | Tambah Lansia — Placeholder Riwayat Medis | Placeholder | Cek teks field riwayat | Menampilkan "contoh: hipertensi, diabetes". |  |  |
| 129 | LY-PH-16 | Tambah Lansia — Placeholder Minat | Placeholder | Cek teks field minat | Menampilkan "contoh: musik, berkebun, membaca". |  |  |
| 130 | LY-PH-17 | Tambah Lansia — Info Tooltip | Information | Cek teks informasi | Menampilkan "Digunakan untuk rekomendasi aktivitas AI." dengan ikon info. |  |  |
| 131 | LY-PH-18 | Log Kesehatan — Info Pasien & Tanggal | Information | Cek kartu info pasien | Menampilkan hari, tanggal, dan nama pasien di bagian atas form. |  |  |
| 132 | LY-PH-19 | Calendar — Deskripsi Bottom Sheet | Information | Cek teks deskripsi | Menampilkan "Pilih metode penambahan kegiatan untuk jadwal hari ini." |  |  |
| 133 | LY-PH-20 | Rekomendasi AI — Info Analisis | Information | Cek teks header | Menampilkan "Dianalisis dari data kesehatan dan aktivitas kemarin". |  |  |
| 134 | LY-PH-21 | Success Log — Deskripsi | Information | Cek teks penjelasan | Menampilkan "Data kesehatan lansia telah berhasil dicatat ke dalam sistem..." |  |  |
| 135 | LY-PH-22 | Jadwal Lansia — Info Alarm | Information | Cek teks penjelasan alarm | Menampilkan "Dapatkan pemberitahuan 15 menit sebelumnya". |  |  |

### **3. Panduan Pengisian (Untuk Mahasiswa)**

Agar hasil pengujian objektif, berikan panduan berikut kepada mahasiswa:

1. **ID Test:** Gunakan penamaan unik. Contoh: LY (Layout), LB (Label), FT (Field Type), CL (Color), PH (Placeholder).
2. **Item Name:** Sebutkan elemen UI secara spesifik (misal: Button 'Masuk', Icon 'Search', Label 'Email').
3. **Kategori Pengecekan:**
   - **Label Name:** Apakah teksnya typo? Apakah kapitalisasinya sudah benar? Apakah sesuai desain Figma?
   - **Field Type:** Apakah tombol benar-benar tombol? Apakah input teks sudah benar tipenya (email/number/text)?
   - **Coloring & Styling:** Apakah kontrasnya cukup? Apakah kode warna sesuai palet (#192126 / #BBF246)?
   - **Placeholder & Information:** Apakah ada teks bantuan di dalam kotak input? Apakah pesan informatif muncul?
4. **Status:**
   - **OK:** Jika tampilan 100% sama dengan desain.
   - **NG (No Good):** Jika ada perbedaan (typo, warna salah, layout berantakan).
5. **Evidence:** Wajib melampirkan _screenshot_ perbandingan antara desain (Figma) vs aplikasi nyata.

### **4. Cakupan Alignment & Layout**

Kolom tambahan untuk mengecek alignment dasar secara manual:

| ID Test | Halaman | Item | Cek Alignment | Hasil |
| :-----: | :-----: | :--: | :-----------: | :---: |
| LY-AL-01 | Login | Form field | Field rata kiri, label di atas field | |
| LY-AL-02 | Login | Tombol "Masuk" | Full width, rata tengah | |
| LY-AL-03 | Login | Separator "or" | Tengah horizontal dengan garis di kiri-kanan | |
| LY-AL-04 | Home | Kartu pasien | Rata kiri dengan foto, info, badge, chevron | |
| LY-AL-05 | Home | Kartu statistik (2 kolom) | Grid 2 kolom sama lebar (Expanded) | |
| LY-AL-06 | Dashboard | Grid metrik | Grid 2 kolom dengan jarak 12px | |
| LY-AL-07 | Dashboard | Bottom nav | Rata tengah, item aktif lebih lebar | |
| LY-AL-08 | Log Kesehatan | Row vital sign | Ikon kiri, nilai kanan, unit rata kanan | |
| LY-AL-09 | Calendar | Date picker | Horizontal scroll, item lebar minimal 64px | |
| LY-AL-10 | Profile | Foto profil | Tengah, stack kamera di pojok kanan bawah | |
| LY-AL-11 | Tambah Lansia | Radio button chip | Wrap rapi, jarak 8px antar chip | |
| LY-AL-12 | Notifikasi | Kartu notifikasi | Full width, padding 20px horizontal | |

### **5. Cek Responsive (Mobile & Desktop)**

| ID Test | Halaman | Resolusi | Prosedur | Hasil |
| :-----: | :-----: | :------: | :------: | :---: |
| LY-RS-01 | Semua halaman | 360×640 (Mobile S) | Tidak ada overflow, scroll vertikal berfungsi | |
| LY-RS-02 | Semua halaman | 375×812 (iPhone X) | Layout tidak terpotong, padding konsisten | |
| LY-RS-03 | Semua halaman | 414×896 (iPhone 11) | Tampilan proporsional, font tidak terlalu kecil | |
| LY-RS-04 | Semua halaman | 390×844 (iPhone 14) | Elemen tidak saling bertumpuk | |
| LY-RS-05 | Semua halaman | 600×1024 (Tablet 7") | Layout masih rapi, tidak ada gap berlebihan | |
| LY-RS-06 | Dashboard | 360×640 | Grafik dan grid metrik tidak overflow | |
| LY-RS-07 | Log Kesehatan | 360×640 | Form vital sign tidak terpotong | |
| LY-RS-08 | Calendar | 360×640 | Date picker horizontal scroll berfungsi | |

### **6. Tips Tambahan:**

- Jika proyek _capstone_ menggunakan desain responsif, tambahkan satu kolom atau baris khusus untuk melakukan pengecekan pada **Resolusi Layar** yang berbeda (Mobile vs Desktop) untuk memastikan elemen tidak saling bertumpuk (_overlapping_).
- Gunakan Flutter Inspector / DevTools untuk memverifikasi ukuran, padding, dan warna secara presisi.
- Pastikan font "Plus Jakarta Sans" dan "Lato" telah terdaftar di proyek agar tidak fallback ke font default.
- Perhatikan konsistensi border radius: input 30, kartu 24/16/12, chip 9999 (pill).
- Shadow dan elevation harus konsisten — cek BoxShadow offset dan blurRadius.
- Test pada mode terang (light mode) saja karena aplikasi belum mendukung dark mode.

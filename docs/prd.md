## Product Requirements Document

## _Aplikasi Pemandu Caregiver untuk Monitoring, Manajemen Jadwal, dan Rekomendasi Aktivitas Lansia Berbasis AI_

| Document Owner  | Wahyu        |
| :-------------- | :----------- |
| Product Manager | Shasa        |
| Designer        | Shasa, Wahyu |
| Tech Lead       | Wahyu        |
| Developer       | Wahyu, Shasa |
| QA              | Shasa        |

1. ### Latar Belakang dan Tujuan

#### 1.1. Latar Belakang

- Jumlah lansia yang membutuhkan pendampingan terus meningkat, namun caregiver sering kali kesulitan memantau kondisi kesehatan banyak lansia sekaligus tanpa alat bantu yang terintegrasi.

- Pencatatan kesehatan lansia masih banyak dilakukan secara manual (buku catatan / spreadsheet), sehingga rawan terlewat, tidak konsisten, dan sulit dianalisis trennya.

- Rekomendasi aktivitas untuk lansia umumnya bersifat generik dan tidak mempertimbangkan kondisi fisik, riwayat penyakit, serta minat individu masing-masing lansia.

- Akses akun caregiver perlu lebih aman karena berisi data kesehatan lansia, sehingga diperlukan verifikasi identitas tambahan berbasis wajah saat registrasi dan login.

#### 1.2. Tujuan

- Memudahkan caregiver dalam memantau dan mencatat kondisi kesehatan harian dari banyak lansia sekaligus dalam satu platform.

- Meningkatkan kepatuhan jadwal minum obat dan rutinitas pemeriksaan melalui sistem pengingat otomatis.

- Menghadirkan rekomendasi aktivitas yang dipersonalisasi untuk setiap lansia menggunakan kecerdasan buatan (AI) berdasarkan data profil dan kondisi kesehatan.

- Meningkatkan keamanan autentikasi caregiver melalui pendaftaran dan verifikasi wajah berbasis _face recognition_.

2. ### _Success Metrics_

- \[Main\] Tingkat kepatuhan pencatatan kesehatan harian oleh caregiver (target: ≥80% lansia tercatat setiap hari)

- \[Secondary\] Persentase alarm pengingat yang ditindaklanjuti tepat waktu oleh caregiver

- \[Secondary\] Tingkat adopsi fitur rekomendasi aktivitas AI (persentase rekomendasi yang di-approve dan dimasukkan ke jadwal)

- \[Secondary\] Tingkat keberhasilan verifikasi wajah caregiver saat login (target: ≥95% login valid berhasil diverifikasi)

3. ### _Requirements_ (Kebutuhan) Aplikasi

#### 3.1 Daftar _Requirement_

| Kode _Requirement_             | _Requirement_                                                                                                                                          |
| :----------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Auth & Onboarding**          |                                                                                                                                                        |
| REQ-001                        | Pengguna dapat mendaftar sebagai _Caregiver_ menggunakan email, kata sandi, verifikasi OTP email satu kali, registrasi wajah, serta _login_ menggunakan email, kata sandi, dan verifikasi wajah |
| REQ-002                        | _Caregiver_ yang telah _login_ dapat membuat profil lansia baru yang berisi usia, riwayat penyakit, kondisi fisik, mobilitas, dan minat/hobi           |
| REQ-003                        | _Caregiver_ dapat membuat lebih dari satu profil lansia dalam satu akun                                                                                |
| **Pencatatan Kesehatan**       |                                                                                                                                                        |
| REQ-004                        | _Caregiver_ dapat memilih lansia mana yang akan dicatat kondisi kesehatannya                                                                           |
| REQ-005                        | _Caregiver_ dapat mengisi parameter kesehatan harian lansia yang meliputi: tekanan darah, gula darah, detak jantung, suhu tubuh, dan berat badan       |
| REQ-006                        | _Caregiver_ dapat menambahkan catatan harian dan keluhan pada setiap sesi pencatatan kesehatan                                                         |
| REQ-007                        | Sistem dapat menandai kondisi lansia dengan status: **Normal** atau **Perlu Perhatian**                                                                |
| **Dashboard & Tren Kesehatan** |                                                                                                                                                        |
| REQ-008                        | _Caregiver_ dapat melihat semua lansia yang dikelola dalam satu tampilan ringkasan (_overview_)                                                        |
| REQ-009                        | _Caregiver_ dapat masuk ke halaman detail per lansia untuk melihat grafik tren per parameter kesehatan dalam rentang 7 hari atau 30 hari               |
| REQ-010                        | _Caregiver_ dapat melihat riwayat catatan kesehatan lengkap per lansia                                                                                 |
| **Jadwal & Alarm Pengingat**   |                                                                                                                                                        |
| REQ-013                        | _Caregiver_ dapat membuat jadwal per lansia yang mencakup: jadwal minum obat, pemeriksaan rutin, dan aktivitas harian                                  |
| REQ-014                        | Setiap jadwal yang dibuat dapat dilengkapi dengan alarm notifikasi pengingat                                                                           |
| REQ-015                        | Sistem secara otomatis memberi notifikasi alarm kepada _caregiver_ apabila parameter kesehatan lansia melampaui ambang batas (_threshold_) normal      |
| **Rekomendasi Aktivitas AI**   |                                                                                                                                                        |
| REQ-016                        | Sistem AI dapat membaca data profil onboarding lansia dan menghasilkan rekomendasi aktivitas yang sesuai (contoh: senam kursi, terapi musik, berkebun) |
| REQ-017                        | _Caregiver_ dapat melihat daftar rekomendasi aktivitas AI per lansia                                                                                   |
| REQ-018                        | _Caregiver_ dapat meng-_approve_ rekomendasi aktivitas, sehingga aktivitas tersebut otomatis masuk ke jadwal lansia yang bersangkutan                  |
| **Notifikasi**                 |                                                                                                                                                        |
| REQ-019                        | Sistem mengirimkan notifikasi kepada _caregiver_ ketika data kesehatan baru dicatat                                                                    |
| REQ-020                        | Sistem mengirimkan notifikasi kepada _caregiver_ ketika kondisi lansia ditandai sebagai **Kritis**                                                     |
| REQ-021                        | Sistem mengirimkan ringkasan mingguan kondisi lansia kepada _caregiver_                                                                                |

    3.2 Fitur di Luar Ruang Lingkup

- Semua komponen di _header_

- _Login_ di luar alur email/kata sandi dan verifikasi wajah

- _Third-party system_ selain penyedia email OTP

  3.3 _Functional Requirements_ (Kebutuhan Fungsional)

| _Requirement_                                                                                                                                     | Spesifikasi                                                                                                                                                                                                                                                                                                     |
| :------------------------------------------------------------------------------------------------------------------------------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Auth & Onboarding**                                                                                                                             |                                                                                                                                                                                                                                                                                                                 |
| Pengguna dapat mendaftar sebagai _Caregiver_ menggunakan email, kata sandi, OTP email satu kali, registrasi wajah, serta _login_ menggunakan email, kata sandi, dan verifikasi wajah | Alur registrasi: (1) Pengguna mengirim email dan kata sandi. (2) Sistem memvalidasi format email dan kecocokan kata sandi. (3) Sistem membuat akun caregiver dengan status email belum terverifikasi. (4) Sistem membuat OTP 6 digit, menyimpannya dengan masa berlaku beberapa menit, dan mengirimkannya ke email caregiver. (5) Pengguna mengirim email dan OTP ke endpoint verifikasi. (6) Jika OTP valid dan belum kedaluwarsa, sistem menandai email sebagai terverifikasi. (7) Caregiver melakukan registrasi wajah dengan mengambil foto wajah. (8) InsightFace mendeteksi wajah pada foto. (9) Model membuat _embedding_ wajah. (10) Sistem menyimpan _embedding_ sebagai data wajah caregiver dan akun menjadi aktif. Foto wajah hanya digunakan untuk proses deteksi dan pembuatan _embedding_. Jika wajah tidak terdeteksi atau lebih dari satu wajah terdeteksi, sistem meminta caregiver mengambil ulang foto. Alur _login_: (1) _Caregiver_ yang emailnya sudah terverifikasi mengirim email dan kata sandi. (2) Jika kredensial valid dan akun aktif, caregiver mengambil foto wajah. (3) InsightFace mendeteksi wajah pada foto login. (4) Model membuat _embedding_ wajah login. (5) Sistem membandingkan _embedding_ register dan _embedding_ login menggunakan nilai similarity. (6) Jika similarity melewati threshold, sistem mengembalikan token autentikasi dan login berhasil. (7) Jika similarity tidak melewati threshold, login ditolak. OTP digunakan hanya saat registrasi untuk memastikan email caregiver valid dan tidak dikirim saat _login_ normal. |
| _Caregiver_ yang telah _login_ dapat membuat profil lansia baru yang berisi usia, riwayat penyakit, kondisi fisik, mobilitas, dan minat/hobi      | Pengguna dapat mengakses form "Tambah Lansia". Komponen pada form meliputi: \- Text field Nama Lansia \- Dropdown/Text field Usia \- Text area Riwayat Penyakit \- Dropdown Kondisi Fisik \- Dropdown Mobilitas \- Text field/Tags Minat & Hobi \- Button "Simpan"                                              |
| _Caregiver_ dapat membuat lebih dari satu profil lansia dalam satu akun                                                                           | Pada halaman beranda, pengguna dapat melihat daftar lansia yang telah ditambahkan. Terdapat tombol "Tambah Lansia" yang selalu tersedia untuk menambahkan profil lansia lainnya.                                                                                                                                |
| **Pencatatan Kesehatan**                                                                                                                          |                                                                                                                                                                                                                                                                                                                 |
| _Caregiver_ dapat memilih lansia mana yang akan dicatat kondisi kesehatannya                                                                      | Sistem menampilkan daftar _card_ lansia. Pengguna dapat mengklik salah satu _card_ lansia untuk masuk ke halaman detail dan memulai pencatatan kesehatan untuk lansia tersebut.                                                                                                                                 |
| _Caregiver_ dapat mengisi parameter kesehatan harian lansia yang meliputi: tekanan darah, gula darah, detak jantung, suhu tubuh, dan berat badan  | Pada halaman detail lansia, terdapat fitur "Catat Kesehatan Harian". Komponen form meliputi: \- Input numerik Tekanan Darah (Sistolik/Diastolik) \- Input numerik Gula Darah \- Input numerik Detak Jantung (BPM) \- Input numerik Suhu Tubuh (°C) \- Input numerik Berat Badan (kg) \- Button "Simpan Catatan" |
| _Caregiver_ dapat menambahkan catatan harian dan keluhan pada setiap sesi pencatatan kesehatan                                                    | Pada form "Catat Kesehatan Harian", terdapat komponen _Text area_ opsional untuk mengisi catatan tambahan atau keluhan yang dialami lansia pada hari tersebut.                                                                                                                                                  |
| Sistem dapat menandai kondisi lansia dengan status: **Normal** atau **Perlu Perhatian**                                                           | Sistem secara otomatis menganalisis input parameter kesehatan. Jika input berada di luar ambang batas normal, sistem akan memberikan label status **Perlu Perhatian** berwarna merah/jingga. Jika normal, diberi label **Normal** berwarna hijau.                                                               |
| **Dashboard & Tren Kesehatan**                                                                                                                    |                                                                                                                                                                                                                                                                                                                 |
| _Caregiver_ dapat melihat semua lansia yang dikelola dalam satu tampilan ringkasan (_overview_)                                                   | Halaman Beranda (_Dashboard_) menampilkan ringkasan semua lansia dalam bentuk _card_ atau _list_. Setiap \*card\* menampilkan: \- Nama Lansia \- Usia \- Status Kesehatan Terakhir (Normal/Perlu Perhatian) \- Pembaruan Terakhir                                                                               |
| _Caregiver_ dapat masuk ke halaman detail per lansia untuk melihat grafik tren per parameter kesehatan dalam rentang 7 hari atau 30 hari          | Halaman Detail Lansia memiliki tab "Tren Kesehatan". Menampilkan visualisasi grafik _line chart_ untuk masing-masing parameter (Tekanan Darah, Gula Darah, dll.). Terdapat filter rentang waktu "7 Hari Terakhir" dan "30 Hari Terakhir".                                                                       |
| _Caregiver_ dapat melihat riwayat catatan kesehatan lengkap per lansia                                                                            | Halaman Detail Lansia memiliki tab "Riwayat". Menampilkan daftar riwayat (_history log_) pencatatan kesehatan, diurutkan dari yang paling baru. Setiap entri riwayat dapat diklik untuk melihat detail lengkap.                                                                                                 |
| **Jadwal & Alarm Pengingat**                                                                                                                      |                                                                                                                                                                                                                                                                                                                 |
| _Caregiver_ dapat membuat jadwal per lansia yang mencakup: jadwal minum obat, pemeriksaan rutin, dan aktivitas harian                             | Fitur "Manajemen Jadwal". Pengguna dapat menambahkan jadwal baru dengan komponen: \- Judul Kegiatan \- Tipe Kegiatan (Dropdown: Obat/Pemeriksaan/Aktivitas) \- Tanggal & Waktu \- Frekuensi (Sekali/Harian/Mingguan) \- Button "Simpan Jadwal"                                                                  |
| Setiap jadwal yang dibuat dapat dilengkapi dengan alarm notifikasi pengingat                                                                      | Pada form penambahan jadwal, terdapat _toggle_ "Aktifkan Alarm". Jika diaktifkan, pengguna dapat mengatur waktu pengingat (contoh: Tepat waktu, 10 menit sebelumnya).                                                                                                                                           |
| Sistem secara otomatis memberi notifikasi alarm kepada _caregiver_ apabila parameter kesehatan lansia melampaui ambang batas (_threshold_) normal | Sistem mendeteksi parameter kesehatan yang tidak normal ("Perlu Perhatian") saat pencatatan dan langsung memicu _push notification_ / peringatan (_alert_) di dalam aplikasi kepada _Caregiver_.                                                                                                                |
| **Rekomendasi Aktivitas AI**                                                                                                                      |                                                                                                                                                                                                                                                                                                                 |
| Sistem AI dapat membaca data profil onboarding lansia dan menghasilkan rekomendasi aktivitas yang sesuai                                          | Sistem memiliki _backend processing_ (AI) yang menggunakan data (usia, penyakit, kondisi fisik, mobilitas, minat) untuk menghasilkan rekomendasi aktivitas fisik/kognitif.                                                                                                                                      |
| _Caregiver_ dapat melihat daftar rekomendasi aktivitas AI per lansia                                                                              | Pada halaman Detail Lansia, terdapat tab "Rekomendasi Aktivitas AI". Menampilkan _card_ aktivitas dengan komponen: \- Nama Aktivitas \- Deskripsi Singkat \- Estimasi Durasi \- Button "Lihat Detail" \- Button "Tambahkan ke Jadwal"                                                                           |
| _Caregiver_ dapat meng-_approve_ rekomendasi aktivitas, sehingga aktivitas tersebut otomatis masuk ke jadwal lansia yang bersangkutan             | Ketika _Caregiver_ mengklik button "Tambahkan ke Jadwal" pada _card_ rekomendasi, sistem menampilkan pop-up untuk mengatur waktu dan tanggal pelaksanaan, kemudian aktivitas tersebut tersimpan di jadwal lansia.                                                                                               |
| **Notifikasi**                                                                                                                                    |                                                                                                                                                                                                                                                                                                                 |
| Sistem mengirimkan notifikasi kepada _caregiver_ ketika data kesehatan baru dicatat                                                               | _Push notification_ dan/atau notifikasi di dalam aplikasi terkirim otomatis setiap kali catatan kesehatan harian yang baru disubmit.                                                                                                                                                                            |
| Sistem mengirimkan notifikasi kepada _caregiver_ ketika kondisi lansia ditandai sebagai **Kritis**                                                | _Push notification_ dengan prioritas tinggi (suara khusus/peringatan warna merah) dikirim jika kondisi parameter kesehatan dinilai sangat mengkhawatirkan/Kritis.                                                                                                                                               |
| Sistem mengirimkan ringkasan mingguan kondisi lansia kepada _caregiver_                                                                           | Sistem secara otomatis mem-_build_ laporan mingguan yang mencakup rata-rata parameter kesehatan dan tren, kemudian dikirimkan melalui notifikasi atau _Email_ pada akhir minggu.                                                                                                                                |

# LAPORAN QUALITY ASSURANCE (QA)

Capstone Project QA - Program Studi Teknik Informatika  
Tanggal Pengujian: 13 Juli 2026

# **1. Identitas Proyek**

Nama Aplikasi: Smart Caregiver (Aplikasi Pemandu Caregiver)  
Tim Pengembang: Kelompok 5  
Nama Mahasiswa: Wahyu Akhmad Fadillah, Alifia Shafa Shabrina  
Dosen Pembimbing: Dwi Intan Af’idah, S.T., M.Kom.  
Tanggal Uji: 13 Juli 2026

# **2. Deskripsi Sistem yang Diuji**

Smart Caregiver adalah aplikasi mobile yang membantu caregiver mengelola data lansia. Pada pengujian Katalon ini, bagian aplikasi yang diuji meliputi:

- **Halaman Login:** memvalidasi proses masuk menggunakan variasi data email, password, dan hasil yang diharapkan.
- **Halaman Tambah Lansia:** memvalidasi pengisian form data lansia menggunakan nama dan usia, pemilihan beberapa opsi pada form, serta proses penyimpanan data.

# **3. Tujuan dan Ruang Lingkup Pengujian**

**Tujuan:** Memastikan fitur login dan penambahan data lansia pada aplikasi Smart Caregiver dapat dijalankan dengan benar melalui pengujian otomatis menggunakan Katalon Studio.

**Ruang Lingkup:**

1. **Fitur Login:** Pengujian Data-Driven Testing (DDT) sebanyak 33 iterasi dengan variasi hasil login berhasil dan ditolak.
2. **Fitur Tambah Data Lansia:** Pengujian pengisian form data lansia dengan nama `siti` dan usia `60` sampai seluruh langkah otomatisasi selesai.

# **4. Karakteristik ISO/IEC 25010 yang Diuji**

- **Functional Suitability**

  Alasan pemilihan: memastikan fungsi login dan penambahan data lansia dapat dijalankan sesuai alur yang dibuat pada test case Katalon.

- **Usability**

  Alasan pemilihan: memastikan field input, tombol, pilihan pada form, dan fungsi penutupan keyboard dapat digunakan selama pengujian otomatis.

- **Reliability**

  Alasan pemilihan: memastikan aplikasi dapat menjalankan 33 iterasi login secara berturut-turut tanpa test case gagal atau error.

- **Compatibility**

  Alasan pemilihan: memastikan APK Smart Caregiver dapat dijalankan pada perangkat Samsung SM-M236L dengan Android 14.

# **5. Metodologi Pengujian**

Metode Pengujian: Automated Testing dan Data-Driven Testing (DDT).

Alat Bantu / Tools:

1. **Katalon Studio 11.3.0.0:** alat utama untuk menyusun dan menjalankan test case otomatis.
2. **Appium:** driver yang menghubungkan Katalon Studio dengan perangkat Android.
3. **Perangkat Android:** Samsung SM-M236L dengan Android 14.

Lingkungan Pengujian:

| Komponen       | Nilai                                                |
| :------------- | :--------------------------------------------------- |
| Host           | TravelMate - SASA                                    |
| Sistem Operasi | Windows 11 64-bit                                    |
| Katalon Studio | 11.3.0.0                                             |
| Platform       | Android                                              |
| Perangkat      | Samsung SM-M236L                                     |
| Versi Android  | Android 14                                           |
| APK            | `mobile/build/app/outputs/flutter-apk/app-debug.apk` |

Data Uji:

1. Data login dari sumber data Katalon bernama `login`, yang memiliki kolom `Email`, `Password`, dan `Expected`.
2. Data lansia dengan nama `siti` dan usia `60`.

# **6. Hasil Pengujian dan Evaluasi Kualitas**

## **6.1 Hasil Test Suite Login**

Test suite `TS_SUITE` menjalankan test case login sebanyak 33 iterasi.

| Metrik               |                      Hasil |
| :------------------- | -------------------------: |
| Total iterasi        |                         33 |
| Passed               |                         33 |
| Failed               |                          0 |
| Error                |                          0 |
| Incomplete           |                          0 |
| Skipped              |                          0 |
| Waktu mulai          | 12 Juli 2026, 18:22:56 WIB |
| Waktu selesai        | 12 Juli 2026, 18:41:22 WIB |
| Durasi               |      18 menit 26,195 detik |
| Persentase kelulusan |                       100% |

Alur pengujian login:

1. Membaca data `Email`, `Password`, dan `Expected` dari sumber data `login`.
2. Memvalidasi agar data email, password, dan hasil yang diharapkan tidak kosong.
3. Menjalankan proses login sesuai setiap baris data.
4. Memeriksa keberadaan elemen tujuan untuk menentukan kesesuaian hasil login.
5. Menutup aplikasi setelah setiap iterasi selesai.

Dari 33 iterasi, 30 iterasi menemukan elemen tujuan dan 3 iterasi tidak menemukan elemen tujuan sesuai skenario login negatif. Seluruh hasil aktual sesuai dengan nilai `Expected`, sehingga semua iterasi berstatus `PASSED`.

## **6.2 Hasil Test Suite Tambah Data Lansia**

Test suite `TS_CRUD` menjalankan satu test case penambahan data lansia yang terdiri dari 14 langkah.

| Metrik               |                      Hasil |
| :------------------- | -------------------------: |
| Total test case      |                          1 |
| Total langkah        |                         14 |
| Langkah passed       |                         14 |
| Failed               |                          0 |
| Error                |                          0 |
| Incomplete           |                          0 |
| Skipped              |                          0 |
| Waktu mulai          | 13 Juli 2026, 19:13:55 WIB |
| Waktu selesai        | 13 Juli 2026, 19:14:49 WIB |
| Durasi               |               54,587 detik |
| Persentase kelulusan |                       100% |

Alur pengujian tambah data lansia:

1. Menjalankan APK Smart Caregiver.
2. Menekan tombol untuk membuka halaman tambah data lansia.
3. Memilih field nama dan mengisi nilai `siti`.
4. Menutup keyboard.
5. Memilih field usia dan mengisi nilai `60`.
6. Menutup keyboard.
7. Menekan pilihan dan tombol lanjutan pada form.
8. Menyelesaikan alur test case dan menutup aplikasi.

Seluruh 14 langkah berhasil dijalankan dan berstatus `PASSED`.

## **6.3 Evaluasi Berdasarkan ISO/IEC 25010**

| Karakteristik ISO 25010 | Indikator Pengujian                                        | Hasil Uji | Evaluasi                                                                                        |
| :---------------------- | :--------------------------------------------------------- | :-------- | :---------------------------------------------------------------------------------------------- |
| Functional Suitability  | Fungsionalitas login dan pengisian form tambah data lansia | Passed    | Sebanyak 33 iterasi login dan 14 langkah pada test case tambah data lansia berhasil dijalankan. |
| Usability               | Interaksi dengan field, tombol, pilihan form, dan keyboard | Passed    | Seluruh objek yang digunakan pada alur otomatisasi dapat diakses dan dioperasikan.              |
| Reliability             | Eksekusi login berulang menggunakan 33 data uji            | Passed    | Seluruh iterasi selesai tanpa failed, error, incomplete, atau skipped.                          |
| Compatibility           | Eksekusi APK pada Samsung SM-M236L dengan Android 14       | Passed    | APK berhasil dijalankan dan kedua test suite dapat diselesaikan pada perangkat pengujian.       |

Secara keseluruhan terdapat 34 eksekusi test case, terdiri dari 33 iterasi login dan 1 test case tambah data lansia. Seluruhnya berstatus `PASSED`.

# **7. Rekomendasi Perbaikan**

1. Menggunakan nama object repository yang lebih jelas, seperti `login_button`, `patient_name_field`, `patient_age_field`, dan `save_patient_button`, agar test case lebih mudah dipelihara.
2. Menetapkan nilai timeout yang valid karena laporan HTML mencatat bahwa timeout `0` diganti oleh Katalon dengan timeout default `60` detik.
3. Menambahkan verifikasi pesan berhasil atau kemunculan data lansia setelah tombol simpan ditekan agar hasil penyimpanan dapat dipastikan oleh test case.
4. Memberikan nama berbeda pada data iteration login positif dan negatif agar hasil setiap skenario lebih mudah dibaca pada laporan.

# **8. Kesimpulan**

Berdasarkan hasil pengujian otomatis menggunakan Katalon Studio, fitur login dan alur penambahan data lansia pada aplikasi Smart Caregiver berhasil dijalankan pada Samsung SM-M236L dengan Android 14.

Test suite login menyelesaikan 33 iterasi dengan tingkat kelulusan 100%. Test suite tambah data lansia menyelesaikan 14 langkah dengan tingkat kelulusan 100%. Tidak ditemukan test case berstatus failed, error, incomplete, atau skipped pada kedua laporan.

Dengan demikian, fitur login dan tambah data lansia yang diuji dinyatakan **PASSED** pada lingkungan pengujian yang digunakan.

## **Bukti Hasil Pengujian**

- [Laporan Katalon Login - TS_SUITE](20260712_182245.pdf)
- [Laporan Katalon Tambah Data Lansia - TS_CRUD (PDF)](20260713_191344.pdf)
- [Laporan Katalon Tambah Data Lansia - TS_CRUD (HTML)](20260713_191344.html)

## **Ringkasan Status**

| Test Suite | Fitur              |  Total | Passed | Failed | Error | Status     |
| :--------- | :----------------- | -----: | -----: | -----: | ----: | :--------- |
| `TS_SUITE` | Login              |     33 |     33 |      0 |     0 | PASSED     |
| `TS_CRUD`  | Tambah data lansia |      1 |      1 |      0 |     0 | PASSED     |
| **Total**  |                    | **34** | **34** |  **0** | **0** | **PASSED** |

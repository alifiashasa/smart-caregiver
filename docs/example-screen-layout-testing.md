# **Template Screen Layout Testing – Capstone Project**

**Nama Proyek:** \[Isi Judul Capstone\]

**Modul/Halaman:** \[Contoh: Halaman Dashboard / Login / Vision Prediksi\]

**Dokumen Referensi:** \[Contoh: Figma v1.2 / PRD Rev 01\]

### **1\. Preconditions (Prasyarat)**

● Aplikasi telah berjalan di lingkungan pengujian (Local/Staging).  
● User sudah masuk ke halaman yang akan diuji.  
● Desain _high-fidelity_ (Figma/Adobe XD) tersedia sebagai pembanding.

### **2\. Tabel Pengujian Layout**

|  No   |            ID Test            |    Komponen / Item Name    | Kategori Pengecekan |    Prosedur / Kondisi     |                  Hasil yang Diharapkan                  | Status (OK/NG) | Evidence (Link/Nama File) |
| :---: | :---------------------------: | :------------------------: | ------------------- | :-----------------------: | :-----------------------------------------------------: | :------------: | :-----------------------: |
| **A** |    **Label Name Checking**    |                            |                     |                           |                                                         |                |                           |
|   1   |           LY-LB-01            | \[Contoh: Button Simpan\]  | Label Name          |   Cek teks pada tombol    |        Menampilkan teks "Simpan" sesuai desain.         |                |                           |
|   2   |           LY-LB-02            |  \[Contoh: Judul Header\]  | Label Name          |  Cek teks judul halaman   |   Menampilkan label "\[Nama Halaman\]" dengan benar.    |                |                           |
| **B** |    **Field Type Checking**    |                            |                     |                           |                                                         |                |                           |
|   3   |           LY-FT-01            | \[Contoh: Input Password\] | Field Type          |      Cek jenis input      |  Tipe field adalah 'password' (karakter tersembunyi).   |                |                           |
|   4   |           LY-FT-02            | \[Contoh: Logo Navigasi\]  | Field Type          |     Cek jenis elemen      |      Elemen berupa file gambar/logo (bukan teks).       |                |                           |
| **C** |    **Coloring & Styling**     |                            |                     |                           |                                                         |                |                           |
|   5   |           LY-CL-01            |     \[Contoh: Navbar\]     | Color Branding      |    Cek kode warna hex     | Warna background sesuai palet desain (misal: \#005088). |                |                           |
|   6   |           LY-CL-02            | \[Contoh: Button Submit\]  | Hover Effect        | Arahkan kursor ke tombol  | Warna berubah menjadi lebih gelap saat kursor _hover_.  |                |                           |
| **D** | **Placeholder & Information** |                            |                     |                           |                                                         |                |                           |
|   7   |           LY-PH-01            |   \[Contoh: Search Bar\]   | Placeholder         | Lihat teks di dalam field |    Menampilkan instruksi "Cari artefak di sini...".     |                |                           |
|   8   |           LY-PH-02            | \[Contoh: Error Message\]  | Visibility          |    Picu kondisi error     |  Pesan error muncul di bawah field dengan warna merah.  |                |                           |

###

###

###

### **3\. Panduan Pengisian (Untuk Mahasiswa)**

Agar hasil pengujian objektif, berikan panduan berikut kepada mahasiswa:

1\. **ID Test:** Gunakan penamaan unik. Contoh: LY (Layout), LB (Label), CL (Color).  
2\. **Item Name:** Sebutkan elemen UI secara spesifik (misal: Button 'Log In', Icon 'Home', Label 'Username').  
3\. **Kategori Pengecekan:**  
○ **Label Name:** Apakah teksnya typo? Apakah kapitalisasinya sudah benar?  
○ **Field Type:** Apakah tombol benar-benar tombol? Apakah input teks sudah benar tipenya (email/number/text)?  
○ **Coloring:** Apakah kontrasnya cukup? Apakah warna saat di-klik berubah?  
○ **Placeholder:** Apakah ada teks bantuan di dalam kotak input?  
4\. **Status:**  
○ **OK:** Jika tampilan 100% sama dengan desain.  
○ **NG (No Good):** Jika ada perbedaan (typo, warna salah, layout berantakan).  
5\. **Evidence:** Wajib melampirkan _screenshot_ perbandingan antara desain (Figma) vs aplikasi nyata.

### **4\. Tips Tambahan:**

Jika proyek _capstone_ menggunakan desain responsif, tambahkan satu kolom atau baris khusus untuk melakukan pengecekan pada **Resolusi Layar** yang berbeda (Mobile vs Desktop) untuk memastikan elemen tidak saling bertumpuk (_overlapping_).

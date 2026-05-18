# **Template Operation Testing – Capstone Project**

**Nama Proyek:** \[Judul Capstone\]

**Modul:** \[Contoh: Payment Gateway / Chatbot / CRUD Mahasiswa\]

**Tester:** \[Nama Mahasiswa\]

### **Tabel Pengujian Operasional (Functionality)**

|  ID Test  | Skenario (Scenario Name) | Jenis (+/-/Edge) |   Precondition (Prasyarat)   |                  Langkah Eksekusi (Steps)                   |       Data Uji (Test Data)        |                Hasil yang Diharapkan (Expected)                 | Status (OK/NG) |
| :-------: | :----------------------: | :--------------: | :--------------------------: | :---------------------------------------------------------: | :-------------------------------: | :-------------------------------------------------------------: | -------------- |
| **OP-01** |   Verify Login Success   |   Positif (+)    | User berada di halaman login | 1\. Input email valid 2\. Input pass valid 3\. Klik "Login" | Email: user@mail.com Pass: 123456 |           Sistem mengarahkan (redirect) ke Dashboard.           |                |
| **OP-02** |   Verify Login Failed    |   Negatif (-)    | User berada di halaman login |           1\. Input email salah 2\. Klik "Login"            |      Email: ngawur@mail.com       |        Muncul pesan error "Kredensial tidak ditemukan".         |                |
| **OP-03** |  Verify Form Submission  |   Positif (+)    |   Form input sudah terbuka   |         1\. Isi semua field 2\. Klik tombol Submit          |       \[Lihat Tabel Data\]        |     Data tersimpan ke database & muncul notifikasi sukses.      |                |
| **OP-04** |  Verify Redirect Button  |   Positif (+)    |     User di halaman Home     |                1\. Klik tombol "Pesan Tiket"                |                \-                 |       Sistem mengarahkan ke URL eksternal (Linktree/WA).        |                |
| **OP-05** |    Verify Empty Input    |   Negatif (-)    |      Form input kosong       |                  1\. Klik tombol "Submit"                   |                \-                 | Tombol tidak bereaksi atau muncul peringatan field wajib diisi. |                |

###

### **Glosarium Kolom**

1\. **Jenis Case (+/-/Edge):**  
○ **Positif (+):** Menguji alur normal (jalur sukses).  
○ **Negatif (-):** Sengaja memasukkan data salah untuk melihat apakah sistem bisa menolak dengan baik.  
○ **Edge:** Menguji nilai batas (misal: upload file tepat 2MB, atau input nama sangat panjang).  
2\. **Precondition:** Kondisi yang harus terpenuhi _sebelum_ langkah dilakukan (misal: "User sudah login", "Koneksi internet dimatikan").  
3\. **Langkah Eksekusi:** Urutan tindakan teknis (klik ini, ketik itu).

4\. **Data Uji:** Nilai spesifik yang dimasukkan. Jika datanya banyak, arahkan mahasiswa untuk merujuk ke tabel _Test Data_ tersendiri.  
5\. **Expected Result:** Respon sistem yang tertulis di PRD atau dijanjikan oleh pengembang.

###

### **Tips untuk Praktikum di Kelas:**

● **Jangan Hanya Jalur Hijau:** seorang QA yang hebat adalah yang mampu "merusak" aplikasi. Pastikan memiliki minimal 30% **Negatif Case** di dalam template ini.  
● **Status NG (No Good):** Jika statusnya NG, mahasiswa wajib melampirkan **Bug Report** atau mencatat di kolom _Remark_ kenapa tes tersebut gagal.  
● **Sinkronisasi PRD:** Pastikan setiap skenario di sini memiliki nomor referensi ke dokumen _Product Requirement Document_ agar tidak ada fitur yang terlewat diuji.

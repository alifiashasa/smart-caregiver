# **Template BDD Gherkin – Capstone Project**

**Nama Proyek:** \[Isi Judul Capstone Project\]

**Modul / Epic:** \[Contoh: Vision Prediksi / Chatbot / Tiketing\]

**Referensi PRD / User Story ID:** \[Contoh: US-01 / REQ-12\]

## **1\. Aturan Dasar Penulisan Gherkin (Sintaksis)**

● **Feature:** Penjelasan tingkat tinggi tentang fitur yang sedang dibangun (Format: _As a... I want to... So that..._).  
● **Scenario:** Skenario spesifik atau jalur alur kerja tertentu (Positif atau Negatif).  
● **Given:** Prasyarat awal atau kondisi sistem saat ini (_Preconditions_).  
● **When:** Aksi nyata atau trigger yang dilakukan oleh aktor/pengguna (_Actions_).  
● **Then:** Hasil akhir atau respon sistem yang diharapkan (_Expected Outcomes_).  
● **And / But:** Digunakan untuk menambahkan kondisi ekstra pada Given, When, atau Then.

##

## **2\. Template Gherkin**

### **A. Skenario Standar (Satu Alur Kerja)**

Gherkin

Feature: \[Judul Fitur Utama\]  
 As a \[Peran Pengguna / Aktor\]  
 I want to \[Tindakan yang ingin dilakukan\]  
 So that \[Nilai bisnis / manfaat yang didapatkan\]

Scenario: \[Nama Skenario Positif \- Jalur Sukses\]  
 Given \[Kondisi awal pengguna atau status aplikasi\]  
 And \[Kondisi tambahan jika ada\]  
 When \[Pengguna melakukan aksi spesifik\]  
 Then \[Sistem memberikan respon sukses\]  
 And \[Efek samping positif pada sistem\]

Scenario: \[Nama Skenario Negatif \- Jalur Gagal/Pengecualian\]  
 Given \[Kondisi awal pengguna atau status aplikasi\]  
 When \[Pengguna melakukan aksi yang salah / memicu error\]  
 Then \[Sistem menolak aksi tersebut\]  
 And \[Sistem menampilkan pesan error sesuai aturan\]

### **B. Skenario Data-Driven (Menggunakan Banyak Data Uji)**

Sangat cocok untuk pengujian fitur formulir, prediksi AI, atau chatbot yang membutuhkan variasi input data berbeda.

Gherkin

Scenario Outline: \[Nama Skenario Berbasis Data\]  
 Given \[Kondisi prasyarat awal\]  
 When Pengguna memasukkan data "\<input_variabel\>"  
 And Pengguna menekan tombol eksekusi  
 Then Sistem harus memberikan respon berupa "\<output_harapan\>"

Examples:  
 | input_variabel | output_harapan |  
 | data_uji_1 | respon_1 |  
 | data_uji_2 | respon_2 |

## **3\. Contoh Implementasi Nyata (Berdasarkan Proyek Aplikasi Museum)**

Berikut adalah contoh konkret bagaimana template di atas diterapkan pada fitur-fitur seperti _Vision Prediksi_ dan _Pesan Tiket_ agar memiliki gambaran yang jelas:

### **Contoh 1: Fitur Pemesanan Tiket (Skenario Standar)**

Gherkin

Feature: Pemesanan Tiket Semedo  
 As a Pengunjung Website  
 I want to Mengklik tombol Pesan Tiket  
 So that Saya bisa diarahkan ke platform pembelian tiket resmi

Scenario: Berhasil diarahkan ke tautan eksternal pembelian tiket (Positif)  
 Given Pengunjung sudah membuka halaman Utama (Home) web aplikasi  
 And Pengunjung melihat tombol "Pesan Tiket"  
 When Pengunjung mengklik tombol "Pesan Tiket"  
 Then Sistem harus mengarahkan (redirect) pengguna ke halaman Linktree resmi Museum Semedo

Scenario: Gagal diarahkan karena masalah koneksi (Negatif/Edge)  
 Given Pengunjung berada di halaman Utama (Home) web aplikasi  
 And Koneksi internet pengunjung terputus tiba-tiba  
 When Pengunjung mengklik tombol "Pesan Tiket"  
 Then Sistem harus tetap menampilkan halaman Home  
 And Sistem memunculkan notifikasi "Koneksi internet Anda terputus"

### **Contoh 2: Fitur Vision Prediksi Artefak (Scenario Outline / Data-Driven)**

Gherkin

Feature: Prediksi Gambar Artefak berbasis Vision AI  
 As a Pengunjung Museum  
 I want to Mengunggah foto artefak  
 So that Sistem dapat memprediksi jenis artefak tersebut dengan akurat

Scenario Outline: Memvalidasi akurasi prediksi model Vision AI terhadap gambar yang valid  
 Given Pengguna berada di halaman fitur "Vision Prediksi"  
 And Pengguna telah berhasil masuk ke sistem  
 When Pengguna memilih file gambar "\<nama_gambar\>" dari penyimpanan lokal  
 And Pengguna mengklik tombol "Submit"  
 Then Sistem harus menampilkan hasil klasifikasi kelas berupa "\<label_prediksi\>"

Examples:  
 | nama_gambar | label_prediksi |  
 | badak_bercula_satu.jpg | badak_bercula_satu |  
 | fosil_gajah_purba.png | gajah_purba |  
 | kapak_perimbas.jpeg | kapak_perimbas |

4\. Keuntungan Bagi Tim Capstone:  
1\. **Menjembatani Dev dan QA:** Dokumen ini ditulis menggunakan bahasa manusia (_Plain Language_), sehingga mudah dipahami oleh anggota tim yang berfokus pada manajemen bisnis, desain UI/UX, maupun pemrograman.  
2\. **Siap Diotomatisasi:** Format Gherkin .feature ini dapat langsung diimpor ke dalam _automation testing tools_ populer seperti **Cucumber**, **Cypress**, atau **Playwright** untuk pengujian otomatis di tahap selanjutnya.

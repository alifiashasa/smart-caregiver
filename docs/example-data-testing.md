# **Template Data Testing – Capstone Project**

**Nama Proyek:** \[Judul Capstone\]

**Modul:** \[Contoh: Vision Prediksi / Chatbot / Sentiment Analysis\]

**Dataset Reference:** \[Contoh: Data\_Ulasan.csv / Model\_Vision\_v2\]

### **Tabel Pengujian Data (Data Integrity & Accuracy)**

| ID Test | Skenario Pengujian Data | Input Data (Variabel) | Expected Output (Data) | Actual Result | Status (OK/NG) | Catatan (Remark) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **DT-01** | **Accuracy:** Prediksi Gambar Artefak | File: badak\_bercula.jpg | Class: badak\_bercula\_satu | Class: badak\_bercula\_satu |  |  |
| **DT-02** | **Validation:** Input Nama User | Input: Jony | Terbaca sebagai string "Jony" | Sesuai |  |  |
| **DT-03** | **Integrity:** Format Tanggal | Input: 2024-01-11 | Tersimpan format YYYY-MM-DD | Sesuai |  |  |
| **DT-04** | **Response:** Chatbot Greeting | Message: halo | "Halo Sobat Semedo, ada yang bisa saya bantu?" | Sesuai |  |  |
| **DT-05** | **Boundary:** Input Karakter Maksimal | Input: 500 karakter ulasan | Sistem menerima & menyimpan lengkap | Terpotong di 255 |  | Defek: DB Limit |
| **DT-06** | **Security:** SQL Injection Test | Input: ' OR '1'='1 | Sistem menolak / Sanitize data | Menolak |  |  |

### 

### **Penjelasan Komponen** 

1. **Akurasi (Accuracy):**  
   * Terutama untuk modul AI/ML (seperti *Vision* dan *Chatbot*). Apakah model memberikan hasil klasifikasi yang tepat sesuai label?  
   * *Contoh:* Gambar Badak harus keluar label Badak, bukan Gajah.  
2. **Integritas & Format (Integrity):**  
   * Apakah data yang diinput berubah saat disimpan? Apakah format tanggal, angka desimal, atau mata uang konsisten antara *frontend* dan *database*?  
3. **Validasi & Boundary (Batas):**  
   * Mengacu pada prinsip **ISTQB** mengenai *Equivalence Partitioning* dan *Boundary Value Analysis*.  
   * *Contoh:* Apa yang terjadi jika nama diisi angka? Apa yang terjadi jika pesan chatbot dikirim kosong?

### 

### **Panduan Implementasi di Proyek Capstone:**

* **Mapping ke PRD:** Mahasiswa harus memastikan setiap elemen data yang diuji memiliki referensi di *Product Requirement Document* (PRD).  
* **Data Beragam:** mahasiswa dapat menggunakan variasi data:  
  * *Normal Data:* Data yang umum dan benar.  
  * *Abnormal Data:* Data dengan format salah (huruf di kolom angka).  
  * *Edge Data:* Data yang sangat panjang atau sangat pendek.  
* **Evidence:** Untuk data testing, *evidence* (bukti) bisa berupa tangkapan layar hasil *query* database atau respon JSON dari API untuk membuktikan data terproses dengan benar.


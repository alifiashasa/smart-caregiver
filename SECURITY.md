# Security Aplikasi Mobile Smart Caregiver

Teknik keamanan yang digunakan pada aplikasi ini:

1. **Autentikasi pengguna**  
   Pengguna harus login terlebih dahulu sebelum mengakses fitur utama aplikasi.

2. **JWT Bearer Token**  
   Backend menggunakan access token dan refresh token untuk menjaga sesi login pengguna.

3. **Password hashing dengan bcrypt**  
   Password tidak disimpan dalam bentuk asli, tetapi di-hash menggunakan bcrypt.

4. **Authorization / pembatasan akses data**  
   Setiap caregiver hanya dapat mengakses data lansia yang dimilikinya. Jika bukan pemilik data, server menolak akses dengan status 403.

5. **Validasi token di setiap request penting**  
   Endpoint seperti data lansia, kesehatan, jadwal, dashboard, notifikasi, dan rekomendasi AI membutuhkan JWT yang valid.

6. **Environment variable untuk secret**  
   Secret key, API key, database URL, dan konfigurasi sensitif disimpan melalui file environment, bukan di-hardcode dalam kode aplikasi.

7. **Internal API Key**  
   Endpoint internal seperti pengiriman alarm dan weekly summary dilindungi dengan API key khusus.

Singkatnya, keamanan aplikasi ini berfokus pada autentikasi JWT, hashing password, pembatasan akses berdasarkan pemilik data, dan perlindungan konfigurasi sensitif.

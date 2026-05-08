# Behavior-Driven Development (BDD) Scenarios

## Fitur 1: Registrasi & Autentikasi Caregiver

### Registrasi Caregiver

#### Caregiver baru berhasil mendaftar dengan email dan password

- Given: caregiver belum memiliki akun
- When: caregiver mengirim email "caregiver@email.com" dan password "password123" serta nama lengkap "Andi Caregiver"
- Then: sistem membuat akun baru dengan status aktif
- And: sistem mengembalikan access token dan refresh token

#### Caregiver gagal mendaftar dengan email yang sudah terdaftar

- Given: email "caregiver@email.com" sudah terdaftar
- When: caregiver mendaftar dengan email yang sama
- Then: sistem mengembalikan error bahwa email sudah digunakan

#### Caregiver gagal mendaftar dengan password kurang dari 8 karakter

- Given: caregiver mengisi password "123"
- When: caregiver mengirim form registrasi
- Then: sistem mengembalikan error validasi password

### Login Caregiver

#### Caregiver berhasil login dengan email dan password yang benar

- Given: caregiver sudah terdaftar dengan email "caregiver@email.com" dan password "password123"
- When: caregiver login dengan kredensial tersebut
- Then: sistem memverifikasi kecocokan password
- And: sistem memperbarui waktu login terakhir
- And: sistem mengembalikan access token dan refresh token

#### Caregiver gagal login dengan password salah

- Given: caregiver sudah terdaftar dengan email "caregiver@email.com"
- When: caregiver login dengan password yang salah
- Then: sistem mengembalikan error kredensial tidak valid

#### Caregiver yang tidak aktif tidak dapat login

- Given: akun caregiver dengan email "caregiver@email.com" dinonaktifkan
- When: caregiver mencoba login
- Then: sistem mengembalikan error bahwa akun tidak aktif

#### Caregiver memperbarui access token menggunakan refresh token

- Given: caregiver memiliki refresh token yang valid
- When: caregiver mengirim refresh token
- Then: sistem mengembalikan access token baru

## Fitur 2: Manajemen Profil Lansia

### Membuat Profil Lansia

#### Caregiver berhasil membuat profil lansia baru

- Given: caregiver sudah login
- When: caregiver mengirim data profil lansia dengan nama "Budi Santoso", usia 75, riwayat penyakit hipertensi, mobilitas mandiri
- Then: sistem menyimpan profil lansia dengan status aktif
- And: sistem mengembalikan detail profil lengkap

#### Caregiver membuat profil lansia tanpa mengisi nama

- Given: caregiver sudah login
- When: caregiver mengirim data profil tanpa nama lansia
- Then: sistem mengembalikan error validasi bahwa nama wajib diisi

#### Caregiver membuat lebih dari satu profil lansia

- Given: caregiver sudah memiliki profil lansia "Budi Santoso"
- When: caregiver membuat profil lansia kedua "Siti Aminah"
- Then: sistem menyimpan profil lansia kedua
- And: daftar profil lansia caregiver berisi kedua profil tersebut

### Mengelola Profil Lansia

#### Caregiver melihat daftar semua profil lansia

- Given: caregiver memiliki 3 profil lansia
- When: caregiver membuka daftar profil lansia
- Then: sistem menampilkan semua profil lengkap dengan status masing-masing

#### Caregiver memperbarui data profil lansia

- Given: caregiver memiliki profil lansia "Budi Santoso"
- When: caregiver mengubah mobilitas menjadi "assisted"
- Then: sistem memperbarui data mobilitas
- And: field lain tidak berubah

#### Caregiver menonaktifkan profil lansia (soft delete)

- Given: caregiver memiliki profil lansia aktif "Budi Santoso"
- When: caregiver menonaktifkan profil tersebut
- Then: status profil berubah menjadi "inactive"
- And: data kesehatan dan jadwal tetap tersimpan

#### Caregiver menghapus permanen profil lansia

- Given: caregiver memiliki profil lansia "Budi Santoso"
- When: caregiver menghapus permanen profil tersebut
- Then: sistem menghapus profil beserta semua data kesehatan, jadwal, dan rekomendasi

#### Caregiver lain tidak bisa mengakses profil lansia milik caregiver lain

- Given: caregiver A memiliki profil lansia "Budi Santoso"
- When: caregiver B mencoba mengakses detail profil Budi
- Then: sistem mengembalikan error akses ditolak

## Fitur 3: Pencatatan Kesehatan Harian

### Mencatat Kesehatan Harian

#### Caregiver berhasil mencatat kesehatan harian dengan parameter lengkap

- Given: caregiver memiliki profil lansia "Budi Santoso"
- When: caregiver mencatat tekanan darah 120/80, gula darah 100, detak jantung 75, suhu 36.5°C, berat badan 65kg
- Then: sistem menyimpan record kesehatan
- And: sistem menjalankan analisis fuzzy pada parameter tersebut
- And: sistem menetapkan status kesehatan
- And: sistem mengirim notifikasi "Health Record Created" ke caregiver

#### Caregiver mencatat kesehatan dengan parameter yang melebihi ambang batas

- Given: lansia "Budi Santoso" memiliki threshold tekanan darah maksimal 140
- When: caregiver mencatat tekanan darah 160/100
- Then: sistem mendeteksi parameter melampaui batas
- And: status kesehatan ditetapkan sebagai "needs_attention"
- And: sistem mengirim notifikasi "Critical Health Alert" dengan prioritas tinggi

#### Caregiver menambahkan catatan harian dan keluhan

- Given: caregiver mencatat kesehatan untuk "Budi Santoso"
- When: caregiver menambahkan catatan "Mengeluh pusing ringan" pada form
- Then: sistem menyimpan catatan tersebut bersama data kesehatan

#### Caregiver melihat riwayat kesehatan lansia

- Given: lansia "Budi Santoso" memiliki 10 record kesehatan
- When: caregiver membuka riwayat kesehatan Budi
- Then: sistem menampilkan 10 record diurutkan dari yang terbaru
- And: sistem mendukung paginasi

#### Caregiver melihat detail satu record kesehatan

- Given: terdapat record kesehatan untuk "Budi Santoso"
- When: caregiver membuka detail record tersebut
- Then: sistem menampilkan semua parameter vital
- And: sistem menampilkan hasil analisis fuzzy (skor kardiovaskular, metabolik, infeksi)

#### Caregiver menjalankan ulang analisis fuzzy pada record lama

- Given: terdapat record kesehatan lama untuk "Budi Santoso"
- When: caregiver meminta analisis ulang
- Then: sistem menjalankan fuzzy analysis kembali
- And: sistem memperbarui skor fuzzy pada record tersebut

## Fitur 4: Dashboard & Tren Kesehatan

### Dashboard Overview

#### Caregiver melihat ringkasan semua lansia di dashboard

- Given: caregiver memiliki 2 lansia aktif: "Budi Santoso" dan "Siti Aminah"
- And: Budi memiliki record kesehatan terbaru dengan status normal
- And: Siti memiliki record kesehatan terbaru dengan status perlu perhatian
- When: caregiver membuka dashboard overview
- Then: sistem menampilkan 2 kartu lansia
- And: kartu Budi menampilkan status "normal" dengan warna hijau
- And: kartu Siti menampilkan status "needs_attention" dengan warna jingga
- And: setiap kartu menampilkan nama, usia, dan waktu update terakhir

#### Dashboard hanya menampilkan lansia dengan status aktif

- Given: caregiver memiliki lansia "Budi Santoso" aktif dan "Siti Aminah" tidak aktif
- When: caregiver membuka dashboard
- Then: sistem hanya menampilkan Budi Santoso

#### Dashboard menampilkan data kosong bila belum ada lansia

- Given: caregiver belum memiliki profil lansia
- When: caregiver membuka dashboard
- Then: sistem menampilkan pesan belum ada data

### Tren Kesehatan

#### Caregiver melihat tren kesehatan 7 hari

- Given: lansia "Budi Santoso" memiliki record kesehatan setiap hari selama 7 hari terakhir
- When: caregiver membuka tren kesehatan dengan rentang 7 hari
- Then: sistem menampilkan data point per hari
- And: sistem menampilkan ringkasan statistik (min, max, rata-rata) per parameter

#### Caregiver melihat tren kesehatan 30 hari

- Given: lansia "Budi Santoso" memiliki record kesehatan selama 30 hari
- When: caregiver membuka tren kesehatan dengan rentang 30 hari
- Then: sistem menampilkan data point per hari dalam 30 hari

#### Tren kesehatan menampilkan data kosong bila belum ada record

- Given: lansia "Budi Santoso" belum memiliki record kesehatan
- When: caregiver membuka tren kesehatan
- Then: sistem menampilkan data kosong tanpa error

## Fitur 5: Jadwal & Alarm Pengingat

### Mengelola Jadwal

#### Caregiver membuat jadwal minum obat

- Given: caregiver memiliki lansia "Budi Santoso"
- When: caregiver membuat jadwal "Obat Darah Tinggi" tipe medication setiap jam 08:00 dengan pengingat 10 menit sebelumnya
- Then: sistem menyimpan jadwal dengan status aktif
- And: sistem membuat alarm pada jam 07:50

#### Caregiver membuat jadwal harian berulang

- Given: caregiver memiliki lansia "Siti Aminah"
- When: caregiver membuat jadwal "Jalan Santai" tipe daily activity setiap jam 16:30 dengan frekuensi harian
- Then: sistem menyimpan jadwal dengan recurrence "daily"

#### Caregiver melihat daftar jadwal per lansia

- Given: lansia "Budi Santoso" memiliki 3 jadwal
- When: caregiver membuka daftar jadwal Budi
- Then: sistem menampilkan 3 jadwal dengan detail masing-masing

#### Caregiver memperbarui jadwal

- Given: terdapat jadwal "Obat Darah Tinggi" untuk Budi
- When: caregiver mengubah waktu menjadi jam 09:00
- Then: sistem memperbarui waktu jadwal
- And: alarm turut menyesuaikan

#### Caregiver menandai jadwal sebagai selesai

- Given: terdapat jadwal "Obat Darah Tinggi" untuk Budi
- When: caregiver menandai jadwal sebagai selesai
- Then: sistem mencatat waktu penyelesaian

#### Caregiver menghapus jadwal

- Given: terdapat jadwal "Obat Darah Tinggi" untuk Budi
- When: caregiver menghapus jadwal tersebut
- Then: sistem menghapus jadwal beserta alarm terkait

### Alarm Pengingat

#### Alarm yang jatuh tempo memicu notifikasi

- Given: terdapat alarm untuk jadwal "Obat Darah Tinggi" jam 07:50
- When: sistem memproses alarm yang jatuh tempo
- Then: sistem membuat notifikasi "Reminder: Obat Darah Tinggi" untuk caregiver

#### Alarm untuk jadwal yang tidak aktif tidak memicu notifikasi

- Given: jadwal "Obat Darah Tinggi" sudah dinonaktifkan
- And: terdapat alarm yang jatuh tempo
- When: sistem memproses alarm yang jatuh tempo
- Then: sistem menandai alarm sebagai terkirim tanpa membuat notifikasi

## Fitur 6: Rekomendasi Aktivitas AI

### Menghasilkan Rekomendasi Aktivitas

#### Sistem menghasilkan rekomendasi aktivitas berdasarkan profil lansia

- Given: lansia "Budi Santoso" memiliki mobilitas "mandiri", hobi "berkebun", riwayat hipertensi
- When: caregiver meminta generate rekomendasi aktivitas
- Then: sistem membaca data profil Budi
- And: sistem menghasilkan rekomendasi aktivitas yang sesuai
- And: rekomendasi memiliki status "pending"

#### Caregiver melihat daftar rekomendasi aktivitas

- Given: lansia "Budi Santoso" memiliki 2 rekomendasi aktivitas
- When: caregiver membuka daftar rekomendasi Budi
- Then: sistem menampilkan semua rekomendasi dengan detail (nama, deskripsi, durasi, status)

### Menyetujui/Menolak Rekomendasi

#### Caregiver menyetujui rekomendasi aktivitas tanpa jadwal

- Given: terdapat rekomendasi "Senam Lansia" dengan status "pending"
- When: caregiver menyetujui rekomendasi tersebut tanpa menentukan jadwal
- Then: status rekomendasi berubah menjadi "approved"
- And: sistem mencatat caregiver yang menyetujui

#### Caregiver menyetujui rekomendasi dan langsung membuat jadwal

- Given: terdapat rekomendasi "Senam Lansia" dengan status "pending"
- When: caregiver menyetujui dengan jadwal hari Senin jam 09:00
- Then: status rekomendasi berubah menjadi "approved"
- And: sistem membuat jadwal baru "Senam Lansia" dengan tipe daily activity
- And: jadwal tercatat berasal dari rekomendasi AI

#### Caregiver menolak rekomendasi aktivitas

- Given: terdapat rekomendasi "Senam Lansia" dengan status "pending"
- When: caregiver menolak dengan alasan "Tidak sesuai kondisi"
- Then: status rekomendasi berubah menjadi "rejected"
- And: alasan penolakan tersimpan

#### Rekomendasi yang sudah disetujui tidak bisa disetujui lagi

- Given: rekomendasi "Senam Lansia" sudah berstatus "approved"
- When: caregiver mencoba menyetujui lagi
- Then: sistem mengembalikan error

## Fitur 7: Notifikasi

### Notifikasi Kesehatan

#### Notifikasi terkirim saat pencatatan kesehatan normal

- Given: caregiver mencatat kesehatan normal untuk "Budi Santoso"
- When: sistem selesai memproses record
- Then: sistem mengirim notifikasi "Health Record Created" dengan prioritas normal kepada caregiver

#### Notifikasi prioritas tinggi terkirim saat kondisi kritis

- Given: caregiver mencatat tekanan darah 180/110 untuk "Budi Santoso"
- When: parameter melampaui threshold
- Then: sistem mengirim notifikasi "Critical Health Alert" dengan prioritas tinggi

### Mengelola Notifikasi

#### Caregiver melihat daftar notifikasi

- Given: caregiver memiliki 5 notifikasi
- When: caregiver membuka daftar notifikasi
- Then: sistem menampilkan 5 notifikasi diurutkan dari terbaru

#### Caregiver melihat jumlah notifikasi belum dibaca

- Given: caregiver memiliki 3 notifikasi belum dibaca
- When: caregiver membuka halaman notifikasi
- Then: sistem menampilkan jumlah notifikasi belum dibaca

#### Caregiver menandai notifikasi sebagai sudah dibaca

- Given: caregiver memiliki notifikasi belum dibaca
- When: caregiver menandai notifikasi tersebut sebagai dibaca
- Then: status notifikasi berubah menjadi "read"

#### Caregiver menandai semua notifikasi sebagai sudah dibaca

- Given: caregiver memiliki 5 notifikasi belum dibaca
- When: caregiver menandai semua sebagai dibaca
- Then: seluruh notifikasi caregiver berstatus "read"

#### Notifikasi caregiver lain tidak bisa diakses

- Given: caregiver A memiliki notifikasi dengan id "N001"
- When: caregiver B mencoba menandai notifikasi "N001" sebagai dibaca
- Then: sistem mengembalikan error tidak punya akses

### Preferensi Notifikasi

#### Caregiver melihat preferensi notifikasi

- Given: caregiver memiliki pengaturan notifikasi
- When: caregiver membuka preferensi notifikasi
- Then: sistem menampilkan pengaturan per tipe notifikasi

#### Caregiver menonaktifkan notifikasi untuk tipe tertentu

- Given: caregiver menerima notifikasi health_recorded
- When: caregiver menonaktifkan notifikasi tipe health_recorded
- Then: sistem menyimpan preferensi bahwa tipe tersebut dinonaktifkan

## Fitur 8: Ringkasan Mingguan

### Ringkasan Kesehatan Mingguan

#### Sistem mengirim ringkasan mingguan dengan data kesehatan 7 hari

- Given: lansia "Budi Santoso" memiliki 7 record kesehatan dalam 7 hari terakhir
- When: sistem menjalankan job ringkasan mingguan
- Then: sistem menghitung rata-rata parameter kesehatan
- And: sistem menghitung jumlah status normal, warning, dan kritis
- And: sistem mengirim notifikasi ringkasan mingguan ke caregiver

#### Ringkasan mingguan tidak terkirim bila tidak ada data

- Given: lansia "Budi Santoso" tidak memiliki record kesehatan dalam 7 hari terakhir
- When: sistem menjalankan job ringkasan mingguan
- Then: sistem tidak mengirim notifikasi ringkasan

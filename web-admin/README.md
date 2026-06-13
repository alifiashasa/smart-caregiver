# Smart Caregiver Web Admin

Operational admin panel berbasis Vite + React + shadcn/ui.

## Menjalankan

```bash
bun install
bun dev
```

Default URL Vite: `http://localhost:5173`.

## Koneksi API

Buat file `.env` dari `.env.example`:

```bash
cp .env.example .env
```

Isi:

- `VITE_API_URL`: URL FastAPI, contoh `http://localhost:8000`

Admin key diinput dari halaman login. Nilainya sama dengan `INTERNAL_API_KEY` di `server/.env`.

## Fokus fitur

- Monitor operasional aplikasi tanpa detail data medis/user sensitif.
- Kirim pengumuman aplikasi ke caregiver via in-app dan email.
- Histori pengumuman ringkas.
- Manajemen kecil caregiver: create akun dan active/inactive.

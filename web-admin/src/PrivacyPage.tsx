import {
  Activity,
  ArrowUpRight,
  BellRing,
  BrainCircuit,
  Database,
  HeartPulse,
  LockKeyhole,
  Mail,
  ShieldCheck,
  Trash2,
  UserRound,
} from 'lucide-react'

import './privacy.css'

const sections = [
  { id: 'data', label: 'Data yang kami kumpulkan' },
  { id: 'use', label: 'Cara kami menggunakan data' },
  { id: 'sharing', label: 'Pembagian data' },
  { id: 'security', label: 'Keamanan & penyimpanan' },
  { id: 'rights', label: 'Hak & penghapusan data' },
  { id: 'children', label: 'Privasi anak' },
  { id: 'changes', label: 'Perubahan kebijakan' },
  { id: 'contact', label: 'Hubungi kami' },
]

function PrivacyPage() {
  return (
    <div className="privacy-page">
      <header className="privacy-nav">
        <a className="privacy-brand" href="/privacy" aria-label="Smart Caregiver">
          <span className="privacy-brand-mark"><HeartPulse aria-hidden="true" /></span>
          <span>Smart Caregiver</span>
        </a>
        <a className="privacy-contact-link" href="mailto:wahyufadil1140@gmail.com">
          Kontak <ArrowUpRight aria-hidden="true" />
        </a>
      </header>

      <main>
        <section className="privacy-hero">
          <div className="privacy-orb privacy-orb-one" aria-hidden="true" />
          <div className="privacy-orb privacy-orb-two" aria-hidden="true" />
          <div className="privacy-hero-inner">
            <div className="privacy-kicker"><ShieldCheck aria-hidden="true" /> Privasi Anda penting</div>
            <h1>Kebijakan Privasi</h1>
            <p className="privacy-lead">
              Smart Caregiver membantu caregiver memantau dan mendampingi kesehatan lansia.
              Halaman ini menjelaskan data yang kami kelola, alasan penggunaannya, dan kendali
              yang Anda miliki atas data tersebut.
            </p>
            <div className="privacy-meta">
              <span>Berlaku sejak 13 Juli 2026</span>
              <span aria-hidden="true">•</span>
              <span>Versi 1.0</span>
            </div>
          </div>
        </section>

        <div className="privacy-layout">
          <aside className="privacy-toc" aria-label="Daftar isi">
            <p>Di halaman ini</p>
            <nav>
              {sections.map((section, index) => (
                <a href={`#${section.id}`} key={section.id}>
                  <span>{String(index + 1).padStart(2, '0')}</span>
                  {section.label}
                </a>
              ))}
            </nav>
          </aside>

          <article className="privacy-content">
            <div className="privacy-summary">
              <ShieldCheck aria-hidden="true" />
              <div>
                <strong>Ringkasnya</strong>
                <p>
                  Kami hanya menggunakan data untuk menyediakan dan meningkatkan layanan Smart
                  Caregiver. Kami tidak menjual data pribadi atau data kesehatan Anda dan tidak
                  menggunakannya untuk iklan bertarget.
                </p>
              </div>
            </div>

            <section id="data" className="privacy-section">
              <div className="privacy-section-heading">
                <span>01</span>
                <div><p>Informasi</p><h2>Data yang kami kumpulkan</h2></div>
              </div>
              <p>
                Data diberikan oleh caregiver saat menggunakan aplikasi. Jenis data yang dapat
                kami proses meliputi:
              </p>
              <div className="privacy-data-grid">
                <div className="privacy-data-card">
                  <UserRound aria-hidden="true" />
                  <h3>Data akun</h3>
                  <p>Nama, alamat email, nomor telepon opsional, foto profil, dan informasi autentikasi.</p>
                </div>
                <div className="privacy-data-card">
                  <HeartPulse aria-hidden="true" />
                  <h3>Profil lansia</h3>
                  <p>Nama, usia, jenis kelamin, foto, kondisi fisik, mobilitas, alergi, riwayat medis, minat, dan kontak darurat.</p>
                </div>
                <div className="privacy-data-card">
                  <Activity aria-hidden="true" />
                  <h3>Catatan kesehatan</h3>
                  <p>Tanda vital, berat badan, gula darah, kolesterol, asam urat, saturasi oksigen, keluhan, dan catatan harian.</p>
                </div>
                <div className="privacy-data-card">
                  <BellRing aria-hidden="true" />
                  <h3>Data penggunaan</h3>
                  <p>Jadwal perawatan, pengingat, preferensi notifikasi, token perangkat, serta waktu pembuatan dan pembaruan data.</p>
                </div>
              </div>
              <p>
                Jika Anda memasukkan data orang lain, termasuk lansia atau kontak darurat, Anda
                menyatakan bahwa Anda memiliki izin yang sesuai untuk memberikan dan mengelola data tersebut.
              </p>
            </section>

            <section id="use" className="privacy-section">
              <div className="privacy-section-heading">
                <span>02</span>
                <div><p>Tujuan</p><h2>Cara kami menggunakan data</h2></div>
              </div>
              <ul>
                <li>Membuat dan mengamankan akun caregiver.</li>
                <li>Menyimpan profil lansia, catatan kesehatan, jadwal, dan riwayat perawatan.</li>
                <li>Menganalisis parameter kesehatan untuk menampilkan status, tren, dan peringatan.</li>
                <li>Mengirim pengingat jadwal, ringkasan, dan notifikasi kondisi yang memerlukan perhatian.</li>
                <li>Membuat rekomendasi aktivitas berbantuan AI berdasarkan profil yang dipilih pengguna.</li>
                <li>Menjaga keamanan, mencegah penyalahgunaan, menangani gangguan, dan meningkatkan layanan.</li>
              </ul>
              <div className="privacy-note">
                <Activity aria-hidden="true" />
                <p><strong>Bukan layanan medis.</strong> Smart Caregiver adalah alat bantu pemantauan dan tidak menggantikan diagnosis, saran, atau penanganan tenaga kesehatan profesional.</p>
              </div>
            </section>

            <section id="sharing" className="privacy-section">
              <div className="privacy-section-heading">
                <span>03</span>
                <div><p>Pihak ketiga</p><h2>Pembagian data</h2></div>
              </div>
              <p>
                Kami tidak menjual atau menyewakan data pribadi. Data hanya dapat diproses oleh
                penyedia layanan yang diperlukan untuk menjalankan fitur aplikasi:
              </p>
              <div className="privacy-provider-list">
                <div><BellRing aria-hidden="true" /><p><strong>Google Firebase</strong><span>Pengiriman notifikasi push dan layanan pendukung aplikasi.</span></p></div>
                <div><BrainCircuit aria-hidden="true" /><p><strong>Penyedia layanan AI</strong><span>Memproses bagian profil lansia yang relevan untuk menghasilkan rekomendasi aktivitas.</span></p></div>
                <div><Database aria-hidden="true" /><p><strong>Infrastruktur cloud</strong><span>Penyimpanan basis data, hosting aplikasi, autentikasi, dan pengiriman email layanan.</span></p></div>
              </div>
              <p>
                Penyedia tersebut hanya menerima data yang diperlukan untuk tugasnya dan terikat
                oleh ketentuan perlindungan data masing-masing. Kami juga dapat mengungkapkan data
                jika diwajibkan oleh hukum atau diperlukan untuk melindungi keselamatan dan hak pengguna.
              </p>
            </section>

            <section id="security" className="privacy-section">
              <div className="privacy-section-heading">
                <span>04</span>
                <div><p>Perlindungan</p><h2>Keamanan & penyimpanan</h2></div>
              </div>
              <p>
                Kami menerapkan langkah teknis dan organisasi yang wajar, termasuk autentikasi,
                pembatasan akses berdasarkan kepemilikan akun, enkripsi komunikasi, serta
                penyimpanan kata sandi dalam bentuk hash. Namun, tidak ada metode transmisi atau
                penyimpanan elektronik yang sepenuhnya bebas risiko.
              </p>
              <p>
                Data disimpan selama akun aktif atau selama diperlukan untuk menyediakan layanan.
                Setelah penghapusan diminta, data akan dihapus atau dianonimkan dalam waktu paling
                lama 30 hari, kecuali penyimpanan lebih lama diwajibkan untuk keamanan, penyelesaian
                sengketa, pencadangan sementara, atau kewajiban hukum.
              </p>
            </section>

            <section id="rights" className="privacy-section">
              <div className="privacy-section-heading">
                <span>05</span>
                <div><p>Kendali Anda</p><h2>Hak & penghapusan data</h2></div>
              </div>
              <p>
                Anda dapat meminta salinan, koreksi, atau penghapusan data pribadi dan akun Anda.
                Untuk mengajukan permintaan, kirim email dari alamat yang terdaftar dengan subjek
                <strong> “Permintaan Penghapusan Akun Smart Caregiver”</strong>. Kami dapat meminta
                verifikasi tambahan untuk mencegah akses atau penghapusan tanpa izin.
              </p>
              <a className="privacy-delete-cta" href="mailto:wahyufadil1140@gmail.com?subject=Permintaan%20Penghapusan%20Akun%20Smart%20Caregiver">
                <span><Trash2 aria-hidden="true" /></span>
                <p><strong>Ajukan penghapusan akun</strong><small>wahyufadil1140@gmail.com</small></p>
                <ArrowUpRight aria-hidden="true" />
              </a>
            </section>

            <section id="children" className="privacy-section">
              <div className="privacy-section-heading">
                <span>06</span>
                <div><p>Batas usia</p><h2>Privasi anak</h2></div>
              </div>
              <p>
                Smart Caregiver ditujukan untuk caregiver dewasa dan tidak ditujukan kepada anak
                di bawah usia 13 tahun. Kami tidak dengan sengaja mengumpulkan data pribadi anak.
                Hubungi kami jika Anda yakin seorang anak telah memberikan data kepada kami tanpa
                persetujuan yang sesuai.
              </p>
            </section>

            <section id="changes" className="privacy-section">
              <div className="privacy-section-heading">
                <span>07</span>
                <div><p>Pembaruan</p><h2>Perubahan kebijakan</h2></div>
              </div>
              <p>
                Kebijakan ini dapat diperbarui untuk mencerminkan perubahan fitur, praktik, atau
                ketentuan hukum. Versi terbaru akan selalu tersedia di halaman ini dengan tanggal
                berlaku yang diperbarui. Untuk perubahan material, kami dapat memberikan
                pemberitahuan tambahan melalui aplikasi.
              </p>
            </section>

            <section id="contact" className="privacy-section privacy-contact">
              <div className="privacy-section-heading">
                <span>08</span>
                <div><p>Pertanyaan</p><h2>Hubungi kami</h2></div>
              </div>
              <p>Jika Anda memiliki pertanyaan atau permintaan terkait privasi, silakan hubungi pengembang Smart Caregiver.</p>
              <a href="mailto:wahyufadil1140@gmail.com"><Mail aria-hidden="true" />wahyufadil1140@gmail.com</a>
            </section>
          </article>
        </div>
      </main>

      <footer className="privacy-footer">
        <div className="privacy-brand">
          <span className="privacy-brand-mark"><HeartPulse aria-hidden="true" /></span>
          <span>Smart Caregiver</span>
        </div>
        <p><LockKeyhole aria-hidden="true" /> Merawat dengan aman, mendampingi dengan tenang.</p>
      </footer>
    </div>
  )
}

export default PrivacyPage


# Gnirehtet CMD Automated Installer

**Instalasi otomatis reverse USB tethering Android ke Windows menggunakan CMD tanpa PowerShell.**

Proyek ini menyediakan skrip Windows `.cmd` untuk membantu pengguna memasang dan menjalankan Gnirehtet, sebuah perangkat lunak yang memungkinkan perangkat Android menggunakan koneksi internet dari komputer melalui kabel USB.

Skrip dirancang agar proses instalasi lebih mudah bagi pengguna awam, dengan pemeriksaan file, unduhan komponen, verifikasi SHA-256, pemeriksaan perangkat Android, instalasi aplikasi, dan peluncuran koneksi.

---

## Daftar Isi

1. [Apa Itu Proyek Ini?](#apa-itu-proyek-ini)
2. [Apa Itu Reverse USB Tethering?](#apa-itu-reverse-usb-tethering)
3. [Fungsi dan Kegunaan](#fungsi-dan-kegunaan)
4. [Cara Kerja](#cara-kerja)
5. [Persyaratan Sistem](#persyaratan-sistem)
6. [Persiapan Android](#persiapan-android)
7. [Cara Instalasi](#cara-instalasi)
8. [Cara Menggunakan](#cara-menggunakan)
9. [Cara Menghentikan Koneksi](#cara-menghentikan-koneksi)
10. [Pemecahan Masalah](#pemecahan-masalah)
11. [Batasan dan Keamanan](#batasan-dan-keamanan)
12. [Teknologi yang Digunakan](#teknologi-yang-digunakan)
13. [Sumber Resmi](#sumber-resmi)
14. [Lisensi dan Atribusi](#lisensi-dan-atribusi)

---

## 1. Apa Itu Proyek Ini?

Gnirehtet CMD Automated Installer adalah proyek otomasi instalasi berbasis Windows Command Prompt (CMD) untuk membantu pengguna menyiapkan Gnirehtet tanpa harus menjalankan setiap perintah secara manual.

Skrip akan membantu menyiapkan Android Platform Tools (ADB), mengunduh Gnirehtet, memeriksa integritas arsip, mengekstrak berkas, mendeteksi perangkat Android, memasang aplikasi pendamping, dan menjalankan koneksi reverse tethering.

Proyek ini ditujukan untuk pengguna yang ingin menggunakan internet komputer pada ponsel Android melalui kabel USB, khususnya pengguna yang belum terbiasa dengan command line.

**Penting:** skrip ini merupakan alat bantu instalasi dan otomasi. Mesin reverse tethering yang digunakan tetap berasal dari proyek Gnirehtet resmi Genymobile.

---

## 2. Apa Itu Reverse USB Tethering?

Reverse USB tethering adalah metode untuk memberikan akses internet dari komputer kepada perangkat Android melalui kabel USB.

Pada penggunaan biasa, tethering dilakukan dari ponsel ke komputer. Pada reverse tethering, arah koneksinya dibalik:

- Tethering biasa: internet ponsel → komputer.
- Reverse USB tethering: internet komputer → ponsel.

Contoh penggunaan:

Komputer Windows memiliki akses internet melalui Ethernet, Wi-Fi, atau koneksi jaringan lainnya. Ponsel Android tidak memiliki koneksi internet yang memadai. Dengan Gnirehtet, ponsel dapat menggunakan koneksi internet komputer melalui USB.

Metode ini berguna ketika pengguna ingin mengurangi ketergantungan ponsel pada jaringan seluler atau Wi-Fi, selama komputer tetap memiliki koneksi internet aktif.

---

## 3. Fungsi dan Kegunaan

### Fungsi utama

1. **Otomasi instalasi ADB**  
   Mengunduh dan menyiapkan Android Platform Tools yang dibutuhkan untuk berkomunikasi dengan perangkat Android.

2. **Otomasi pengunduhan Gnirehtet**  
   Mengambil paket Gnirehtet Windows dari rilis resmi yang ditentukan dalam skrip.

3. **Verifikasi integritas arsip**  
   Membandingkan nilai SHA-256 arsip Gnirehtet dengan nilai yang telah ditetapkan untuk mendeteksi file yang tidak cocok atau rusak.

4. **Ekstraksi berkas**  
   Mengekstrak paket instalasi menggunakan utilitas ZIP yang kompatibel.

5. **Pemeriksaan perangkat Android**  
   Memeriksa apakah perangkat terdeteksi oleh ADB dan memiliki status otorisasi yang benar.

6. **Instalasi aplikasi Android**  
   Memasang atau memperbarui APK Gnirehtet pada perangkat yang terhubung.

7. **Menjalankan reverse tethering**  
   Memulai koneksi sehingga Android dapat menggunakan koneksi internet komputer melalui USB.

8. **Penanganan kesalahan**  
   Menghentikan proses ketika pemeriksaan penting gagal dan menampilkan pesan kesalahan untuk membantu diagnosis.

### Siapa yang dapat menggunakan proyek ini?

- Pengguna Windows yang ingin berbagi koneksi internet komputer dengan Android.
- Pengguna yang ingin mengotomatisasi instalasi ADB dan Gnirehtet.
- Teknisi IT yang melakukan konfigurasi perangkat Android.
- Pengembang atau pembelajar yang ingin mempelajari otomasi menggunakan Windows Batch Script.

---

## 4. Cara Kerja

Alur umum skrip:

1. Membuat direktori kerja `C:\ReverseUSB`.
2. Menyiapkan Android Platform Tools.
3. Mengunduh paket Gnirehtet.
4. Memverifikasi SHA-256 paket Gnirehtet.
5. Mengekstrak paket yang telah lolos pemeriksaan.
6. Memulai ADB dan memeriksa koneksi Android.
7. Memasang APK Gnirehtet.
8. Memverifikasi keberadaan paket aplikasi.
9. Menjalankan Gnirehtet.
10. Pengguna menyetujui permintaan koneksi VPN pada Android.

### Gambaran alur koneksi

```text
INTERNET
   |
   v
KOMPUTER WINDOWS
   |
   | Kabel USB
   v
ADB + GNIREHTET
   |
   | Koneksi reverse tethering
   v
PERANGKAT ANDROID
   |
   v
AKSES INTERNET
```

Diagram tersebut merupakan gambaran konseptual, bukan representasi seluruh detail teknis protokol jaringan.

---

## 5. Persyaratan Sistem

Sebelum menjalankan skrip, pastikan persyaratan berikut terpenuhi.

### Komputer

- Windows 10 atau Windows 11 direkomendasikan.
- Windows 64-bit direkomendasikan untuk paket Gnirehtet yang digunakan.
- Koneksi internet aktif untuk mengunduh komponen.
- Command Prompt (CMD).
- Utilitas `curl.exe` atau `bitsadmin.exe` yang kompatibel untuk pengunduhan.
- `certutil.exe` untuk pemeriksaan SHA-256.
- `tar.exe` atau 7-Zip untuk mengekstrak arsip ZIP.

**Catatan kompatibilitas:** skrip tidak menggunakan PowerShell, tetapi tidak semua versi Windows lama menyediakan seluruh utilitas di atas. Karena itu, sistem lama mungkin memerlukan persiapan tambahan.

### Perangkat Android

- Ponsel Android yang kompatibel dengan Gnirehtet.
- Kabel USB yang mendukung transfer data.
- USB debugging aktif.
- Otorisasi debugging komputer disetujui pada ponsel.
- Pengguna bersedia memberikan izin koneksi VPN yang diminta Gnirehtet.

### Komponen yang digunakan

| Komponen | Fungsi |
|---|---|
| CMD / Batch Script | Mengotomatisasi proses instalasi |
| Android Platform Tools | Menyediakan ADB untuk komunikasi dengan Android |
| Gnirehtet | Menyediakan fungsi reverse tethering |
| APK Gnirehtet | Aplikasi pendamping pada Android |
| `certutil` | Memeriksa nilai SHA-256 |
| `tar.exe` atau 7-Zip | Mengekstrak arsip ZIP |

---

## 6. Persiapan Android

Ikuti langkah berikut sebelum menjalankan installer.

### Langkah 1 — Aktifkan Developer Options

Pada kebanyakan ponsel Android:

1. Buka **Settings / Pengaturan**.
2. Masuk ke **About Phone / Tentang Ponsel**.
3. Cari bagian versi perangkat lunak atau nomor bentukan.
4. Ketuk nomor bentukan beberapa kali sampai Developer Options aktif.

Nama menu dapat berbeda tergantung merek dan versi Android.

### Langkah 2 — Aktifkan USB Debugging

1. Buka Settings.
2. Masuk ke Developer Options.
3. Aktifkan **USB Debugging**.
4. Sambungkan ponsel ke komputer dengan kabel USB data.
5. Jika muncul permintaan otorisasi debugging, periksa komputer yang meminta akses lalu pilih Allow jika memang komputer milik atau dipercaya oleh Anda.

Jangan memberikan otorisasi ADB kepada komputer yang tidak dikenal.

### Langkah 3 — Periksa mode USB

Jika tersedia, pilih mode transfer data seperti File Transfer/MTP. Tidak semua perangkat membutuhkan pengaturan yang sama.

---

## 7. Cara Instalasi

### Langkah 1 — Unduh repository

Buka repository GitHub ini, kemudian pilih:

**Code → Download ZIP**

Ekstrak arsip repository ke folder yang mudah ditemukan.

Alternatifnya, jika Git tersedia:

```cmd
git clone https://github.com/USERNAME/REPOSITORY.git
```

Ganti `USERNAME/REPOSITORY` dengan alamat repository milik Anda.

### Langkah 2 — Periksa skrip

Buka `Install-Gnirehtet.cmd` menggunakan Notepad.

Pastikan URL unduhan, versi Gnirehtet, dan nilai SHA-256 sesuai dengan sumber resmi yang digunakan.

Jangan menjalankan skrip yang sumbernya tidak dipercaya.

### Langkah 3 — Jalankan installer

1. Hubungkan ponsel ke komputer.
2. Aktifkan USB Debugging.
3. Klik kanan `Install-Gnirehtet.cmd`.
4. Pilih **Run as administrator** jika diperlukan.
5. Ikuti instruksi yang tampil pada CMD.
6. Perhatikan pesan kesalahan jika proses berhenti.

Installer menggunakan direktori kerja:

```text
C:\ReverseUSB
```

Komponen yang diunduh akan ditempatkan pada direktori tersebut.

### Langkah 4 — Otorisasi Android

Ketika skrip menampilkan daftar perangkat, periksa statusnya.

Contoh perangkat yang terotorisasi:

```text
List of devices attached
XXXXXXXX    device
```

Jika statusnya `unauthorized`, buka layar ponsel dan setujui permintaan otorisasi USB debugging.

Jangan melanjutkan sebelum perangkat terdeteksi dengan status `device`.

### Langkah 5 — Izinkan koneksi VPN

Setelah APK terpasang dan Gnirehtet berjalan, Android dapat menampilkan permintaan untuk membuat koneksi VPN.

Baca permintaan tersebut dan pilih Allow jika Anda ingin mengaktifkan reverse tethering.

Android dapat menampilkan ikon VPN selama koneksi aktif. Hal ini merupakan bagian dari mekanisme Gnirehtet.

---

## 8. Cara Menggunakan

Setelah instalasi berhasil:

1. Pastikan komputer masih terhubung ke internet.
2. Sambungkan ponsel melalui kabel USB data.
3. Pastikan USB debugging masih aktif.
4. Jalankan skrip.
5. Setujui permintaan VPN di Android.
6. Tunggu sampai Gnirehtet menunjukkan koneksi aktif.
7. Uji akses internet menggunakan browser pada ponsel.

Jika koneksi berhasil, ponsel akan menggunakan jalur reverse tethering yang disediakan oleh Gnirehtet.

**Penting:** jendela CMD yang menjalankan Gnirehtet harus tetap terbuka selama sesi tersebut berlangsung. Jika proses dihentikan, koneksi reverse tethering dapat terputus.

---

## 9. Cara Menghentikan Koneksi

Untuk menghentikan sesi:

1. Fokuskan jendela CMD yang menjalankan Gnirehtet.
2. Tekan `Ctrl + C`.
3. Konfirmasikan penghentian jika diminta.
4. Jika perlu, putuskan koneksi VPN Gnirehtet melalui pengaturan Android.

Untuk menggunakan koneksi lagi, jalankan skrip dan setujui kembali permintaan VPN apabila muncul.

---

## 10. Pemecahan Masalah

### A. Perangkat tidak terdeteksi

**Gejala:** daftar ADB kosong.

Solusi:

1. Pastikan kabel USB mendukung data.
2. Coba port USB lain.
3. Aktifkan USB Debugging.
4. Periksa driver perangkat pada Windows.
5. Jalankan kembali installer.

### B. Status perangkat `unauthorized`

**Penyebab:** ponsel belum menyetujui akses debugging komputer.

Solusi:

1. Buka layar ponsel.
2. Cari dialog USB debugging.
3. Verifikasi komputer yang meminta akses.
4. Pilih Allow jika dipercaya.
5. Jalankan ulang skrip.

### C. Unduhan gagal

**Kemungkinan penyebab:**

- Internet komputer tidak aktif.
- Situs unduhan tidak dapat dijangkau.
- Proxy atau firewall memblokir koneksi.
- Versi Windows tidak mendukung metode TLS yang diperlukan.

Solusi:

1. Uji koneksi internet komputer.
2. Pastikan URL unduhan resmi masih valid.
3. Periksa pengaturan proxy dan firewall.
4. Coba pada sistem Windows yang lebih baru jika utilitas lama tidak mendukung koneksi.

### D. SHA-256 tidak cocok

**Jangan lanjutkan ekstraksi file tersebut.**

Hapus arsip yang gagal diverifikasi, periksa kembali URL unduhan dan nilai hash resmi, lalu unduh ulang.

Nilai SHA-256 hanya membantu memeriksa kesesuaian file terhadap nilai pembanding. Keaslian pembanding tetap bergantung pada sumber yang dipercaya.

### E. ZIP tidak dapat diekstrak

Pastikan `tar.exe` atau 7-Zip tersedia. Periksa juga apakah arsip diunduh secara lengkap dan tidak rusak.

### F. Instalasi APK gagal

Periksa:

- Status perangkat ADB.
- Koneksi USB.
- Ruang penyimpanan perangkat.
- Pesan kesalahan yang ditampilkan ADB.
- Kompatibilitas perangkat dengan Gnirehtet.

### G. Gnirehtet terputus

Kemungkinan penyebabnya adalah kabel USB terlepas, proses CMD berhenti, ADB kehilangan koneksi, atau koneksi VPN Android dihentikan.

Sambungkan kembali perangkat, pastikan ADB mendeteksinya, kemudian jalankan ulang skrip.

### H. Ponsel terhubung tetapi internet tidak berfungsi

Periksa koneksi internet komputer terlebih dahulu. Setelah itu, periksa status Gnirehtet, permintaan VPN Android, dan log CMD.

Jangan menganggap pesan bahwa perangkat berhasil tersambung sebagai bukti bahwa semua tujuan jaringan dapat diakses.

---

## 11. Batasan dan Keamanan

### Batasan

- Proyek ini dirancang untuk reverse tethering komputer ke Android, bukan tethering biasa dari Android ke komputer.
- Keberhasilan bergantung pada versi Windows, driver USB, kompatibilitas Android, dan kondisi jaringan.
- CMD tidak menyediakan seluruh fungsi pengunduhan dan ekstraksi secara mandiri; utilitas pendukung tetap diperlukan.
- Gnirehtet tidak otomatis membagikan koneksi tersebut ke perangkat lain melalui hotspot Android.
- Dukungan IPv6 tidak disediakan oleh Gnirehtet.
- Tidak ada jaminan bahwa semua aplikasi Android akan menggunakan jalur jaringan dengan cara yang sama.

### Keamanan

- Unduh komponen dari sumber resmi.
- Verifikasi integritas arsip sebelum ekstraksi.
- Periksa isi skrip sebelum menjalankannya.
- Jangan menyetujui permintaan USB debugging dari komputer yang tidak dikenal.
- Pahami izin VPN yang diberikan pada Android.
- Jangan menonaktifkan fitur keamanan sistem tanpa alasan yang jelas.

Jika perangkat atau kebijakan organisasi membatasi USB debugging atau koneksi VPN, patuhi kebijakan tersebut.

---

## 12. Teknologi yang Digunakan

- **Windows Batch Script (`.cmd`)** — otomasi instalasi dan pemeriksaan.
- **Android Debug Bridge (ADB)** — komunikasi dengan perangkat Android.
- **Gnirehtet** — implementasi reverse tethering Android.
- **SHA-256** — pemeriksaan integritas arsip.
- **curl / BITSAdmin** — pengunduhan berkas.
- **tar / 7-Zip** — ekstraksi arsip ZIP.

Skrip ini tidak menggunakan PowerShell sebagai bagian dari alur instalasi.

---

## 13. Sumber Resmi

- Gnirehtet — https://github.com/Genymobile/gnirehtet
- Android SDK Platform Tools — https://developer.android.com/tools/releases/platform-tools
- 7-Zip — https://www.7-zip.org/

Periksa dokumentasi sumber resmi untuk informasi kompatibilitas, pembaruan, dan perubahan metode instalasi.

---

## 14. Lisensi dan Atribusi

Gnirehtet merupakan proyek pihak ketiga yang dikembangkan oleh Genymobile. Proyek ini menyediakan skrip otomasi untuk mempermudah pemasangan dan penggunaannya pada Windows.

Skrip installer yang terdapat dalam repository ini harus memiliki lisensi yang dinyatakan secara jelas oleh pemilik repository. Jangan menganggap lisensi Gnirehtet otomatis menjadi lisensi skrip ini.

Sebelum mendistribusikan ulang komponen pihak ketiga, periksa lisensi dan ketentuan distribusinya pada sumber resmi.

---

## Penutup

Tujuan proyek ini adalah menyederhanakan penggunaan reverse USB tethering bagi pengguna Windows, khususnya pengguna yang belum terbiasa dengan konfigurasi ADB dan instalasi manual.

Dengan mengotomatisasi langkah-langkah utama, pengguna dapat melakukan persiapan koneksi melalui satu skrip CMD, sambil tetap memperoleh pemeriksaan kesalahan dan petunjuk dasar ketika proses gagal.

**Proyek ini merupakan alat bantu otomasi, bukan jaminan bahwa setiap perangkat dan konfigurasi jaringan akan berhasil tanpa kendala.**

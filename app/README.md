## Preloved - Marketplace Barang Bekas Mahasiswa
Nama: Muhammad Ridwan
Nim: 1202200297
Kelompok/Individu: 10
## 1. Deskripsi Aplikasi

Preloved adalah aplikasi marketplace berbasis mobile yang dibuat untuk membantu mahasiswa mencari dan menawarkan barang bekas yang masih layak digunakan.

Melalui aplikasi ini, mahasiswa dapat melihat berbagai barang yang tersedia, seperti buku, perlengkapan kuliah, elektronik, dan kebutuhan kos. Setiap barang dilengkapi dengan informasi nama, kategori, kondisi, harga, deskripsi, serta nama penjual.

Aplikasi ini dikembangkan menggunakan Flutter untuk bagian mobile, sedangkan pengelolaan data barang dilakukan melalui REST API yang dibangun menggunakan Dart Shelf.

## 2. Fitur Aplikasi

Beberapa fitur yang tersedia dalam aplikasi Preloved antara lain:

- Melihat daftar barang preloved.
- Melihat informasi detail setiap barang.
- Menampilkan barang berdasarkan kategori.
- Memfilter barang berdasarkan rentang harga.
- Menambahkan barang melalui formulir.
- Menyimpan barang ke halaman favorit.
- Berpindah halaman menggunakan NavigationBar dan IndexedStack.
- Mengubah tampilan antara Light Mode dan Dark Mode.
- Mengambil data barang melalui REST API.
- Menampilkan indikator loading dan pesan error ketika data gagal dimuat, termasuk tombol untuk mencoba kembali.
- Memperbarui daftar barang menggunakan fitur pull-to-refresh pada halaman Beranda.

Catatan: Barang yang ditambahkan melalui formulir dan favorit masih disimpan sementara di memori aplikasi. Data  belum tersimpan secara permanen.

## 3. Teknologi yang Digunakan

Mobile Application
- Flutter
- Dart
- Material Design 3
- HTTP Package
- Poppins Font

REST API
- Dart
- Shelf
- Shelf Router
- JSON

Development Tools
- Visual Studio Code
- Android Studio Emulator
- Postman dan Web Browser

## 4. Struktur Proyek

Berikut struktur folder utama yang digunakan dalam pengembangan aplikasi:


preloved/
├── app/
│   ├── assets/
│   │   ├── icon/
│   │   └── images/
│   ├── lib/
│   │   ├── models/
│   │   ├── screens/
│   │   ├── services/
│   │   ├── utils/
│   │   └── main.dart
│   ├── test/
│   └── pubspec.yaml
│
├── server/
│   ├── bin/
│   │   └── server.dart
│   ├── data/
│   │   └── barang.json
│   └── pubspec.yaml
│
├── screenshots/
└── README.md


## 5. Cara Menjalankan REST API

Untuk menjalankan REST API, ikuti langkah berikut:

1. Buka terminal pada folder 'server'.
2. Unduh seluruh dependency dengan perintah:
   dart pub get

3. Jalankan server menggunakan perintah:
   dart run

4. Jika berhasil, server akan berjalan pada port'8080'.

Alamat API untuk pengujian melalui browser:
http://localhost:8080

 Daftar Endpoint

| Method | Endpoint | Keterangan |
|---|---|---|
| GET |'/barang'|Mengambil seluruh data barang |
| GET |/barang/{id} | Mengambil detail barang berdasarkan ID |
| GET |/kategori/{nama} | Mengambil barang berdasarkan kategori |

## 6. Cara Menjalankan Aplikasi Flutter

Pastikan REST API sudah berjalan sebelum menjalankan aplikasi mobile.

Langkah-langkahnya:

1. Buka terminal pada folder 'app'.
2. Unduh dependency Flutter:
   flutter pub get

3. Pastikan Android Emulator sudah aktif dan REST API sedang berjalan.
4. Jalankan aplikasi menggunakan perintah:
   flutter run --dart-define=API_URL=http://10.0.2.2:8080

Alamat 10.0.2.2 digunakan oleh Android Emulator untuk mengakses server yang berjalan pada komputer host.

## 7. Pengujian Aplikasi

Pengujian dilakukan untuk memastikan fitur aplikasi dan komunikasi dengan REST API dapat berjalan sesuai harapan.

Pengujian yang digunakan meliputi:

- Widget Test: Memeriksa komponen dan perilaku antarmuka aplikasi.
- MockClient Test: Menguji proses pengambilan data dari REST API menggunakan respons simulasi.
- Flutter Analyze: Memeriksa kode untuk menemukan kesalahan dan masalah lainnya.

Untuk menjalankan pengujian, gunakan perintah berikut dari folder 'app':

flutter analyze
flutter test

Hasil pengujian terakhir:
- Flutter Analyze: No issues found.
- Flutter Test: 5 tests passed.

 ## 8. Dokumentasi Screenshot

Beberapa tampilan aplikasi Preloved disertakan dalam folder 'Screenshots/' sebagai dokumentasi hasil pengembangan.

Screenshot yang disertakan meliputi:

1. Halaman Beranda.
2. Halaman Kategori.
3. Halaman Detail Barang.
4. Halaman Tambah Barang.
5. Halaman Favorit.
6. Halaman Profil.
7. Tampilan Light Mode dan Dark Mode.

9. Informasi Proyek

| Keterangan | Detail |
|---|---|
| Nama Aplikasi | Preloved |
| Platform | Android |
| Framework | Flutter |
| Bahasa Pemrograman | Dart |
| Backend | Dart Shelf REST API |
| Versi Aplikasi | 1.0.0 |

## 9. Screenshots

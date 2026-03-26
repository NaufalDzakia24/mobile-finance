#  Personal Finance & Profile App

Aplikasi pencatatan keuangan dan manajemen profil yang dibangun menggunakan **Flutter** dengan sistem penyimpanan **SQLite** secara full offline.

##  Tech Stack & Dependencies

Aplikasi ini menggunakan beberapa library utama untuk mendukung performa dan fungsionalitas:

| Library | Kegunaan |
| :--- | :--- |
| **sqflite** | Database lokal (SQLite) untuk menyimpan data profil dan transaksi secara permanen di HP. |
| **path_provider** | Menangani lokasi penyimpanan file di sistem Android/iOS secara otomatis. |
| **image_picker** | Mengambil gambar dari Galeri atau Kamera untuk foto profil. |
| **path** | Membantu manajemen lokasi folder/file agar tidak terjadi error lintas platform. |

##  Penanganan Gambar (Base64)
Aplikasi ini menggunakan metode **Base64 Encoding** untuk menyimpan foto profil. 
* **Alasannya:** Gambar diubah menjadi barisan teks (String) sehingga bisa disimpan langsung di dalam satu tabel SQLite bersama data teks lainnya (Nama, Bio, dll). Ini membuat manajemen data menjadi lebih simpel dan efisien untuk data skala kecil.

## 🗄️ Cara Menarik Database ke VS Code (Debugging)
Karena database SQLite tersimpan di dalam folder sistem Android yang tersembunyi, kita menggunakan script `tarik_db.bat` untuk memindahkannya ke laptop.

### Langkah-langkah Konfigurasi:
1. **Pastikan Android SDK** sudah terinstal di komputer Anda.
2. **Cari file** bernama `tarik_db.bat.example` di folder utama proyek.
3. **Salin (Copy) dan Ubah Nama (Rename)** file tersebut menjadi `tarik_db.bat`.
4. **Buka file** `tarik_db.bat` menggunakan Notepad atau VS Code.
5. **Sesuaikan bagian `set ADB="..."`** dengan lokasi file `adb.exe` Anda (Umumnya berada di folder `platform-tools` dalam Android SDK).
6. **Pastikan `set PKG="..."`** sesuai dengan `applicationId` yang tertera pada file `android/app/build.gradle`.
7. **Konfigurasi Jalur Simpan (`set LOCAL_PATH`)**: Baris ini menggunakan kode `%~dp0` untuk memastikan hasil tarikan database (`finance_app.db`) selalu tersimpan di folder yang sama dengan file script ini berada. Anda tidak perlu mengubah bagian ini karena sudah diatur secara dinamis.


### Cara Menjalankan Penarikan Data:
1. Hubungkan perangkat fisik atau Emulator ke komputer.
2. Aktifkan fitur **USB Debugging** pada perangkat Anda.
3. Jalankan file `tarik_db.bat` (Klik 2x atau melalui Terminal VS Code dengan perintah ./tarik_db.bat).
4. File `finance_app.db` akan muncul secara otomatis di folder utama proyek Anda.
5. Gunakan ekstensi **SQLite Viewer** di VS Code untuk melihat isi tabel secara visual.
---

## 🚀 Cara Menjalankan Project
Jika Anda melakukan clone pada project ini, lakukan langkah berikut:
1. Jalankan `flutter pub get` untuk mendownload semua library.
2. Pastikan file `tarik_db.bat` sudah disesuaikan path ADB-nya.
3. Jalankan aplikasi dengan `flutter run`.
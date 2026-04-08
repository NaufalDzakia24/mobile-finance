import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../models/goal_model.dart';
import '../../../models/transaction_model.dart';
import '../../../models/profile_model.dart';

class DatabaseHelper {
  // Singleton instance untuk memastikan hanya ada satu koneksi database
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Getter database dengan sistem lazy loading
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('finance_app.db');
    return _database!;
  }

  // Inisialisasi database dan konfigurasi versi
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 7, // Versi terbaru dengan dukungan Bio, Hobby, & Video
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // Membuat tabel-tabel utama saat aplikasi pertama kali dijalankan (Fresh Install)
  Future _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE goals (id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT NOT NULL, title TEXT NOT NULL, currentAmount REAL NOT NULL, targetAmount REAL NOT NULL)');
    await db.execute('CREATE TABLE transactions (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, category TEXT NOT NULL, date TEXT NOT NULL, amount REAL NOT NULL, isExpense INTEGER NOT NULL)');

    // Hati-hati: Pastikan ada koma di setiap akhir baris kecuali yang paling bawah
    await db.execute('''
      CREATE TABLE profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        fullName TEXT NOT NULL, 
        nickname TEXT NOT NULL, 
        email TEXT NOT NULL, 
        phoneNumber TEXT NOT NULL, 
        birthDate TEXT NOT NULL, 
        gender TEXT NOT NULL,
        profilePicture TEXT NOT NULL,
        bio TEXT NOT NULL,
        hobby TEXT NOT NULL,
        videoPath TEXT NOT NULL
      )
    ''');
    
    // Seed data: Mengisi profil default saat database pertama kali dibuat
    await db.insert('profile', {
      'fullName': 'Pengguna Baru',
      'nickname': 'Pengguna',
      'email': 'user@email.com',
      'phoneNumber': '-',
      'birthDate': '-',
      'gender': 'Laki-laki',
      'profilePicture': '',
      'bio': 'Fokus mendalami Web Development & Flutter', 
      'hobby': 'Membuat Chrome Extension',
      'videoPath': '', // Default kosong
    });
  }

  // Menangani perubahan struktur tabel (migrasi) jika user update aplikasi
  // Fungsi ini menggabungkan semua logika upgrade versi sebelumnya
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    print("DEBUG: Mengupgrade DB dari $oldVersion ke $newVersion");

    // Jika update dari versi yang sangat lama (< 6)
    if (oldVersion < 6) {
      await db.execute('DROP TABLE IF EXISTS profile'); 
      
      await db.execute('''
        CREATE TABLE profile (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          fullName TEXT NOT NULL, 
          nickname TEXT NOT NULL, 
          email TEXT NOT NULL, 
          phoneNumber TEXT NOT NULL, 
          birthDate TEXT NOT NULL, 
          gender TEXT NOT NULL,
          profilePicture TEXT NOT NULL,
          bio TEXT NOT NULL,
          hobby TEXT NOT NULL
        )
      ''');
      
      await db.insert('profile', {
        'fullName': 'Pengguna Baru',
        'nickname': 'Pengguna',
        'email': 'user@email.com',
        'phoneNumber': '-',
        'birthDate': '-',
        'gender': 'Laki-laki',
        'profilePicture': '',
        'bio': 'Fokus mendalami Web Development & Flutter', 
        'hobby': 'Membuat Chrome Extension', 
      });
    }

    // Jika update dari versi 6 ke 7 (Penambahan Fitur Video)
    if (oldVersion < 7) {
      // Tambahkan DEFAULT '' agar SQLite tidak error saat membaca baris lama
      await db.execute("ALTER TABLE profile ADD COLUMN videoPath TEXT DEFAULT ''");
      print("DEBUG: Kolom videoPath berhasil ditambahkan ke tabel profile");
    }
  }

  // ================= FUNGSI PROFILE =================

  // Mengambil data profil tunggal (ID 1)
  Future<ProfileModel> getProfile() async {
    final db = await instance.database;
    final maps = await db.query('profile', where: 'id = ?', whereArgs: [1]);

    if (maps.isNotEmpty) {
      return ProfileModel.fromMap(maps.first);
    } else {
      // Pastikan semua parameter Model terpenuhi jika database kosong
      return ProfileModel(
        fullName: 'Pengguna', nickname: 'User', email: '-', phoneNumber: '-',
        birthDate: '-', gender: 'Laki-laki', profilePicture: '',
        bio: '-', hobby: '-', videoPath: ''
      );
    }
  }

  // Memperbarui informasi profil pengguna
  Future<int> updateProfile(ProfileModel profile) async {
    final db = await instance.database;
    return await db.update('profile', profile.toMap(), where: 'id = ?', whereArgs: [1]);
  }

  // ================= FUNGSI GOALS (TARGET) =================

  Future<int> insertGoal(GoalModel goal) async {
    final db = await instance.database;
    return await db.insert('goals', goal.toMap());
  }

  Future<List<GoalModel>> getAllGoals() async {
    final db = await instance.database;
    final result = await db.query('goals', orderBy: 'id DESC');
    return result.map((json) => GoalModel.fromMap(json)).toList();
  }

  // ================= FUNGSI TRANSAKSI =================

  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await instance.database;
    return await db.insert('transactions', transaction.toMap());
  }

  // Mengambil riwayat transaksi, mendukung parameter 'limit' untuk Dashboard
  Future<List<TransactionModel>> getTransactions({int? limit}) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      orderBy: 'id DESC',
      limit: limit,
    );
    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  // Menghitung ringkasan Pemasukan, Pengeluaran, dan Saldo Akhir
  Future<Map<String, double>> getBalanceSummary() async {
    final db = await instance.database;

    final incomeQuery = await db.rawQuery(
      "SELECT SUM(amount) as total FROM transactions WHERE isExpense = 0",
    );
    double income = (incomeQuery.first['total'] as num?)?.toDouble() ?? 0.0;

    final expenseQuery = await db.rawQuery(
      "SELECT SUM(amount) as total FROM transactions WHERE isExpense = 1",
    );
    double expense = (expenseQuery.first['total'] as num?)?.toDouble() ?? 0.0;

    return {'income': income, 'expense': expense, 'balance': income - expense};
  }
}
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../models/goal_model.dart';
import '../../../models/transaction_model.dart';
import '../../../models/profile_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('finance_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 6, // Versi 6 sudah lengkap dengan Bio & Hobi
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // Dipanggil KETIKA APLIKASI BARU DI-INSTALL (Fresh Install)
  Future _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE goals (id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT NOT NULL, title TEXT NOT NULL, currentAmount REAL NOT NULL, targetAmount REAL NOT NULL)');
    await db.execute('CREATE TABLE transactions (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, category TEXT NOT NULL, date TEXT NOT NULL, amount REAL NOT NULL, isExpense INTEGER NOT NULL)');

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

  // Dipanggil KETIKA UPDATE DARI VERSI LAMA (Biar data goals/transaksi ga ilang & ga error)
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 6) {
      await db.execute('DROP TABLE IF EXISTS profile'); 
      
      // BIKIN ULANG TABEL PROFILE SAJA (Jangan panggil _createDB biar ga bentrok)
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
  }

  // ================= FUNGSI UNTUK PROFILE =================
  Future<ProfileModel> getProfile() async {
    final db = await instance.database;
    final maps = await db.query('profile', where: 'id = ?', whereArgs: [1]);

    if (maps.isNotEmpty) {
      return ProfileModel.fromMap(maps.first);
    } else {
      return ProfileModel(
        fullName: 'Pengguna', nickname: 'User', email: '-', phoneNumber: '-',
        birthDate: '-', gender: 'Laki-laki', profilePicture: '',
        bio: '-', hobby: '-'
      );
    }
  }

  Future<int> updateProfile(ProfileModel profile) async {
    final db = await instance.database;
    return await db.update('profile', profile.toMap(), where: 'id = ?', whereArgs: [1]);
  }

  // ================= FUNGSI UNTUK GOALS =================

  Future<int> insertGoal(GoalModel goal) async {
    final db = await instance.database;
    final id = await db.insert('goals', goal.toMap());
    print('DEBUG: Berhasil simpan ke DB dengan ID: $id');
    return id;
  }

  Future<List<GoalModel>> getAllGoals() async {
    final db = await instance.database;
    final result = await db.query('goals', orderBy: 'id DESC');
    return result.map((json) => GoalModel.fromMap(json)).toList();
  }

  // ================= FUNGSI UNTUK TRANSAKSI =================

  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await instance.database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getTransactions({int? limit}) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      orderBy: 'id DESC',
      limit: limit,
    );
    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  Future<Map<String, double>> getBalanceSummary() async {
    final db = await instance.database;

    // Total Pemasukan
    final incomeQuery = await db.rawQuery(
      "SELECT SUM(amount) as total FROM transactions WHERE isExpense = 0",
    );
    double income = (incomeQuery.first['total'] as num?)?.toDouble() ?? 0.0;

    // Total Pengeluaran
    final expenseQuery = await db.rawQuery(
      "SELECT SUM(amount) as total FROM transactions WHERE isExpense = 1",
    );
    double expense = (expenseQuery.first['total'] as num?)?.toDouble() ?? 0.0;

    return {'income': income, 'expense': expense, 'balance': income - expense};
  }
}
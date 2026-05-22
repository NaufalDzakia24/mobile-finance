import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../models/goal_model.dart';
import '../../../models/transaction_model.dart';
import '../../../models/profile_model.dart';
import '../../../models/user_model.dart';

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
      version:
          10, // NAIK KE VERSI 10: Untuk menambahkan kolom groupImage di tabel groups
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // Membuat tabel-tabel utama saat aplikasi pertama kali dijalankan (Fresh Install)
  Future _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE goals (id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT NOT NULL, title TEXT NOT NULL, currentAmount REAL NOT NULL, targetAmount REAL NOT NULL)',
    );
    await db.execute(
      'CREATE TABLE transactions (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, category TEXT NOT NULL, date TEXT NOT NULL, amount REAL NOT NULL, isExpense INTEGER NOT NULL)',
    );

    // Tabel Users untuk menampung data akun (Register/Login)
    await db.execute(
      'CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, email TEXT UNIQUE NOT NULL, password TEXT NOT NULL)',
    );

    // Tabel Profile
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

    // Tabel Groups (Nama Tim) - DITAMBAHKAN KOLOM groupImage
    await db.execute(
      'CREATE TABLE groups (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, creatorEmail TEXT NOT NULL, groupImage TEXT DEFAULT "")',
    );

    // Tabel Group Members (Anggota Tim)
    await db.execute(
      'CREATE TABLE group_members (id INTEGER PRIMARY KEY AUTOINCREMENT, groupId INTEGER NOT NULL, userEmail TEXT NOT NULL)',
    );
  }

  // Menangani perubahan struktur tabel (migrasi) jika user update aplikasi
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    print("DEBUG: Mengupgrade DB dari $oldVersion ke $newVersion");

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
    }

    if (oldVersion < 7) {
      await db.execute(
        "ALTER TABLE profile ADD COLUMN videoPath TEXT DEFAULT ''",
      );
      print("DEBUG: Kolom videoPath berhasil ditambahkan ke tabel profile");
    }

    if (oldVersion < 8) {
      await db.execute(
        'CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, email TEXT UNIQUE NOT NULL, password TEXT NOT NULL)',
      );
      print("DEBUG: Tabel users berhasil ditambahkan");
    }

    if (oldVersion < 9) {
      await db.execute(
        'CREATE TABLE groups (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, creatorEmail TEXT NOT NULL)',
      );
      await db.execute(
        'CREATE TABLE group_members (id INTEGER PRIMARY KEY AUTOINCREMENT, groupId INTEGER NOT NULL, userEmail TEXT NOT NULL)',
      );
      print("DEBUG: Tabel groups dan group_members berhasil ditambahkan");
    }

    // UPDATE VERSI 10: Tambah kolom groupImage di tabel groups (jika aplikasi sudah pernah terinstall di versi 9)
    if (oldVersion < 10) {
      try {
        await db.execute(
          "ALTER TABLE groups ADD COLUMN groupImage TEXT DEFAULT ''",
        );
        print("DEBUG: Kolom groupImage berhasil ditambahkan ke tabel groups");
      } catch (e) {
        print("DEBUG: Kolom groupImage mungkin sudah ada. Error: $e");
      }
    }
  }

  // ================= FUNGSI AUTHENTICATION (LOGIN & REGISTER) =================

  Future<int> registerUser(UserModel user) async {
    final db = await instance.database;
    try {
      return await db.insert('users', user.toMap());
    } catch (e) {
      return -1;
    }
  }

  Future<UserModel?> loginUser(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    } else {
      return null;
    }
  }

  // ================= FUNGSI PROFILE =================

  Future<ProfileModel> getProfile(String userEmail) async {
    final db = await instance.database;
    final maps = await db.query(
      'profile',
      where: 'email = ?',
      whereArgs: [userEmail],
    );

    if (maps.isNotEmpty) {
      return ProfileModel.fromMap(maps.first);
    } else {
      String realName = 'Pengguna Baru';
      String nickname = 'Pengguna';

      final userMaps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [userEmail],
      );
      if (userMaps.isNotEmpty) {
        realName = userMaps.first['name'] as String;
        if (realName.contains(' ')) {
          nickname = realName.split(' ')[0];
        } else {
          nickname = realName;
        }
      }

      final newProfileData = {
        'fullName': realName,
        'nickname': nickname,
        'email': userEmail,
        'phoneNumber': '-',
        'birthDate': '-',
        'gender': 'Laki-laki',
        'profilePicture': '',
        'bio': '-',
        'hobby': '-',
        'videoPath': '',
      };

      int newId = await db.insert('profile', newProfileData);

      return ProfileModel(
        id: newId,
        fullName: realName,
        nickname: nickname,
        email: userEmail,
        phoneNumber: '-',
        birthDate: '-',
        gender: 'Laki-laki',
        profilePicture: '',
        bio: '-',
        hobby: '-',
        videoPath: '',
      );
    }
  }

  Future<int> updateProfile(ProfileModel profile) async {
    final db = await instance.database;
    return await db.update(
      'profile',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
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

  // ================= FUNGSI USER / PENGGUNA =================

  Future<List<UserModel>> getAllUsers(String excludeEmail) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email != ?',
      whereArgs: [excludeEmail],
      orderBy: 'name ASC',
    );
    return result.map((json) => UserModel.fromMap(json)).toList();
  }

  // ================= FUNGSI GROUP TIM (BARU) =================

  // 1. Membuat Grup Baru (Mengembalikan ID grup yang baru dibuat)
  // UBAH: Ditambahkan parameter {String? groupImage}
  Future<int> createGroup(
    String name,
    String creatorEmail, {
    String? groupImage,
  }) async {
    final db = await instance.database;
    return await db.insert('groups', {
      'name': name,
      'creatorEmail': creatorEmail,
      'groupImage': groupImage ?? '', // Menyimpan gambar base64
    });
  }

  // 2. Menambah Anggota ke Grup
  Future<void> addMemberToGroup(int groupId, String userEmail) async {
    final db = await instance.database;
    // Cek apakah user tersebut sudah ada di dalam grup (mencegah duplikat)
    final exist = await db.query(
      'group_members',
      where: 'groupId = ? AND userEmail = ?',
      whereArgs: [groupId, userEmail],
    );

    if (exist.isEmpty) {
      await db.insert('group_members', {
        'groupId': groupId,
        'userEmail': userEmail,
      });
    }
  }

  // 3. Mengambil Semua Grup di mana Saya Menjadi Anggota (Pembuat maupun Undangan)
  Future<List<Map<String, dynamic>>> getMyGroups(String myEmail) async {
    final db = await instance.database;

    // Menggunakan INNER JOIN: Ambil data grup JIKA email saya ada di dalam tabel group_members untuk grup tersebut
    final result = await db.rawQuery(
      '''
      SELECT groups.* FROM groups 
      INNER JOIN group_members ON groups.id = group_members.groupId 
      WHERE group_members.userEmail = ?
    ''',
      [myEmail],
    );

    return result;
  }

  // 4. Mengambil Semua Anggota dalam Satu Grup Tertentu
  Future<List<UserModel>> getGroupMembers(int groupId) async {
    final db = await instance.database;
    // Menggunakan INNER JOIN untuk menggabungkan tabel user dan group_members
    final result = await db.rawQuery(
      '''
      SELECT users.* FROM users 
      INNER JOIN group_members ON users.email = group_members.userEmail 
      WHERE group_members.groupId = ?
    ''',
      [groupId],
    );

    return result.map((json) => UserModel.fromMap(json)).toList();
  }
}

class ProfileModel {
  // 1. KERANGKA DATA
  // Kumpulan atribut yang mendefinisikan sebuah profil. 
  // 'id' boleh kosong (nullable) karena nanti diisi otomatis oleh database.
  final int? id;
  final String fullName;
  final String nickname;
  final String email;
  final String phoneNumber;
  final String birthDate;
  final String gender;
  final String profilePicture;
  final String bio;   
  final String hobby; 

  // Constructor: Syarat wajib saat kita mau membuat objek/data profil baru.
  ProfileModel({
    this.id,
    required this.fullName,
    required this.nickname,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.gender,
    required this.profilePicture,
    required this.bio,   
    required this.hobby, 
  });

  // 2. FUNGSI UNTUK MENYIMPAN KE DATABASE (Aplikasi -> Database)
  // Menerjemahkan objek ProfileModel menjadi Map (format 'Key': Value).
  // Database SQLite nggak paham objek Dart, dia cuma paham format Map ini.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'nickname': nickname,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'gender': gender,
      'profilePicture': profilePicture,
      'bio': bio,     
      'hobby': hobby, 
    };
  }

  // 3. FUNGSI UNTUK MENGAMBIL DARI DATABASE (Database -> Aplikasi)
  // Kebalikan dari toMap. Mengambil data mentah dari SQLite dan merakitnya 
  // kembali menjadi objek ProfileModel yang utuh biar bisa dipakai di UI.
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      // Tanda ?? '' adalah pengaman (Safety Net). 
      // Artinya: "Kalau datanya null/kosong dari DB, kasih aja teks kosong ('') biar aplikasi nggak crash."
      fullName: map['fullName'] ?? '',
      nickname: map['nickname'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      birthDate: map['birthDate'] ?? '',
      gender: map['gender'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      bio: map['bio'] ?? '',     
      hobby: map['hobby'] ?? '', 
    );
  }
}
class TeamMember {
  final String name;
  final String major;
  final String imageUrl;
  final List<String> hobbies;
  final String bio;
  final String videoUrl;
  final String nim;       // ← ganti dari email
  final String age;       // ← ganti dari batch
  final String city;      // ← ganti dari role
  final String emoji;

  TeamMember({
    required this.name,
    required this.major,
    required this.imageUrl,
    required this.hobbies,
    required this.bio,
    required this.videoUrl,
    required this.nim,
    required this.age,
    required this.city,
    required this.emoji,
  });
}

final List<TeamMember> teamMembers = [
  TeamMember(
    name: 'Naufal Dzakia Arkanudin',
    major: 'Informatics Engineering',
    imageUrl: 'assets/pal.jpg',
    hobbies: ['Coding', 'Gaming', 'Music', 'Open Source'],
    bio: 'Seorang pekerja di perusahaan retail yang juga menempuh pendidikan di bidang Informatika di Universitas Al Azhar adalah sosok yang mencerminkan kerja keras dan komitmen tinggi terhadap masa depan. Di satu sisi, ia menjalani rutinitas pekerjaan yang menuntut ketelitian, tanggung jawab, dan kemampuan melayani pelanggan dengan baik. Di sisi lain, ia tetap berjuang sebagai mahasiswa yang mempelajari dunia teknologi, mulai dari pemrograman, database, hingga perkembangan sistem informasi modern.',
    videoUrl: 'https://example.com/video1',
    nim: '0112524032',
    age: '21',
    city: 'Tangerang',
    emoji: '🚀',
  ),
  TeamMember(
    name: 'Dany Triadi Widagdo',
    major: 'Informatics Engineering',
    imageUrl: 'assets/dani.jpg',
    hobbies: ['Design', 'Photography', 'Art', 'Illustration'],
    bio: 'Seorang pekerja di suatu perusahaan makanan di cikarang, dan seorang mahasiswa informatika universitas al azhar indonesia yang sedang ingin menempuh jenjang karir yang lebih baik.',
    videoUrl: 'https://example.com/video2',
    nim: '0112524011',
    age: '22',
    city: 'Karawang',
    emoji: '🎨',
  ),
  TeamMember(
    name: 'Nia Astuti',
    major: 'Informatics Engineering',
    imageUrl: 'assets/nia.jpg',
    hobbies: ['Data Science', 'Reading', 'Coffee', 'Chess'],
    bio: 'Mahasiswa semester 6 yang bekerja di bidang infrastruktur telekomunikasi dan tertarik mengembangkan karier di dunia IT.',
    videoUrl: 'https://example.com/video3',
    nim: '0112523027',
    age: '21',
    city: 'Pemalang',
    emoji: '📊',
  ),
  TeamMember(
    name: 'Muhammad Reinandy Zein',
    major: 'UI/UX Design',
    imageUrl: 'https://i.pravatar.cc/300?img=45',
    hobbies: ['UI Design', 'Travel', 'Yoga', 'Pottery'],
    bio: 'User experience advocate creating intuitive digital experiences users love.',
    videoUrl: 'https://example.com/video4',
    nim: '2021001004',
    age: '21',
    city: 'Yogyakarta',
    emoji: '✨',
  ),
 
];
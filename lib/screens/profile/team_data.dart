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
    imageUrl: 'https://i.pravatar.cc/300?img=12',
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
    imageUrl: 'https://i.pravatar.cc/300?img=47',
    hobbies: ['Design', 'Photography', 'Art', 'Illustration'],
    bio: 'Seorang pekerja di suatu perusahaan makanan di cikarang, dan seorang mahasiswa informatika universitas al azhar indonesia yang sedang ingin menempuh jenjang karir yang lebih baik.',
    videoUrl: 'https://example.com/video2',
    nim: '2020001002',
    age: '22',
    city: 'Bandung',
    emoji: '🎨',
  ),
  TeamMember(
    name: 'Budi Santoso',
    major: 'Business Analytics',
    imageUrl: 'https://i.pravatar.cc/300?img=33',
    hobbies: ['Data Science', 'Reading', 'Coffee', 'Chess'],
    bio: 'Data enthusiast turning numbers into insights and solving complex business problems.',
    videoUrl: 'https://example.com/video3',
    nim: '2021001003',
    age: '21',
    city: 'Surabaya',
    emoji: '📊',
  ),
  TeamMember(
    name: 'Maya Kusuma',
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
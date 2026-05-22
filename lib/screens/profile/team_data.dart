class TeamMember {
  final String name;
  final String major;
  final String imageUrl;
  final List<String> hobbies;
  final String bio;
  final String videoUrl;
  final String nim;       
  final String city;     
  final String emoji;

  TeamMember({
    required this.name,
    required this.major,
    required this.imageUrl,
    required this.hobbies,
    required this.bio,
    required this.videoUrl,
    required this.nim,
    required this.city,
    required this.emoji,
  });
}

final List<TeamMember> teamMembers = [
  TeamMember(
    name: 'Naufal Dzakia Arkanudin',
    major: 'Informatics',
    imageUrl: 'assets/pal.jpg',
    hobbies: ['Coding', 'Gaming', 'Music', 'Open Source'],
    bio: 'Seorang pekerja di perusahaan retail yang juga menempuh pendidikan di bidang Informatika di Universitas Al Azhar adalah sosok yang mencerminkan kerja keras dan komitmen tinggi terhadap masa depan. Di satu sisi, ia menjalani rutinitas pekerjaan yang menuntut ketelitian, tanggung jawab, dan kemampuan melayani pelanggan dengan baik. Di sisi lain, ia tetap berjuang sebagai mahasiswa yang mempelajari dunia teknologi, mulai dari pemrograman, database, hingga perkembangan sistem informasi modern.',
    videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    nim: '0112524032',
    city: 'Tangerang',
    emoji: '🚀',
  ),
  TeamMember(
    name: 'Dany Triadi Widagdo',
    major: 'Informatics',
    imageUrl: 'assets/dani.jpg',
    hobbies: ['Design', 'Photography', 'Art', 'Illustration'],
    bio: 'Seorang pekerja di suatu perusahaan makanan di cikarang, dan seorang mahasiswa informatika universitas al azhar indonesia yang sedang ingin menempuh jenjang karir yang lebih baik.',
    videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    nim: '0112524011',
    city: 'Karawang',
    emoji: '🎨',
  ),
  TeamMember(
    name: 'Nia Astuti',
    major: 'Informatics',
    imageUrl: 'assets/nia.jpg',
    hobbies: ['Data Science', 'Drawing', 'Singing', 'Traveling'],
    bio: 'Mahasiswa semester 6 yang bekerja di bidang infrastruktur telekomunikasi dan tertarik mengembangkan karier di dunia IT.',
    videoUrl: 'https://github.com/niaastuti/Video/raw/refs/heads/main/WhatsApp%20Video%202026-04-14%20at%2001.21.25.mp4',
    nim: '0112523027',
    city: 'Pemalang',
    emoji: '🌼',
  ),
  TeamMember(
    name: 'Muhammad Reinandy Zein',
    major: 'Informatics',
    imageUrl: 'https://i.pravatar.cc/300?img=45',
    hobbies: ['UI/UX Design', 'Traveling', 'Yoga', 'Pottery'],
    bio: 'User experience advocate creating intuitive digital experiences users love.',
    videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    nim: '2021001004',
    city: 'Yogyakarta',
    emoji: '✨',
  ),
 
];
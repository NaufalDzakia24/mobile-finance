class TeamMember {
  final String name;
  final String major;
  final String imageUrl;
  final List<String> hobbies;
  final String bio;
  final String videoUrl;
  final String email;
  final String batch;
  final String role;
  final String emoji;

  TeamMember({
    required this.name,
    required this.major,
    required this.imageUrl,
    required this.hobbies,
    required this.bio,
    required this.videoUrl,
    required this.email,
    required this.batch,
    required this.role,
    required this.emoji,
  });
}

final List<TeamMember> teamMembers = [
  TeamMember(
    name: 'Naufal Dzakia',
    major: 'Computer Science',
    imageUrl: 'https://i.pravatar.cc/300?img=12',
    hobbies: ['Berenang', 'Gaming', 'Music', 'Open Source'],
    bio:
        'Passionate full-stack developer with love for clean code and innovative solutions. Always eager to learn new technologies and build impactful products.',
    videoUrl: 'https://example.com/video1',
    email: 'aditya.rahman@university.ac.id',
    batch: '2020',
    role: 'Full Stack Developer',
    emoji: '🚀',
  ),
  TeamMember(
    name: 'Siti Nurhaliza',
    major: 'Graphic Design',
    imageUrl: 'https://i.pravatar.cc/300?img=47',
    hobbies: ['Design', 'Photography', 'Art', 'Illustration'],
    bio:
        'Creative designer who loves bringing ideas to life through visual storytelling and user-centered design principles.',
    videoUrl: 'https://example.com/video2',
    email: 'siti.nurhaliza@university.ac.id',
    batch: '2020',
    role: 'UI/UX Designer',
    emoji: '🎨',
  ),
  TeamMember(
    name: 'Budi Santoso',
    major: 'Business Analytics',
    imageUrl: 'https://i.pravatar.cc/300?img=33',
    hobbies: ['Data Science', 'Reading', 'Coffee', 'Chess'],
    bio:
        'Data enthusiast turning numbers into insights. Love exploring patterns and solving complex business problems with analytics.',
    videoUrl: 'https://example.com/video3',
    email: 'budi.santoso@university.ac.id',
    batch: '2021',
    role: 'Data Analyst',
    emoji: '📊',
  ),
  TeamMember(
    name: 'Maya Kusuma',
    major: 'UI/UX Design',
    imageUrl: 'https://i.pravatar.cc/300?img=45',
    hobbies: ['UI Design', 'Travel', 'Yoga', 'Pottery'],
    bio:
        'User experience advocate creating intuitive and beautiful digital experiences that users genuinely love and keep coming back to.',
    videoUrl: 'https://example.com/video4',
    email: 'maya.kusuma@university.ac.id',
    batch: '2021',
    role: 'Product Designer',
    emoji: '✨',
  ),
  TeamMember(
    name: 'Rizki Pratama',
    major: 'Software Engineering',
    imageUrl: 'https://i.pravatar.cc/300?img=15',
    hobbies: ['Mobile Dev', 'Basketball', 'Gaming', 'Flutter'],
    bio:
        'Mobile developer crafting seamless cross-platform experiences. Flutter enthusiast and tech explorer always on the cutting edge.',
    videoUrl: 'https://example.com/video5',
    email: 'rizki.pratama@university.ac.id',
    batch: '2020',
    role: 'Mobile Developer',
    emoji: '📱',
  ),
  TeamMember(
    name: 'Dewi Anggraini',
    major: 'Marketing',
    imageUrl: 'https://i.pravatar.cc/300?img=48',
    hobbies: ['Social Media', 'Writing', 'Cooking', 'Podcast'],
    bio:
        'Digital marketer with a passion for storytelling and building meaningful brand connections that resonate with audiences.',
    videoUrl: 'https://example.com/video6',
    email: 'dewi.anggraini@university.ac.id',
    batch: '2021',
    role: 'Marketing Specialist',
    emoji: '📣',
  ),
];
class GoalModel {
  final int? id;
  final String category;
  final String title;
  final double currentAmount;
  final double targetAmount;

  GoalModel({
    this.id,
    required this.category,
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
  });

  // Kalkulasi otomatis untuk UI
  double get progress => (currentAmount / targetAmount).clamp(0.0, 1.0);

  // Mengubah Object menjadi Map (Untuk Insert ke SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'currentAmount': currentAmount,
      'targetAmount': targetAmount,
    };
  }

  // Mengubah Map dari SQLite menjadi Object GoalModel
  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'],
      category: map['category'],
      title: map['title'],
      currentAmount: map['currentAmount'],
      targetAmount: map['targetAmount'],
    );
  }
}
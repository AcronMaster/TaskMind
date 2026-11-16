class Task {
  final int? id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final DateTime duaDate;
  final bool isComplete;

  const Task({
    this.id,
    required this.title,
    this.description = '',
    required this.category,
    required this.priority,
    required this.duaDate,
    this.isComplete = false,
  });

  Task copyWhith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? priority,
    DateTime? duaDate,
    bool? isComplete,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      duaDate: duaDate ?? this.duaDate,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'duaDate': duaDate.toIso8601String(),
      'isComplete': isComplete ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      category: map['category'] as String,
      priority: map['priority'] as String,
      duaDate: DateTime.parse(map['duaDate'] as String),
      isComplete: map['isComplete'] == 1,
    );
  }
}

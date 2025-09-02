class Task {
  final String id;
  final String title;
  final String notes;
  final String priority; // 'high', 'medium', 'low'
  final String timeOfDay; // 'morning', 'afternoon', 'evening'
  final DateTime date;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Task({
    required this.id,
    required this.title,
    this.notes = '',
    required this.priority,
    required this.timeOfDay,
    required this.date,
    this.isCompleted = false,
    required this.createdAt,
    this.updatedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? notes,
    String? priority,
    String? timeOfDay,
    DateTime? date,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      priority: priority ?? this.priority,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'notes': notes,
      'priority': priority,
      'timeOfDay': timeOfDay,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      notes: map['notes'] ?? '',
      priority: map['priority'] ?? 'medium',
      timeOfDay: map['timeOfDay'] ?? 'morning',
      date: DateTime.parse(map['date']),
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final String priority;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    this.description = '',
    this.dueDate,
    this.priority = 'Moyenne',
    this.isCompleted = false,
  });

  Task copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    bool? isCompleted,
    bool clearDueDate = false,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      priority: json['priority'] as String? ?? 'Moyenne',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

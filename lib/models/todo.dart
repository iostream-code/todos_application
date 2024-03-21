import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String task;
  bool isDone;
  Timestamp createdAt;
  Timestamp updatedAt;

  Todo({
    required this.task,
    required this.isDone,
    required this.createdAt,
    required this.updatedAt,
  });

  Todo.fromJson(Map<String, Object?> json)
      : this(
          task: json['task']! as String,
          isDone: json['isDone']! as bool,
          createdAt: json['createdAt']! as Timestamp,
          updatedAt: json['updatedAt']! as Timestamp,
        );

  Todo copyWith({
    String? task,
    bool? isDone,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return Todo(
      task: task ?? this.task,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'task': task,
      'isDone': isDone,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

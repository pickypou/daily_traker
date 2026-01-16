import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({required super.id, required super.title, super.isCompleted});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'isCompleted': isCompleted};
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      isCompleted: entity.isCompleted,
    );
  }
}

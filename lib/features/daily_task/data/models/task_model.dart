import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    super.isCompleted,
    super.startTime,
    super.duration,
    super.notificationId,
  });

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      isCompleted: entity.isCompleted,
      startTime: entity.startTime,
      duration: entity.duration,
      notificationId: entity.notificationId,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      startTime: json['startTimeMinutes'] != null
          ? TimeOfDay(
              hour: (json['startTimeMinutes'] as int) ~/ 60,
              minute: (json['startTimeMinutes'] as int) % 60,
            )
          : null,
      duration: json['durationMinutes'] != null
          ? Duration(minutes: json['durationMinutes'] as int)
          : null,
      notificationId: json['notificationId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'startTimeMinutes': startTime != null
          ? startTime!.hour * 60 + startTime!.minute
          : null,
      'durationMinutes': duration?.inMinutes,
      'notificationId': notificationId,
    };
  }
}

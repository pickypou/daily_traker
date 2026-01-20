import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  final TimeOfDay? startTime;
  final Duration? duration;
  final int? notificationId;

  const TaskEntity({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.startTime,
    this.duration,
    this.notificationId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    isCompleted,
    startTime,
    duration,
    notificationId,
  ];
}

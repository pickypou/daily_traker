import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;

  const TaskEntity({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [id, title, isCompleted];
}

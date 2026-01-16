import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

abstract class DailyTaskState extends Equatable {
  const DailyTaskState();

  @override
  List<Object> get props => [];
}

class DailyTaskInitial extends DailyTaskState {}

class DailyTaskLoading extends DailyTaskState {}

class DailyTaskLoaded extends DailyTaskState {
  final List<TaskEntity> tasks;

  const DailyTaskLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class DailyTaskError extends DailyTaskState {
  final String message;

  const DailyTaskError(this.message);

  @override
  List<Object> get props => [message];
}

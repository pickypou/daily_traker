import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

abstract class DailyTaskEvent extends Equatable {
  const DailyTaskEvent();

  @override
  List<Object> get props => [];
}

class LoadDailyTasks extends DailyTaskEvent {}

class AddDailyTask extends DailyTaskEvent {
  final TaskEntity task;

  const AddDailyTask(this.task);

  @override
  List<Object> get props => [task];
}

class ToggleTaskCompletion extends DailyTaskEvent {
  final String taskId;

  const ToggleTaskCompletion(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class DeleteTask extends DailyTaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object> get props => [taskId];
}

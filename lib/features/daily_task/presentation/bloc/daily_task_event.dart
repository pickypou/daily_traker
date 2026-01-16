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

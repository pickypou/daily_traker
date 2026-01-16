import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import 'daily_task_event.dart';
import 'daily_task_state.dart';

class DailyTaskBloc extends Bloc<DailyTaskEvent, DailyTaskState> {
  final GetTasksUseCase getTasks;
  final AddTaskUseCase addTask;

  DailyTaskBloc({required this.getTasks, required this.addTask})
    : super(DailyTaskInitial()) {
    on<LoadDailyTasks>(_onLoadDailyTasks);
    on<AddDailyTask>(_onAddDailyTask);
  }

  Future<void> _onLoadDailyTasks(
    LoadDailyTasks event,
    Emitter<DailyTaskState> emit,
  ) async {
    emit(DailyTaskLoading());
    try {
      final tasks = await getTasks();
      emit(DailyTaskLoaded(tasks));
    } catch (e) {
      emit(DailyTaskError(e.toString()));
    }
  }

  Future<void> _onAddDailyTask(
    AddDailyTask event,
    Emitter<DailyTaskState> emit,
  ) async {
    try {
      await addTask(event.task);
      add(LoadDailyTasks());
    } catch (e) {
      emit(DailyTaskError(e.toString()));
    }
  }
}

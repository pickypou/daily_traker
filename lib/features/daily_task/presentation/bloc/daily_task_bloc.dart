import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import 'daily_task_event.dart';
import 'daily_task_state.dart';

class DailyTaskBloc extends Bloc<DailyTaskEvent, DailyTaskState> {
  final GetTasksUseCase getTasks;
  final AddTaskUseCase addTask;
  final NotificationService notificationService;

  DailyTaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.notificationService,
  }) : super(DailyTaskInitial()) {
    on<LoadDailyTasks>(_onLoadDailyTasks);
    on<AddDailyTask>(_onAddDailyTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<DeleteTask>(_onDeleteTask);
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

      // Schedule notification if task has a start time
      if (event.task.startTime != null && event.task.notificationId != null) {
        await notificationService.scheduleTaskNotification(event.task);
      }

      add(LoadDailyTasks());
    } catch (e) {
      emit(DailyTaskError(e.toString()));
    }
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletion event,
    Emitter<DailyTaskState> emit,
  ) async {
    if (state is DailyTaskLoaded) {
      final currentState = state as DailyTaskLoaded;
      final updatedTasks = currentState.tasks.map((task) {
        if (task.id == event.taskId) {
          return TaskEntity(
            id: task.id,
            title: task.title,
            isCompleted: !task.isCompleted,
            startTime: task.startTime,
            duration: task.duration,
            notificationId: task.notificationId,
          );
        }
        return task;
      }).toList();
      emit(DailyTaskLoaded(updatedTasks));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<DailyTaskState> emit,
  ) async {
    if (state is DailyTaskLoaded) {
      final currentState = state as DailyTaskLoaded;

      // Find task to cancel notification
      final taskToDelete = currentState.tasks.firstWhere(
        (task) => task.id == event.taskId,
        orElse: () => const TaskEntity(id: '', title: ''),
      );

      if (taskToDelete.notificationId != null) {
        await notificationService.cancelNotification(
          taskToDelete.notificationId!,
        );
      }

      final updatedTasks = currentState.tasks
          .where((task) => task.id != event.taskId)
          .toList();
      emit(DailyTaskLoaded(updatedTasks));
    }
  }
}

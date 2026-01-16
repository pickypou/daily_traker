import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/datasources/task_local_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../bloc/daily_task_bloc.dart';
import '../bloc/daily_task_event.dart';
import '../bloc/daily_task_state.dart';
import '../widgets/task_list_item.dart';

class DailyTaskPage extends StatefulWidget {
  const DailyTaskPage({super.key});

  @override
  State<DailyTaskPage> createState() => _DailyTaskPageState();
}

class _DailyTaskPageState extends State<DailyTaskPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<TaskEntity> _tasks = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DailyTaskBloc>(
      create: (context) {
        final localDataSource = TaskLocalDataSourceImpl();
        final repository = TaskRepositoryImpl(localDataSource: localDataSource);
        return DailyTaskBloc(
          getTasks: GetTasksUseCase(repository),
          addTask: AddTaskUseCase(repository),
        )..add(LoadDailyTasks());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Daily Tasks', style: AppTheme.titleStyle(context)),
        ),
        body: BlocConsumer<DailyTaskBloc, DailyTaskState>(
          listener: (context, state) {
            if (state is DailyTaskLoaded) {
              _updateTaskList(state.tasks);
            }
          },
          builder: (context, state) {
            if (state is DailyTaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DailyTaskLoaded) {
              if (_tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: AppTheme.paddingMedium),
                      Text('Aucune tâche', style: AppTheme.titleStyle(context)),
                      const SizedBox(height: AppTheme.paddingSmall),
                      Text(
                        'Appuyez sur + pour ajouter une tâche',
                        style: AppTheme.bodyStyle(context),
                      ),
                    ],
                  ),
                );
              }
              return AnimatedList(
                key: _listKey,
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.paddingSmall,
                ),
                initialItemCount: _tasks.length,
                itemBuilder: (context, index, animation) {
                  return _buildAnimatedItem(_tasks[index], animation);
                },
              );
            } else if (state is DailyTaskError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: AppTheme.paddingMedium),
                    Text('Erreur', style: AppTheme.titleStyle(context)),
                    const SizedBox(height: AppTheme.paddingSmall),
                    Text(
                      state.message,
                      style: AppTheme.bodyStyle(context),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: Text('Chargement...', style: AppTheme.bodyStyle(context)),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final task = TaskEntity(
              id: DateTime.now().toString(),
              title: 'Nouvelle tâche ${DateTime.now().second}',
            );
            context.read<DailyTaskBloc>().add(AddDailyTask(task));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildAnimatedItem(TaskEntity task, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: TaskListItem(task: task),
      ),
    );
  }

  void _updateTaskList(List<TaskEntity> newTasks) {
    // Find tasks to add
    for (int i = 0; i < newTasks.length; i++) {
      if (i >= _tasks.length || newTasks[i].id != _tasks[i].id) {
        // New task added
        _tasks.insert(i, newTasks[i]);
        _listKey.currentState?.insertItem(i);
        return;
      }
    }

    // Find tasks to remove
    for (int i = 0; i < _tasks.length; i++) {
      if (i >= newTasks.length ||
          !newTasks.any((task) => task.id == _tasks[i].id)) {
        // Task removed
        final removedTask = _tasks[i];
        _tasks.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => _buildAnimatedItem(removedTask, animation),
        );
        return;
      }
    }

    // Update existing tasks (for completion toggle)
    setState(() {
      _tasks = List.from(newTasks);
    });
  }
}

import 'package:daily_traker/features/daily_task/presentation/bloc/daily_task_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/daily_task_bloc.dart';
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
  void initState() {
    super.initState();
    // Load tasks once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DailyTaskBloc>().add(LoadDailyTasks());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              return _emptyState(context);
            }
            return AnimatedList(
              key: _listKey,
              padding: const EdgeInsets.symmetric(
                vertical: AppTheme.paddingSmall,
                horizontal: AppTheme.paddingMedium,
              ),
              initialItemCount: _tasks.length,
              itemBuilder: (context, index, animation) {
                return _buildAnimatedItem(_tasks[index], animation);
              },
            );
          } else if (state is DailyTaskError) {
            return _errorState(context, state.message);
          }
          return Center(child: Text('Chargement...', style: AppTheme.bodyStyle(context)));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.buttonBackgroundColor,
        foregroundColor: AppTheme.buttonTextColor,
        onPressed: () {
          // On peut ajouter une tâche par défaut ou naviguer vers AddTaskPage
          Navigator.pushNamed(context, '/add_task');
        },
        child: const Icon(Icons.add),
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
    // Ajouter les nouvelles tâches
    for (int i = 0; i < newTasks.length; i++) {
      if (i >= _tasks.length || newTasks[i].id != _tasks[i].id) {
        _tasks.insert(i, newTasks[i]);
        _listKey.currentState?.insertItem(i);
        return;
      }
    }
    // Supprimer les tâches supprimées
    for (int i = 0; i < _tasks.length; i++) {
      if (i >= newTasks.length || !newTasks.any((t) => t.id == _tasks[i].id)) {
        final removedTask = _tasks[i];
        _tasks.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => _buildAnimatedItem(removedTask, animation),
        );
        return;
      }
    }
    // Mise à jour des tâches existantes
    setState(() => _tasks = List.from(newTasks));
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 64, color: AppTheme.buttonBackgroundColor),
          const SizedBox(height: AppTheme.paddingMedium),
          Text('Aucune tâche', style: AppTheme.titleStyle(context)),
          const SizedBox(height: AppTheme.paddingSmall),
          Text('Appuyez sur + pour ajouter une tâche', style: AppTheme.bodyStyle(context)),
        ],
      ),
    );
  }

  Widget _errorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: AppTheme.paddingMedium),
          Text('Erreur', style: AppTheme.titleStyle(context)),
          const SizedBox(height: AppTheme.paddingSmall),
          Text(message, style: AppTheme.bodyStyle(context), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

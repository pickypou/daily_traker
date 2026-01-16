import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/daily_task_bloc.dart';
import '../bloc/daily_task_event.dart';
import '../bloc/daily_task_state.dart';
import '../widgets/task_list_item.dart';

class DailyTaskPage extends StatelessWidget {
  const DailyTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Tracker')),
      body: BlocBuilder<DailyTaskBloc, DailyTaskState>(
        builder: (context, state) {
          if (state is DailyTaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DailyTaskLoaded) {
            if (state.tasks.isEmpty) {
              return const Center(child: Text('No tasks yet'));
            }
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                return TaskListItem(task: state.tasks[index]);
              },
            );
          } else if (state is DailyTaskError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Press + to add a task'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final task = TaskEntity(
            id: DateTime.now().toString(),
            title: 'New Task ${DateTime.now().second}',
          );
          context.read<DailyTaskBloc>().add(AddDailyTask(task));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

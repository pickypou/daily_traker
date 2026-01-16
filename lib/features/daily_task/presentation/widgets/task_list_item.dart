import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';

class TaskListItem extends StatelessWidget {
  final TaskEntity task;

  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      trailing: task.isCompleted
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.circle_outlined),
    );
  }
}

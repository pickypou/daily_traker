import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/daily_task_bloc.dart';
import '../bloc/daily_task_event.dart';

class TaskListItem extends StatefulWidget {
  final TaskEntity task;

  const TaskListItem({super.key, required this.task});

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}min';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}min';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.paddingMedium,
          vertical: AppTheme.paddingSmall,
        ),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.paddingMedium,
            vertical: AppTheme.paddingSmall,
          ),
          leading: Checkbox(
            value: widget.task.isCompleted,
            onChanged: (_) {
              context.read<DailyTaskBloc>().add(
                ToggleTaskCompletion(widget.task.id),
              );
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task.title,
                style: AppTheme.bodyStyle(context).copyWith(
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              if (widget.task.startTime != null || widget.task.duration != null)
                const SizedBox(height: 4),
              if (widget.task.startTime != null || widget.task.duration != null)
                Row(
                  children: [
                    if (widget.task.startTime != null) ...[
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        widget.task.startTime!.format(context),
                        style: AppTheme.bodyStyle(context).copyWith(
                          fontSize: 12,
                          color: AppTheme.bodyStyle(
                            context,
                          ).color?.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                    if (widget.task.startTime != null &&
                        widget.task.duration != null)
                      const SizedBox(width: 12),
                    if (widget.task.duration != null) ...[
                      const Icon(Icons.timer, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(widget.task.duration!),
                        style: AppTheme.bodyStyle(context).copyWith(
                          fontSize: 12,
                          color: AppTheme.bodyStyle(
                            context,
                          ).color?.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                    if (widget.task.notificationId != null) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.notifications_active, size: 16),
                    ],
                  ],
                ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              context.read<DailyTaskBloc>().add(DeleteTask(widget.task.id));
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/daily_task_bloc.dart';
import '../bloc/daily_task_event.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notificationService = NotificationService();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  TimeOfDay? _startTime;
  int? _durationMinutes;

  final List<int> _durationOptions = [15, 30, 45, 60, 90, 120, 180, 240];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  void _submitTask() {
    if (_formKey.currentState?.validate() ?? false) {
      final notificationId = _startTime != null
          ? _notificationService.generateNotificationId()
          : null;

      final task = TaskEntity(
        id: DateTime.now().toString(),
        title: _titleController.text.trim(),
        startTime: _startTime,
        duration: _durationMinutes != null
            ? Duration(minutes: _durationMinutes!)
            : null,
        notificationId: notificationId,
      );

      context.read<DailyTaskBloc>().add(AddDailyTask(task));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une tâche', style: AppTheme.titleStyle(context)),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Titre de la tâche', style: AppTheme.bodyStyle(context)),
                const SizedBox(height: AppTheme.paddingSmall),
                TextFormField(
                  controller: _titleController,
                  style: AppTheme.bodyStyle(context),
                  decoration: InputDecoration(
                    hintText: 'Entrez le titre...',
                    hintStyle: AppTheme.bodyStyle(context)
                        .copyWith(color: AppTheme.bodyStyle(context).color?.withAlpha(128)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white.withAlpha(200),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Le titre ne peut pas être vide' : null,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppTheme.paddingLarge),
                CustomButton(
                  label: _startTime != null
                      ? _startTime!.format(context)
                      : 'Sélectionner une heure',
                  icon: Icons.access_time,
                  onPressed: _selectTime,
                  isExpanded: false,
                ),
                const SizedBox(height: AppTheme.paddingLarge),
                DropdownButtonFormField<int>(
                  initialValue: _durationMinutes,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white.withAlpha(200),
                  ),
                  hint: Text('Sélectionner une durée', style: AppTheme.bodyStyle(context)),
                  items: _durationOptions.map((minutes) {
                    final hours = minutes ~/ 60;
                    final mins = minutes % 60;
                    String label;
                    if (hours > 0 && mins > 0) {
                      label = '${hours}h ${mins}min';
                    } else if (hours > 0) {
                      label = '${hours}h';
                    } else {
                      label = '${mins}min';
                    }
                    return DropdownMenuItem(
                      value: minutes,
                      child: Text(label, style: AppTheme.bodyStyle(context)),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _durationMinutes = value),
                ),
                const SizedBox(height: AppTheme.paddingLarge * 2),
                Row(
                  children: [
                    CustomButton(
                      label: 'Annuler',
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: AppTheme.paddingMedium),
                    CustomButton(
                      label: 'Ajouter',
                      onPressed: _submitTask,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

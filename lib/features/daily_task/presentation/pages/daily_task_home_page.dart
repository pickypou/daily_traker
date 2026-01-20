import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/datasources/task_local_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../bloc/daily_task_bloc.dart';
import 'add_task_page.dart';
import 'daily_task_page.dart';

class DailyTaskHomePage extends StatelessWidget {
  const DailyTaskHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DailyTaskBloc>(
      create: (context) {
        final localDataSource = TaskLocalDataSourceImpl();
        final repository = TaskRepositoryImpl(localDataSource: localDataSource);
        return DailyTaskBloc(
          getTasks: GetTasksUseCase(repository),
          addTask: AddTaskUseCase(repository),
          notificationService: NotificationService(),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Daily Tasks', style: AppTheme.titleStyle(context)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomButton(
                    label: "Voir ma liste de tâches",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DailyTaskPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                Expanded(
                  child: CustomButton(
                    label: "Ajouter une tâche",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddTaskPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/task_local_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../bloc/daily_task_bloc.dart';

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
        );
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Daily Tasks')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(context, "Voir ma liste de tâches", () {}),
              const SizedBox(height: 16),
              _buildButton(context, "Ajouter une tâche", () {}),
              const SizedBox(height: 16),
              _buildButton(context, "Créer une liste de tâches", () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ElevatedButton(onPressed: onPressed, child: Text(text)),
    );
  }
}

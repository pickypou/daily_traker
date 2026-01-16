import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/daily_task/data/datasources/task_local_datasource.dart';
import 'features/daily_task/data/repositories/task_repository_impl.dart';
import 'features/daily_task/domain/usecases/add_task_usecase.dart';
import 'features/daily_task/domain/usecases/get_tasks_usecase.dart';
import 'features/daily_task/presentation/bloc/daily_task_bloc.dart';
import 'features/daily_task/presentation/bloc/daily_task_event.dart';
import 'features/daily_task/presentation/pages/daily_task_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection (Manual for now)
    final taskLocalDataSource = TaskLocalDataSourceImpl();
    final taskRepository = TaskRepositoryImpl(
      localDataSource: taskLocalDataSource,
    );
    final getTasksUseCase = GetTasksUseCase(taskRepository);
    final addTaskUseCase = AddTaskUseCase(taskRepository);

    return MaterialApp(
      title: 'Daily Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) =>
            DailyTaskBloc(getTasks: getTasksUseCase, addTask: addTaskUseCase)
              ..add(LoadDailyTasks()),
        child: const DailyTaskPage(),
      ),
    );
  }
}

import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> addTask(TaskModel task);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final List<TaskModel> _mockDb = [];

  @override
  Future<List<TaskModel>> getTasks() async {
    // Simulate network/db delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockDb;
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockDb.add(task);
  }
}

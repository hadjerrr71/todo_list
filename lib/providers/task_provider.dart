import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../services/task_storage.dart';

class TaskProvider extends ChangeNotifier {
  final TaskStorage _storage = TaskStorage();

  List<Task> _tasks = [];
  bool _isLoading = true;

  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;

  int get completedCount => _tasks.where((task) => task.isCompleted).length;

  int get pendingCount => _tasks.where((task) => !task.isCompleted).length;

  double get progress {
    if (_tasks.isEmpty) return 0;
    return completedCount / _tasks.length;
  }

  Future<void> loadTasks() async {
    try {
      _tasks = await _storage.loadTasks();
    } catch (error) {
      debugPrint('Erreur de chargement : $error');
      _tasks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _save() async {
    await _storage.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _tasks = [..._tasks, task];
    await _save();
  }

  Future<void> updateTask(Task updatedTask) async {
    _tasks = _tasks.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();

    await _save();
  }

  Future<void> toggleTask(String id) async {
    _tasks = _tasks.map((task) {
      if (task.id == id) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();

    await _save();
  }

  Future<void> deleteTask(String id) async {
    _tasks = _tasks.where((task) => task.id != id).toList();
    await _save();
  }
}

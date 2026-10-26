
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class TaskStorage {
  static const String _storageKey = 'study_flow_tasks';

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString(_storageKey);

    if (savedData == null || savedData.isEmpty) {
      return [];
    }

    final List<dynamic> decodedData =
    jsonDecode(savedData) as List<dynamic>;

    return decodedData.map((item) {
      return Task.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();

    final String encodedData = jsonEncode(
      tasks.map((task) => task.toJson()).toList(),
    );

    await prefs.setString(_storageKey, encodedData);
  }
}

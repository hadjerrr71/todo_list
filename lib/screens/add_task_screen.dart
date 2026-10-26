import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_form.dart';

class AddTaskScreen extends StatelessWidget {
  final Task? task;

  const AddTaskScreen({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'Nouvelle tâche' : 'Modifier la tâche'),
      ),
      body: TaskForm(
        task: task,
        onSubmit: (title, description, dueDate, priority) async {
          if (task == null) {
            final newTask = Task(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              title: title,
              description: description,
              dueDate: dueDate,
              priority: priority,
            );

            await provider.addTask(newTask);
          } else {
            final updatedTask = Task(
              id: task!.id,
              title: title,
              description: description,
              dueDate: dueDate,
              priority: priority,
              isCompleted: task!.isCompleted,
            );

            await provider.updateTask(updatedTask);
          }

          if (context.mounted) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

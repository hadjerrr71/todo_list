import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/app_colors.dart';
import 'add_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de la tâche'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddTaskScreen(task: task)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            Text(
              task.description.isEmpty
                  ? 'Aucune description.'
                  : task.description,
            ),
            const SizedBox(height: 20),
            Text('Priorité : ${task.priority}'),
            const SizedBox(height: 12),
            Text(
              task.dueDate == null
                  ? 'Aucune date limite'
                  : 'Date limite : ${DateFormat('dd/MM/yyyy', 'fr_FR').format(task.dueDate!)}',
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () async {
                await context.read<TaskProvider>().toggleTask(task.id);
                if (context.mounted) Navigator.pop(context);
              },
              icon: Icon(
                task.isCompleted ? Icons.undo : Icons.check_circle_outline,
              ),
              label: Text(
                task.isCompleted
                    ? 'Marquer comme à faire'
                    : 'Marquer comme terminée',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
              ),
              onPressed: () async {
                await context.read<TaskProvider>().deleteTask(task.id);
                if (context.mounted) Navigator.pop(context);
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Supprimer la tâche'),
            ),
          ],
        ),
      ),
    );
  }
}

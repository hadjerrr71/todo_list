import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/filter_tabs.dart';
import '../widgets/progress_header.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'settings_screen.dart';
import 'task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'Toutes';

  List<Task> _filterTasks(List<Task> tasks) {
    final now = DateTime.now();

    switch (_selectedFilter) {
      case 'Aujourd’hui':
        return tasks.where((task) {
          final date = task.dueDate;
          return date != null &&
              date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
        }).toList();

      case 'À faire':
        return tasks.where((task) => !task.isCompleted).toList();

      case 'Terminées':
        return tasks.where((task) => task.isCompleted).toList();

      default:
        return tasks;
    }
  }

  Future<void> _confirmDelete(BuildContext context, Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer la tâche ?'),
        content: Text('Voulez-vous supprimer "${task.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<TaskProvider>().deleteTask(task.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'StudyFlow',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Paramètres',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Organise ta journée.',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${provider.pendingCount} tâches restantes',
                    style: const TextStyle(color: AppColors.secondaryText),
                  ),
                  const SizedBox(height: 22),
                  ProgressHeader(
                    total: provider.tasks.length,
                    completed: provider.completedCount,
                    progress: provider.progress,
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mes tâches',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddTaskScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Ajouter'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilterTabs(
                    selectedFilter: _selectedFilter,
                    onChanged: (filter) {
                      setState(() => _selectedFilter = filter);
                    },
                  ),
                  const SizedBox(height: 20),
                  Builder(
                    builder: (context) {
                      final tasks = _filterTasks(provider.tasks);

                      if (tasks.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 36),
                          child: Column(
                            children: [
                              Icon(
                                Icons.task_alt,
                                size: 52,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              const Text('Aucune tâche à afficher.'),
                              const SizedBox(height: 6),
                              const Text(
                                'Ajoute une tâche pour commencer.',
                                style: TextStyle(
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: tasks.map((task) {
                          return TaskCard(
                            task: task,
                            onToggle: () {
                              context.read<TaskProvider>().toggleTask(task.id);
                            },
                            onDelete: () {
                              _confirmDelete(context, task);
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TaskDetailScreen(task: task),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

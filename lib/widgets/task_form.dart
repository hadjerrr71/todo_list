import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../utils/app_constants.dart';

class TaskForm extends StatefulWidget {
  final Task? task;
  final void Function(
    String title,
    String description,
    DateTime? dueDate,
    String priority,
  )
  onSubmit;

  const TaskForm({super.key, this.task, required this.onSubmit});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  DateTime? _dueDate;
  late String _priority;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.task?.title ?? '');

    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );

    _dueDate = widget.task?.dueDate;
    _priority = widget.task?.priority ?? 'Moyenne';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
      locale: const Locale('fr', 'FR'),
    );

    if (date != null) {
      setState(() => _dueDate = date);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit(
      _titleController.text.trim(),
      _descriptionController.text.trim(),
      _dueDate,
      _priority,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Titre de la tâche',
              hintText: 'Ex. Réviser Flutter',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Le titre est obligatoire.';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description (facultative)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            value: _priority,
            decoration: const InputDecoration(
              labelText: 'Priorité',
              border: OutlineInputBorder(),
            ),
            items: AppConstants.priorities.map((priority) {
              return DropdownMenuItem(value: priority, child: Text(priority));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _priority = value);
              }
            },
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_month),
            label: Text(
              _dueDate == null
                  ? 'Choisir une date limite'
                  : DateFormat('dd/MM/yyyy', 'fr_FR').format(_dueDate!),
            ),
          ),
          if (_dueDate != null)
            TextButton(
              onPressed: () => setState(() => _dueDate = null),
              child: const Text('Retirer la date'),
            ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submit,
            child: Text(
              widget.task == null
                  ? 'Ajouter la tâche'
                  : 'Enregistrer les modifications',
            ),
          ),
        ],
      ),
    );
  }
}

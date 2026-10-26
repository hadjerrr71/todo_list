import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class ProgressHeader extends StatelessWidget {
  final int total;
  final int completed;
  final double progress;

  const ProgressHeader({
    super.key,
    required this.total,
    required this.completed,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ta progression',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            '$completed / $total tâches terminées',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.white30,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).round()} % accompli',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../utils/app_constants.dart';

class FilterTabs extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onChanged;

  const FilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: AppConstants.filters.map((filter) {
          final bool selected = filter == selectedFilter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: selected,
              onSelected: (_) => onChanged(filter),
            ),
          );
        }).toList(),
      ),
    );
  }
}

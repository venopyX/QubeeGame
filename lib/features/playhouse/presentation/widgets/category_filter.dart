import 'package:flutter/material.dart';

/// A horizontal scrollable list of filter chips for video categories
class CategoryFilter extends StatelessWidget {
  /// List of available categories
  final List<String> categories;

  /// Currently selected category (null if none selected)
  final String? selectedCategory;

  /// Callback when a category is selected/deselected
  final Function(String?) onCategorySelected;

  /// Creates a CategoryFilter widget
  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: selectedCategory == null,
            onSelected: (_) {
              onCategorySelected(null);
            },
          ),
          const SizedBox(width: 8),
          ...categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(category),
                selected: selectedCategory == category,
                onSelected: (_) {
                  onCategorySelected(
                    selectedCategory == category ? null : category,
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

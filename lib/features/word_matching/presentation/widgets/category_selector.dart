import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A widget displaying selectable category cards
class CategorySelector extends StatelessWidget {
  /// List of available categories
  final List<String> categories;

  /// Currently selected category
  final String selectedCategory;

  /// Callback when a category is selected
  final Function(String) onCategorySelected;

  /// Creates a CategorySelector widget
  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index >= categories.length) return null;

        final category = categories[index];
        final isSelected = category == selectedCategory;
        final displayName = _getCategoryDisplayName(category);
        final categoryInfo = _getCategoryInfo(category);

        return GestureDetector(
          onTap: () => onCategorySelected(category),
          child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      isSelected
                          ? Border.all(color: categoryInfo.color, width: 2)
                          : Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: categoryInfo.color.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      categoryInfo.icon,
                      size: 48,
                      color: categoryInfo.color,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: (100 * index).ms)
              .slideY(
                begin: 0.2,
                end: 0,
                duration: 400.ms,
                delay: (100 * index).ms,
              ),
        );
      }, childCount: categories.length),
    );
  }

  /// Returns a display name for a category
  String _getCategoryDisplayName(String category) {
    return category == 'all'
        ? 'All Categories'
        : '${category[0].toUpperCase()}${category.substring(1)}';
  }

  /// Returns icon and color for a category
  _CategoryInfo _getCategoryInfo(String category) {
    switch (category) {
      case 'animals':
        return _CategoryInfo(icon: Icons.pets, color: Colors.brown);
      case 'nature':
        return _CategoryInfo(icon: Icons.landscape, color: Colors.green);
      case 'food':
        return _CategoryInfo(icon: Icons.restaurant, color: Colors.orange);
      case 'colors':
        return _CategoryInfo(icon: Icons.palette, color: Colors.blue);
      case 'all':
      default:
        return _CategoryInfo(icon: Icons.category, color: Colors.purple);
    }
  }
}

/// Helper class for category icons and colors
class _CategoryInfo {
  final IconData icon;
  final Color color;

  _CategoryInfo({required this.icon, required this.color});
}

import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_shapes.dart';
import '../../../../app/theme/tokens/app_spacing.dart';

/// Instant search bar with clear button and category filter chips.
class ProductSearchBar extends StatefulWidget {
  const ProductSearchBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant ProductSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery &&
        _controller.text != widget.searchQuery) {
      _controller.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search text input
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: TextField(
            controller: _controller,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: 'ابحث بالاسم، الكود، أو المقاس (مثال: كوع 1/2)...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _controller.clear();
                        widget.onSearchChanged('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              border: OutlineInputBorder(
                borderRadius: AppShapes.roundedMd,
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              filled: true,
              fillColor: isDark
                  ? AppColors.darkSurface
                  : AppColors.lightSurface,
            ),
            onChanged: widget.onSearchChanged,
          ),
        ),

        // Horizontal Category Chips
        if (widget.categories.isNotEmpty)
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                _CategoryFilterChip(
                  label: 'الكل',
                  isSelected: widget.selectedCategory == null,
                  onTap: () => widget.onCategorySelected(null),
                ),
                for (final cat in widget.categories)
                  _CategoryFilterChip(
                    label: cat,
                    isSelected: widget.selectedCategory == cat,
                    onTap: () => widget.onCategorySelected(cat),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  const _CategoryFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedBg = isDark ? AppColors.darkAction : AppColors.lightAction;
    final unselectedBg = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final textColor = isSelected
        ? Colors.white
        : (isDark ? AppColors.darkText : AppColors.lightText);

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs, top: 4, bottom: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: selectedBg,
        backgroundColor: unselectedBg,
        labelStyle: theme.textTheme.labelMedium?.copyWith(
          color: textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.roundedPill,
          side: BorderSide(
            color: isSelected
                ? selectedBg
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
      ),
    );
  }
}

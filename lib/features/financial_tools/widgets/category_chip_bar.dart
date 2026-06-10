import 'package:flutter/material.dart';
import 'package:dukan_tools/common/localizations_helper.dart';

class CategoryChipBar extends StatefulWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  /// Pass a [ScrollController] owned by the parent so the scroll position
  /// survives tab switches (the parent's State lives longer than this widget).
  final ScrollController scrollController;

  const CategoryChipBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.scrollController,
  });

  static const List<Map<String, dynamic>> categories = [
    {'id': 'all', 'label': 'All', 'icon': Icons.apps},
    {'id': 'kirana', 'label': 'General Kirana', 'icon': Icons.storefront},
    {'id': 'chai', 'label': 'Chai Shop', 'icon': Icons.local_cafe},
    {'id': 'saree', 'label': 'Saree/Cloth', 'icon': Icons.checkroom},
    {'id': 'medical', 'label': 'Medical', 'icon': Icons.local_pharmacy},
    {'id': 'hardware', 'label': 'Hardware', 'icon': Icons.hardware},
    {'id': 'mobile', 'label': 'Mobile', 'icon': Icons.smartphone},
    {'id': 'others', 'label': 'Others', 'icon': Icons.grid_view},
  ];

  @override
  State<CategoryChipBar> createState() => _CategoryChipBarState();
}

class _CategoryChipBarState extends State<CategoryChipBar> {
  // Keys are recreated each time but that's fine — we only use them to
  // find the RenderBox for measurement, not to store state.
  final List<GlobalKey> _keys = List.generate(
    CategoryChipBar.categories.length,
    (index) => GlobalKey(),
  );

  @override
  void initState() {
    super.initState();
    _scheduleScrollToSelected();
  }

  @override
  void didUpdateWidget(CategoryChipBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCategory != oldWidget.selectedCategory) {
      _scheduleScrollToSelected();
    }
  }

  /// Waits one frame so all chips are laid out before measuring.
  void _scheduleScrollToSelected() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToSelected();
    });
  }

  void _scrollToSelected() {
    final selectedIndex = CategoryChipBar.categories
        .indexWhere((cat) => cat['id'] == widget.selectedCategory);
    if (selectedIndex == -1) return;

    final chipContext = _keys[selectedIndex].currentContext;
    if (chipContext == null) return;

    Scrollable.ensureVisible(
      chipContext,
      alignment: 0.5,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Color _getCategoryColor(String catId, ThemeData theme) {
    switch (catId) {
      case 'kirana':
        return const Color(0xFFD32F2F);
      case 'chai':
        return const Color(0xFFE65100);
      case 'saree':
        return const Color(0xFF7B1FA2);
      case 'medical':
        return const Color(0xFF00796B);
      case 'hardware':
        return const Color(0xFF455A64);
      case 'mobile':
        return const Color(0xFF303F9F);
      case 'others':
        return const Color(0xFF1976D2);
      case 'all':
      default:
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 56,
      child: SingleChildScrollView(
        controller: widget.scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: List.generate(
            CategoryChipBar.categories.length,
            (index) {
              final cat = CategoryChipBar.categories[index];
              final String catId = cat['id'] as String;
              final String label = cat['label'] as String;
              final IconData icon = cat['icon'] as IconData;
              final isSelected = widget.selectedCategory == catId;
              final color = _getCategoryColor(catId, theme);

              return Padding(
                key: _keys[index],
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  avatar: Icon(
                    icon,
                    size: 16,
                    color: isSelected
                        ? Colors.white
                        : color,
                  ),
                  label: Text(
                    LocalizationsHelper.translate(context, label),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: color,
                  backgroundColor:
                      isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                  checkmarkColor: Colors.white,
                  showCheckmark: false,
                  side: BorderSide(
                    color: isSelected
                        ? color
                        : color.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                  onSelected: (bool selected) {
                    if (selected) {
                      widget.onCategorySelected(catId);
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

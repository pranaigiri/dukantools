import 'package:flutter/material.dart';
import '../models/tool_config.dart';

class ToolGridCard extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final ShopCategory category;
  final VoidCallback onTap;

  const ToolGridCard({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.onTap,
  });

  Color _getCategoryColor(ShopCategory cat, bool isDark) {
    switch (cat) {
      case ShopCategory.kirana:
        return isDark ? const Color(0xFFE57373) : const Color(0xFFD32F2F);
      case ShopCategory.chai:
        return isDark ? const Color(0xFFFFB74D) : const Color(0xFFE65100);
      case ShopCategory.saree:
        return isDark ? const Color(0xFFBA68C8) : const Color(0xFF7B1FA2);
      case ShopCategory.medical:
        return isDark ? const Color(0xFF4DB6AC) : const Color(0xFF00796B);
      case ShopCategory.hardware:
        return isDark ? const Color(0xFF90A4AE) : const Color(0xFF455A64);
      case ShopCategory.mobile:
        return isDark ? const Color(0xFF7986CB) : const Color(0xFF303F9F);
      case ShopCategory.others:
        return isDark ? const Color(0xFF64B5F6) : const Color(0xFF1976D2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final catColor = _getCategoryColor(category, isDark);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          width: 1,
        ),
      ),
      color: isDark ? Colors.grey.shade900 : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: catColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: catColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

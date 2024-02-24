import 'package:flutter/widgets.dart';

import '../../core/enums/category_type.dart';

class CategoryTypeItem {
  final String title;
  final IconData icon;
  final CategoryType type;

  CategoryTypeItem({
    required this.title,
    required this.icon,
    required this.type,
  });
}

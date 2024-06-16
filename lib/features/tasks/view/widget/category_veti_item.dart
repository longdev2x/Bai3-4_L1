import 'package:exercies3/common/model/category_entity.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:flutter/material.dart';

class CategoryVetiItem extends StatelessWidget {
  final CategoryEntity category;
  final Function() onTap;
  final Function() onLongPress;
  const CategoryVetiItem({
    super.key,
    required this.category,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      leading: AppIcon(path: category.icon),
      title: Text(category.name),
      trailing: const Icon(Icons.more_horiz),
    );
  }
}

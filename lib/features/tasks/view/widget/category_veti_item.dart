import 'package:exercies3/common/model/task_category_entity.dart';
import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/common/widgets/app_icon.dart';
import 'package:flutter/material.dart';

class CategoryVetiItem extends StatelessWidget {
  final TaskCategoryEntity category;
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
      leading: const AppIcon(path: ImageRes.icPersonal),
      title: Text(category.name),
      trailing: const Icon(Icons.more_horiz),
    );
  }
}

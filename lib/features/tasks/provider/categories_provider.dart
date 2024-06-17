import 'package:exercies3/common/model/category_entity.dart';
import 'package:exercies3/features/tasks/repo/category_repos.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesAsyncNotifier extends AsyncNotifier<List<CategoryEntity>> {
  CategoriesAsyncNotifier();

  @override
  Future<List<CategoryEntity>> build() async {
    return _loadCate();
  }

  Future<List<CategoryEntity>> _loadCate() async {
    return await CategoryRepos.getAll();
  }

  Future<void> add(String name, icon) async {
    CategoryEntity category = CategoryEntity(name: name, icon: icon);
    state = await AsyncValue.guard(() async {
      await CategoryRepos.add(category);
      return await _loadCate();
    });
  }

  Future<void> delete(String id) async {
    state = await AsyncValue.guard(() async {
      await CategoryRepos.delete(id);
      return await _loadCate();
    });
  }

  Future<void> updateCate(CategoryEntity category) async {
    state = await AsyncValue.guard(() async {
      await CategoryRepos.update(category);
      return await _loadCate();
    });
  }
}

final categoriesAsyncProvider =
    AsyncNotifierProvider<CategoriesAsyncNotifier, List<CategoryEntity>>(
  () => CategoriesAsyncNotifier(),
);

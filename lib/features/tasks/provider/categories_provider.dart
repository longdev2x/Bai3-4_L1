import 'package:exercies3/common/model/task_category_entity.dart';
import 'package:exercies3/features/tasks/repo/category_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesAsyncNotifier extends AsyncNotifier<List<TaskCategoryEntity>> {
  CategoriesAsyncNotifier();

  @override
  Future<List<TaskCategoryEntity>> build() async {
    return _loadCate();
  }

  Future<List<TaskCategoryEntity>> _loadCate() async {
    return await CategoryRepos.getAll();
  }

  Future<void> add(String name) async {
    TaskCategoryEntity category = TaskCategoryEntity(name: name);
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

  Future<void> updateCate(TaskCategoryEntity category) async {
    state = await AsyncValue.guard(() async {
      await CategoryRepos.update(category);
      return await _loadCate();
    });
  }
}

final categoriesAsyncProvider =
    AsyncNotifierProvider<CategoriesAsyncNotifier, List<TaskCategoryEntity>>(
  () => CategoriesAsyncNotifier(),
);

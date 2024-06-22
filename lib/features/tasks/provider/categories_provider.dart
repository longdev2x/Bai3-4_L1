import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exercies3/common/model/category_entity.dart';
import 'package:exercies3/common/utils/image_res.dart';
import 'package:exercies3/features/tasks/repo/category_repos.dart';
import 'package:flutter/foundation.dart';
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
    //local
    state = state.whenData((categories) => [...categories, category,],);

    //Server
    try {
      await CategoryRepos.add(category);
    } on FirebaseException catch(e) {
      if (kDebugMode) {
        print(e.message);
      }
    } finally {
      state = await AsyncValue.guard(() async => await _loadCate());
    }
  }

  Future<void> delete(String id) async {
    state = state.whenData((categories) {
      categories.removeWhere((cate) => cate.id == id);
      return categories;
    });

    try {
      await CategoryRepos.delete(id);
    } on FirebaseException catch(e) {
      if (kDebugMode) {
        print(e.message);
      }
    } finally {
      state = await AsyncValue.guard(() async => await _loadCate());
    }
  }

  Future<void> updateCate({required String id, String? name, String? icon}) async {
    CategoryEntity? categoryUpdate;
    state = state.whenData((categories) {
      final updateCategories = categories.map((cate) {
        if(cate.id == id) {
          // cate.copyWith là tạo 1 bản sao, phải gán lại cho cate thì mới làm thay đổi ô nhớ của List.
          cate = cate.copyWith(
            name: name,
            icon: icon
          );
          categoryUpdate = cate;
        }
        return cate;
      }).toList();
      return updateCategories;
    });

    try {
      await CategoryRepos.update(categoryUpdate!);
    } on FirebaseException catch(e) {
      if (kDebugMode) {
        print(e.message);
      }
    } finally {
      state = await AsyncValue.guard(() async => await _loadCate());
    }
  }
}

final categoriesAsyncProvider =
    AsyncNotifierProvider<CategoriesAsyncNotifier, List<CategoryEntity>>(
  () => CategoriesAsyncNotifier(),
);


//Icon Of Category Provider Family
List<String> iconPaths = [
  ImageRes.icBirth,
  ImageRes.icCoffee,
  ImageRes.icEat,
  ImageRes.icFight,
  ImageRes.icHospital,
  ImageRes.icLearn,
  ImageRes.icSport,
  ImageRes.icWork,
];
class IconStateNotifier extends StateNotifier<String> {
  IconStateNotifier(String iconInitial) : super(iconInitial);

  void updateIcon(String icon) {
    state = icon;
  }
}
final iconProviderFamily = StateNotifierProviderFamily<IconStateNotifier, String, String>((ref, iconInitial) => IconStateNotifier(iconInitial));


//Hori index of ScrollBar Horizontal of Category in TaskScreen
class HoriIndexStateNotifier extends StateNotifier<int> {
  HoriIndexStateNotifier() : super(0);
  
  void update(int index) {
    state = index;
  }
}

final horiIndexProvider = StateNotifierProvider<HoriIndexStateNotifier, int>((ref) => HoriIndexStateNotifier());
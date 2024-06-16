import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomTabsStateNotifier extends StateNotifier<int> {
  BottomTabsStateNotifier() : super(0);

  void update(int index) {
    state = index;
  }
}

final bottomTabsProvider = StateNotifierProvider<BottomTabsStateNotifier, int>(
  (ref) => BottomTabsStateNotifier(),
);

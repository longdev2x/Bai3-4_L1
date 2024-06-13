import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsLoginStateNotifier extends StateNotifier<bool> {
  IsLoginStateNotifier() : super(true);

  void switchScreen() {
    state = !state;
  }
}

final isLoginProvider = StateNotifierProvider<IsLoginStateNotifier, bool>((ref) => IsLoginStateNotifier());
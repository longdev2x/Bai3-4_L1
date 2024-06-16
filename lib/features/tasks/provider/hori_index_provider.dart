import 'package:flutter_riverpod/flutter_riverpod.dart';

class HoriIndexStateNotifier extends StateNotifier<int> {
  HoriIndexStateNotifier() : super(0);
  
  void update(int index) {
    state = index;
  }
}

final horiIndexProvider = StateNotifierProvider<HoriIndexStateNotifier, int>((ref) => HoriIndexStateNotifier());
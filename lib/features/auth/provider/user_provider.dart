import 'package:exercies3/common/model/user_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserStateNotifier extends StateNotifier<UserEntity> {
  UserStateNotifier() : super(const UserEntity(email: "", password: ""));

  void onChanged({String? email, String? password}) {
    state = state.copyWith(
      email: email,
      password: password,
    );
  }
}

final userProvider = StateNotifierProvider<UserStateNotifier, UserEntity>((ref) => UserStateNotifier());
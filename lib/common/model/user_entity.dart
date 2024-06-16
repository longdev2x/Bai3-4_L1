class UserEntity {
  final String email;
  final String password;

  const UserEntity({required this.email, required this.password});

  UserEntity copyWith({String? email, String? password}) => UserEntity(
        email: email ?? this.email,
        password: password ?? this.password,
      );
}

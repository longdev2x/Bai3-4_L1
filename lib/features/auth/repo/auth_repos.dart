import 'package:exercies3/common/model/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepos {
  static final FirebaseAuth _instance = FirebaseAuth.instance;
  
  static Future<UserCredential> signUpWithFirebase(UserEntity user) async {
    UserCredential userCredential =
        await _instance.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );
    return userCredential;
  }

  static Future<UserCredential> loginWithFirebase(UserEntity user) async {
    UserCredential userCredential = await _instance.signInWithEmailAndPassword(
        email: user.email, password: user.password);
    return userCredential;
  }
}

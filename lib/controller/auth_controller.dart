import 'package:exercies3/common/widgets/app_dialog.dart';
import 'package:exercies3/model/user_entity.dart';
import 'package:exercies3/providers/is_login_provider.dart';
import 'package:exercies3/providers/loader_provider.dart';
import 'package:exercies3/providers/user_provider.dart';
import 'package:exercies3/repos/auth_repos.dart';
import 'package:exercies3/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController {
  static void signUp(WidgetRef ref) async {
    final UserEntity user = ref.watch(userProvider);
    //validate firebase (first validate in textformfield of Form)
    ref.read(loaderProvider.notifier).updateLoader(true);
    try {
      UserCredential userCredential = await AuthRepos.signUpWithFirebase(user);
      userCredential.user!.sendEmailVerification();
      ref.read(loaderProvider.notifier).updateLoader(false);
      AppDialog.showToast("Thành công, vui lòng xác thực email");
      //Add username, photo...
      ref.read(isLoginProvider.notifier).switchScreen();
    } on FirebaseAuthException catch (e) {
      print(e.code);
      ref.read(loaderProvider.notifier).updateLoader(false);
      switch (e.code) {
        case "email-already-in-use":
          AppDialog.showToast("Email đã được sử dụng");
          break;
        case "invalid-email":
          AppDialog.showToast("Email không hợp lệ");
          break;
        case "weak-password":
          AppDialog.showToast("Mật khẩu chưa đủ mạnh");
          break;
        case "operation-not-allowed":
          if (kDebugMode) {
            print("Chưa bật email-pass trên Firebase");
          }
          break;
        default:
          AppDialog.showToast("Có lỗi gì đó");
      }
    }
  }

  static void signIn(WidgetRef ref, BuildContext context) async {
    UserEntity user = ref.watch(userProvider);
    //Validate Firebase (first validate in Form)
    ref.read(loaderProvider.notifier).updateLoader(true);
    try {
      UserCredential userCredential = await AuthRepos.loginWithFirebase(user);
      ref.read(loaderProvider.notifier).updateLoader(false);
      AppDialog.showToast("Đăng nhập thành công");
      //Save user token to local, sharedpreferences ...
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (ctx) => const HomeScreen(),
          ),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      ref.read(loaderProvider.notifier).updateLoader(false);
      switch (e.code) {
        case "user-disabled":
          AppDialog.showToast("Tài khoản bị vô hiệu hoá");
          break;
        case "invalid-email":
          AppDialog.showToast("Email không hợp lệ");
          break;
        case "user-not-found":
          AppDialog.showToast("Email chưa đăng ký");
          break;
        case "wrong-password":
          AppDialog.showToast("Sai mật khẩu");
          break;
        default:
          AppDialog.showToast("Vui lòng kiểm tra lại");
      }
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/base.dart';
import 'package:todo/features/login/connector.dart';

class LoginViewModel extends BaseViewModel<LoginConnector> {

  Future<void> login(
    String email,
    String password,
  ) async {
    try {
      connector?.showLoading("Loading");
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      connector?.goToHome();
      // logged();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        connector?.showMessage(e.message??"");
        // onError(e.message);
      } else if (e.code == 'wrong-password') {
        connector?.showMessage(e.message??"");
        // onError(e.message);
      }
    }
  }
}

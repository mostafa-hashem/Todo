import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/base.dart';
import 'package:todo/features/create_account/create_account_connector.dart';
import 'package:todo/models/user_model.dart';
import 'package:todo/shared/network/firebase/firebase_functions.dart';

class CreateAccountViewModel extends BaseViewModel<CreateAccountConnector> {
  Future<void> createAccount(
    String email,
    String password,
    String name,
    int age,
  ) async {
    connector!.showLoading("Creating");
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final UserModel userModel = UserModel(
        id: credential.user!.uid,
        name: name,
        email: email,
        age: age,
      );
      FirebaseFunctions.addUserToFireStore(userModel).then((value) {
        connector!.goToHome();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        connector!.showMessage(e.message ?? "");
      } else if (e.code == 'email-already-in-use') {
        connector!.showMessage(e.message ?? "");
      }
    } catch (e) {
      connector!.showMessage(e.toString());
    }
  }
}

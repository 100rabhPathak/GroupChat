import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/services/database_srvices.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future registerUserWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      await DatabaseServices(uid: user.uid).savingUserData(fullName, email);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future singOut() async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmail("");
      await HelperFunction.saveUserName("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}

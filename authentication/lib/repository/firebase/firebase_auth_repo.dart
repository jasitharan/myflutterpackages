import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<User?> registerNewUser(
      String name, String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      await user?.updateDisplayName(name);
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      var result = await firebaseAuth.signInWithCredential(credential);
      User? user = result.user;

      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<dynamic> signOut() async {
    try {
      User? user = firebaseAuth.currentUser;

      if (user!.providerData[0].providerId == 'google.com') {
        await _googleSignIn.disconnect();
      }
      await firebaseAuth.signOut();
      return 1;
    } catch (e) {
      return null;
    }
  }

  @override
  Future forgotPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return 1;
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<User?> getUser() {
    return firebaseAuth.authStateChanges();
  }

  @override
  Future<bool> validate() async {
    return firebaseAuth.currentUser?.refreshToken != null;
  }
}

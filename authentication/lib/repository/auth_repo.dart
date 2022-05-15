import 'package:the_apple_sign_in/the_apple_sign_in.dart';

abstract class AuthRepo {
  Future registerNewUser(String name, String email, String password);

  Future signIn(String email, String password);

  Future signInWithGoogle();

  Future signInWithApple({List<Scope> scopes = const []});

  Future forgotPassword(String email);

  Future signOut();

  Stream getUser();
}

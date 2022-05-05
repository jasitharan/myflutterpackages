abstract class AuthRepo {
  Future registerNewUser(String name, String email, String password);

  Future signIn(String email, String password);

  Future signInWithGoogle();

  Future forgotPassword(String email);

  Future signOut();

  Stream getUser();
}

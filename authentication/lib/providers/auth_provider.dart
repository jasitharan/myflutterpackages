import 'package:authentication/authentication.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../repository/auth_repo.dart';

class AuthProvider {
  final AuthRepo _authRepo = AuthSettings.authRepo;

  UserModel? _userFromServer(dynamic user) {
    return user != null
        ? UserModel(uid: user.uid, email: user.email, name: user.displayName)
        : null;
  }

  Stream<UserModel?> get user {
    return _authRepo.getUser().map(_userFromServer);
  }

  Future<UserModel?> register(String email, String password,
      [String name = 'user']) async {
    dynamic user = await _authRepo.registerNewUser(
      name,
      email,
      password,
    );
    return _userFromServer(user);
  }

  Future<UserModel?> signIn(String email, String password) async {
    dynamic user = await _authRepo.signIn(email, password);
    return _userFromServer(user);
  }

  Future<UserModel?> signInWithGoogle() async {
    dynamic user = await _authRepo.signInWithGoogle();
    return _userFromServer(user);
  }

  Future<UserModel?> signInWithApple({List<Scope> scopes = const []}) async {
    dynamic user = await _authRepo.signInWithApple(
      scopes: [Scope.email, Scope.fullName],
    );
    return _userFromServer(user);
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
  }

  Future forgotPassword(String email) async {
    return await _authRepo.forgotPassword(email);
  }
}

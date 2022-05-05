import 'repository/api/api_auth_repo.dart';
import 'repository/auth_repo.dart';
import 'repository/firebase/firebase_auth_repo.dart';

class AuthSettings {
  static String url = "https://myflutternewsapp.herokuapp.com/api";
  static ServerType serverType = ServerType.firebase;
  static final AuthRepo authRepo =
      serverType == ServerType.firebase ? FirebaseAuthRepo() : ApiAuthRepo();
}

enum ServerType { firebase, api }

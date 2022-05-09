import 'package:shared_preferences/shared_preferences.dart';

import '../../auth_settings.dart';
import 'models/api_user_model.dart';

class AuthApi {
  static ApiUserModel? _apiUserModel;

  static ApiUserModel? getApiUserModel() {
    return _apiUserModel;
  }

  static Future<String> _readAuth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(
          'auth',
        ) ??
        "";
  }

  static Future<void> setAuth(ApiUserModel? apiUserModel) async {
    final prefs = await SharedPreferences.getInstance();
    if (apiUserModel != null) {
      prefs.setString('auth', apiUserModel.toJson().toString());
    }
  }

  static void clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth');
    _apiUserModel = null;
  }

  static Future<void> initialize(String url) async {
    AuthSettings.serverType = ServerType.api;
    AuthSettings.url = url;
    String json = await _readAuth();
    _apiUserModel = ApiUserModel.fromJson(json);
  }
}

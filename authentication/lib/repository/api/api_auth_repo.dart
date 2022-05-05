import 'dart:async';
import 'dart:convert';

import 'package:authentication/auth_setting.dart';
import 'package:authentication/repository/api/models/api_user_model.dart';
import 'package:authentication/repository/auth_repo.dart';
import 'package:http/http.dart' as http;

class ApiAuthRepo implements AuthRepo {
  static String baseUrl = AuthSetting.url;
  static var client = http.Client();

  final controller = StreamController<ApiUserModel?>();

  ApiUserModel? userInstance;

  @override
  Future registerNewUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password
      }),
    );

    if (response.statusCode == 201) {
      ApiUserModel apiUserModel =
          ApiUserModel.fromJson(jsonDecode(response.body));
      controller.add(apiUserModel);
      userInstance = apiUserModel;
      return apiUserModel;
    } else {
      return null;
    }
  }

  @override
  Future signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    if (response.statusCode == 201) {
      ApiUserModel apiUserModel =
          ApiUserModel.fromJson(jsonDecode(response.body));
      controller.add(apiUserModel);
      userInstance = apiUserModel;
      return apiUserModel;
    } else {
      return null;
    }
  }

  @override
  Future signInWithGoogle() {
    throw UnimplementedError();
  }

  @override
  Future signOut() async {
    final response =
        await http.post(Uri.parse('$baseUrl/logout'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${userInstance!.uid}',
    });

    if (response.statusCode == 200) {
      userInstance = ApiUserModel();
      controller.add(null);
      return 1;
    } else {
      return null;
    }
  }

  @override
  Future validate() {
    throw UnimplementedError();
  }

  @override
  Future forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email}),
    );

    if (response.statusCode == 200) {
      return response.statusCode;
    } else if (response.statusCode == 404) {
      return response.statusCode;
    } else {
      throw Exception(['Failed to send.', response.body]);
    }
  }

  @override
  Stream<ApiUserModel?> getUser() {
    return controller.stream;
  }
}

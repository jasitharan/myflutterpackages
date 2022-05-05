import 'dart:convert';

class ApiUserModel {
  final String? uid;
  final String? email;
  final String? displayName;
  ApiUserModel({
    this.uid,
    this.email,
    this.displayName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': displayName,
    };
  }

  factory ApiUserModel.fromMap(Map<String, dynamic> map) {
    return ApiUserModel(
      uid: map['uid'] != null ? map['token'] as String : null,
      email: map['email'] != null ? map['user']['email'] as String : null,
      displayName: map['name'] != null ? map['user']['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiUserModel.fromJson(String source) =>
      ApiUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ApiUserModel copyWith({String? uid, String? email, String? displayName}) {
    return ApiUserModel(uid: uid, email: email, displayName: displayName);
  }
}

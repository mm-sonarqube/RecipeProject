import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getSession();
  Future<void> saveSession(UserModel user);
  Future<void> deleteSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _sessionKey = 'USER_SESSION';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getSession() async {
    final jsonStr = sharedPreferences.getString(_sessionKey);
    if (jsonStr != null) {
      return UserModel.fromJson(json.decode(jsonStr) as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<void> saveSession(UserModel user) async {
    final jsonStr = json.encode(user.toJson());
    await sharedPreferences.setString(_sessionKey, jsonStr);
  }

  @override
  Future<void> deleteSession() async {
    await sharedPreferences.remove(_sessionKey);
  }
}

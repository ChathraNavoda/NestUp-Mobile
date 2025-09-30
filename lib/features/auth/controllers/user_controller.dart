import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nestup/core/network/api_client.dart';
import 'package:nestup/features/auth/models/user.dart';

class UserController extends ChangeNotifier {
  UserModel? _user;
  final ApiClient apiClient;

  static const _tokenKey = 'auth_token';
  Box? _box;

  UserController({required this.apiClient}) {
    print('[UserController] Initialized with Hive storage');
    _initBox();
  }

  Future<void> _initBox() async {
    try {
      _box = await Hive.openBox('auth_box');
      print('[UserController] Hive box initialized');
    } catch (e) {
      print('[UserController] Hive init error: $e');
    }
  }

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  /// LOGIN using email & password
  Future<void> login(String email, String password) async {
    print('[UserController] login called with email: $email');
    try {
      final response = await apiClient.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      print('[UserController] login response: $response');

      final token = response['token'];
      if (token != null) {
        // Ensure box is initialized
        if (_box == null) {
          await _initBox();
        }

        // Save token with Hive
        await _box?.put(_tokenKey, token);
        print('[UserController] Token saved to Hive: $token');

        // Set token in ApiClient
        apiClient.setToken(token);

        // Set user
        _user = UserModel.fromJson(response['user']);
        print(
          '[UserController] Logged in user: ${_user?.name}, email: ${_user?.email}',
        );
        notifyListeners();
      }
    } catch (e) {
      print('[UserController] login error: $e');
      rethrow;
    }
  }

  /// AUTO LOGIN using saved token
  Future<void> autoLogin() async {
    print('[UserController] autoLogin called');
    try {
      // Ensure box is initialized
      if (_box == null) {
        await _initBox();
      }

      final token = _box?.get(_tokenKey);
      print('[UserController] autoLogin token from Hive: $token');

      if (token != null && token.toString().isNotEmpty) {
        apiClient.setToken(token);
        print('[UserController] Token set in ApiClient');

        final response = await apiClient.get('/auth/me');
        print('[UserController] /auth/me response: $response');

        _user = UserModel.fromJson(response);
        print(
          '[UserController] autoLogin fetched user: ${_user?.name}, email: ${_user?.email}',
        );
        notifyListeners();
      } else {
        print('[UserController] No token found in Hive, user remains Guest');
      }
    } catch (e) {
      print('[UserController] autoLogin error: $e');
      // If token is invalid, clear it
      await _box?.delete(_tokenKey);
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    print('[UserController] logout called');
    _user = null;
    apiClient.setToken('');
    await _box?.delete(_tokenKey);
    print('[UserController] User logged out, token cleared from Hive');
    notifyListeners();
  }
}

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final _isAuthenticated = false.obs;
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final _isLoading = false.obs;

  bool get isAuthenticated => _isAuthenticated.value;
  UserModel? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;

  static const String _keyIsAuthenticated = 'is_authenticated';
  static const String _keyUserData = 'user_data';

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isAuth = prefs.getBool(_keyIsAuthenticated) ?? false;
      final userData = prefs.getString(_keyUserData);

      if (isAuth && userData != null) {
        _currentUser.value = UserModel.fromJson(json.decode(userData));
        _isAuthenticated.value = true;
      }
    } catch (e) {
      Get.log('Error checking auth status: $e', isError: true);
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _saveAuthData(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsAuthenticated, true);
      await prefs.setString(_keyUserData, json.encode(user.toJson()));
    } catch (e) {
      Get.log('Error saving auth data: $e', isError: true);
    }
  }

  Future<void> _clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyIsAuthenticated);
      await prefs.remove(_keyUserData);
    } catch (e) {
      Get.log('Error clearing auth data: $e', isError: true);
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));

      // Mock login
      final user = UserModel(
        id: '1',
        name: 'John Doe',
        email: email,
        photoUrl: 'https://via.placeholder.com/150',
        createdAt: DateTime.now(),
      );

      _currentUser.value = user;
      _isAuthenticated.value = true;

      // Save to cache
      await _saveAuthData(user);

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to login: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      _isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));

      // Mock register
      final user = UserModel(
        id: '1',
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      _currentUser.value = user;
      _isAuthenticated.value = true;

      // Save to cache
      await _saveAuthData(user);

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to register: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _clearAuthData();
    _currentUser.value = null;
    _isAuthenticated.value = false;
    Get.offAllNamed('/login');
  }

  Future<void> socialLogin(String provider) async {
    try {
      _isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));

      // Mock social login
      final user = UserModel(
        id: '1',
        name: 'Social User',
        email: 'social@example.com',
        photoUrl: 'https://via.placeholder.com/150',
        createdAt: DateTime.now(),
      );

      _currentUser.value = user;
      _isAuthenticated.value = true;

      // Save to cache
      await _saveAuthData(user);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to login with $provider: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
}

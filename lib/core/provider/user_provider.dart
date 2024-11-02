import 'package:dashboard/core/api_requests/login.dart';
import 'package:dashboard/core/enums/auth_status.dart';
import 'package:dashboard/core/exceptions/auth_exceptions.dart';
import 'package:dashboard/core/models/_models.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  AuthStatus _authStatus = AuthStatus.initial;
  String? _lastError;

  UserModel? get user => _user;
  AuthStatus get authStatus => _authStatus;
  String? get lastError => _lastError;

  // Getters for user details based on the new model
  String get firstName => _user?.firstName ?? '';
  String get lastName => _user?.lastName ?? '';
  String get middleName => _user?.middleName ?? '';
  String get suffix => _user?.suffix ?? '';
  String get username => _user?.username ?? '';
  String get patientID => _user?.patientID ?? '';
  String get department => _user?.department ?? '';
  String get userID => _user?.userID ?? '';
  String get pin => _user?.pin ?? '';
  String get email => _user?.email ?? '';
  String get sex => _user?.sex ?? '';
  String get birthday => _user?.birthday ?? '';
  String get occupation => _user?.occupation ?? '';
  String get role => _user?.role ?? '';
  String get userFirebaseGenId => _user?.userFirebaseGenId ?? '';
  String get hospitalID => _user?.hospitalID ?? '';
  List<dynamic> get devices => _user?.devices ?? [];
  String? get bearerToken => _user?.bearerToken;

  void _setAuthStatus(AuthStatus status) {
    _authStatus = status;
    notifyListeners();
  }

  void _setError(String error) {
    _lastError = error;
    _authStatus = AuthStatus.error;
    notifyListeners();
  }

  Future<void> authenticateUser(String email, String password) async {
    try {
      _setAuthStatus(AuthStatus.authenticating);
      _lastError = null;

      // Attempt login
      final loginResponse = await loginAuth(email, password, "");

      if (loginResponse['accessToken'] == null) {
        throw AuthException(
            loginResponse['message'] ?? 'Authentication failed');
      }

      final String bearerToken = loginResponse['accessToken'];

      // Get user details
      final userDetails = await getUserDetails(bearerToken);
      final extraUserDetails = getUserExtraDetails(bearerToken);

      // Create user model
      _user = UserModel.fromJson(
        userDetails.userDetails,
        extraUserDetails,
        bearerToken: bearerToken,
      );

      _setAuthStatus(AuthStatus.authenticated);
    } on AuthException catch (e) {
      _setError(e.message);
      rethrow;
    } catch (e) {
      _setError('An unexpected error occurred');
      throw AuthException('An unexpected error occurred');
    }
  }

  void signOut() {
    _user = null;
    _authStatus = AuthStatus.unauthenticated;
    _lastError = null;
    notifyListeners();
  }
}

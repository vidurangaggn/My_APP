import 'package:flutter_application_7/services/auth/auth_provider.dart';
import 'package:flutter_application_7/services/auth/auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider _authProvider;
  const AuthService(this._authProvider);

  @override
  Future<AuthUser> createUser({required String email, required String password}) {
    return _authProvider.createUser(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _authProvider.currentUser;

  @override
  Future<AuthUser?> logIn({required String email, required String password}) {
    return _authProvider.logIn(email: email, password: password);
  }

  @override
  Future<void> logOut() {
    return _authProvider.logOut();
  }

  @override
  Future<void> sendEmailVerification() {
    return _authProvider.sendEmailVerification();
  }

  @override
  
}
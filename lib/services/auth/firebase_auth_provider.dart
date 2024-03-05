import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth,FirebaseAuthException;
import 'package:flutter_application_7/services/auth/auth_exception.dart';

import 'package:flutter_application_7/services/auth/auth_provider.dart';
import 'package:flutter_application_7/services/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  AuthUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user == null ? null : AuthUser.fromFirebase(user);
  }

  @override
  Future<AuthUser?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      }else{
        throw UserNotLoggedInException();
      }

    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found'){
        throw UserNotFoundAuthException();
      }else if(e.code == 'wrong-password'){
        throw WrongPasswordAuthException();
      }else if(e.code == 'invalid-email'){
        throw InvalidEmailAuthException();
      }else{
        throw GenericAuthException();
      }
    }catch(e){
      throw GenericAuthException();
    }
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      }else{
        throw UserNotLoggedInException();
      }

    } on FirebaseAuthException catch (e) {
      if(e.code == 'email-already-in-use'){
        throw EmailAlreadyInUseAuthException();
      }else if(e.code == 'weak-password'){
        throw WeakPasswordAuthException();
      }else if(e.code == 'invalid-email'){
        throw InvalidEmailAuthException();
      }else{
        throw GenericAuthException();
      }
      
    }catch(e){
      throw GenericAuthException();
    } 
  }

  @override
  Future<void> logOut() async {
    if(currentUser != null){
      await _firebaseAuth.signOut();
    }else{
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }else{
      throw UserNotLoggedInException();
    }
  }
}
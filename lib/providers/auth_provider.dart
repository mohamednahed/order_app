import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:order_app/models/user.dart';
import 'package:order_app/services/local_storage.dart';

class AuthProvider extends ChangeNotifier {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;

  User? _user;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _errorMessage;

  AuthProvider() {
    _loadLocalUser();
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;

  void _loadLocalUser() {
    final rememberMe = LocalStorage.shouldRememberUser;
    final storedUser = LocalStorage.getUser();

    if (rememberMe && storedUser != null) {
      _user = storedUser;
      _isLoggedIn = true;
      notifyListeners();
      return;
    }

    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password, [bool rememberMe = true]) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credentials = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final uid = credentials.user?.uid;
      if (uid == null) {
        _errorMessage = 'Unable to authenticate user.';
        return false;
      }

      final snapshot = await _firestore.collection('users').doc(uid).get();
      String name = email.split('@').first;
      if (snapshot.exists && snapshot.data() != null) {
        name = snapshot.data()!['name'] as String? ?? name;
      }

      _user = User(id: uid, name: name, email: email);
      _isLoggedIn = true;
      await LocalStorage.saveUser(_user!, rememberMe);
      return true;
    } on fb.FirebaseAuthException catch (error) {
      _errorMessage = error.message ?? 'Login failed. Please try again.';
      return false;
    } catch (_) {
      _errorMessage = 'Login failed. Please check your connection.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password, [bool rememberMe = true]) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credentials = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final uid = credentials.user?.uid;
      if (uid == null) {
        _errorMessage = 'Unable to register user.';
        return false;
      }

      _user = User(id: uid, name: name, email: email);
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'createdAt': firestore.FieldValue.serverTimestamp(),
      });
      _isLoggedIn = true;
      await LocalStorage.saveUser(_user!, rememberMe);
      return true;
    } on fb.FirebaseAuthException catch (error) {
      _errorMessage = error.message ?? 'Registration failed. Please try again.';
      return false;
    } catch (_) {
      _errorMessage = 'Registration failed. Please check your connection.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final normalizedEmail = email.trim().toLowerCase();
      await _auth.sendPasswordResetEmail(email: normalizedEmail);
      return true;
    } on fb.FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'invalid-email':
          _errorMessage = 'Please enter a valid email address.';
          break;
        case 'user-not-found':
          _errorMessage = 'No account was found for this email.';
          break;
        default:
          _errorMessage = error.message ?? 'Unable to send reset link.';
      }
      return false;
    } catch (_) {
      _errorMessage = 'Unable to send reset link. Please check your connection.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await LocalStorage.clearUser();
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}

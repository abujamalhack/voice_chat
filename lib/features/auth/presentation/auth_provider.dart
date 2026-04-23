import 'package:flutter/material.dart';
import '../data/auth_repository.dart';
import '../domain/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();
  AppUser? _user;

  AuthProvider() {
    _repo.userStream.listen((user) {
      _user = user;
      notifyListeners();
    });
    // تحميل المستخدم الحالي عند البدء
    _user = _repo.currentUser;
  }

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<String?> loginWithEmail(String email, String password) async {
    try {
      _user = await _repo.signInWithEmail(email, password);
      notifyListeners();
      return null; // لا خطأ
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'خطأ في تسجيل الدخول';
    } catch (e) {
      return 'حدث خطأ غير متوقع';
    }
  }

  Future<String?> loginWithGoogle() async {
    try {
      _user = await _repo.signInWithGoogle();
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'خطأ في تسجيل الدخول عبر Google';
    } catch (e) {
      return 'حدث خطأ غير متوقع';
    }
  }

  Future<void> logout() async {
    await _repo.signOut();
    _user = null;
    notifyListeners();
  }
}

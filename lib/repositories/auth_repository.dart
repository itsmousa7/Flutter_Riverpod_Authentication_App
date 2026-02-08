import 'package:future_riverpod/constants/supabase_constants.dart';
import 'package:future_riverpod/models/custom_error.dart';
import 'package:future_riverpod/repositories/handle_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  User? get currentUser => sbAuth.currentUser;

  /// ----------------------------
  /// SIGN UP
  /// ----------------------------
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await sbAuth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'myapplication://signUp',
      );
    } catch (e) {
      throw handleException(e);
    }
  }

  /// ----------------------------
  /// SIGN IN
  /// ----------------------------
  Future<void> signin({
    required String email,
    required String password,
  }) async {
    try {
      await sbAuth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw handleException(e);
    }
  }

  /// ----------------------------
  /// SIGN OUT
  /// ----------------------------
  Future<void> signOut() async {
    try {
      await sbAuth.signOut();
    } catch (e) {
      throw handleException(e);
    }
  }

  /// ----------------------------
  /// CHANGE PASSWORD
  /// ----------------------------
  Future<void> changePassword(String password) async {
    try {
      await sbAuth.updateUser(
        UserAttributes(password: password),
      );
    } catch (e) {
      throw handleException(e);
    }
  }

  /// ----------------------------
  /// RESET PASSWORD
  /// ----------------------------
  Future<void> resetPasswordForEmail(String email) async {
    try {
      await sbAuth.resetPasswordForEmail(
        email,
        redirectTo: 'myapplication://signUp',
      );
    } catch (e) {
      throw handleException(e);
    }
  }

  /// ----------------------------
  /// SEND EMAIL VERIFICATION
  /// ----------------------------
  Future<void> sendEmailVerification() async {
    try {
      final user = currentUser;

      if (user == null || user.email == null) {
        throw const CustomError(
          message: 'No authenticated user.',
        );
      }

      await sbAuth.resend(
        type: OtpType.email,
        email: user.email!,
      );
    } catch (e) {
      throw handleException(e);
    }
  }

  /// ----------------------------
  /// REFRESH SESSION
  /// ----------------------------
  Future<void> refreshSession() async {
    try {
      await sbAuth.refreshSession();
    } catch (e) {
      throw handleException(e);
    }
  }
}

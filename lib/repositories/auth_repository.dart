import 'package:future_riverpod/constants/supabase_constants.dart';
import 'package:future_riverpod/repositories/handle_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  User? get currentUser => sbAuth.currentUser;

  /// ----------------------------
  /// SIGN UP
  /// ----------------------------
  Future<String> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await sbAuth.signUp(
        email: email,
        password: password,
        data: {'username': name},
      );

      print('Signup response: ${response.user?.id}');
      print('User email: ${response.user?.email}');
      print('Email confirmed at: ${response.user?.emailConfirmedAt}');

      if (response.user == null) {
        throw Exception('User creation failed');
      }

      return email;
    } catch (e) {
      print('Signup error: $e');
      throw handleException(e);
    }
  }

  /// ----------------------------
  /// VERIFY OTP
  /// ----------------------------
  Future<void> verifyOtp({
    required String email,
    required String token,
  }) async {
    try {
      final response = await sbAuth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.signup,
      );

      print('Verify OTP response: ${response.user?.id}');
      print('Email confirmed at: ${response.user?.emailConfirmedAt}');

      if (response.session == null) {
        throw Exception('OTP verification failed - no session created');
      }
    } catch (e) {
      print('Verify OTP error: $e');
      throw handleException(e);
    }
  }

  /// ----------------------------
  /// RESEND OTP
  /// ----------------------------
  Future<void> resendOtp({required String email}) async {
    try {
      final response = await sbAuth.resend(
        type: OtpType.signup,
        email: email,
      );

      print('Resend OTP response: $response');
    } catch (e) {
      print('Resend OTP error: $e');
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
      final response = await sbAuth.signInWithPassword(
        email: email,
        password: password,
      );

      print('Sign in response: ${response.user?.id}');
      print('Session: ${response.session?.accessToken}');
    } catch (e) {
      print('Sign in error: $e');
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

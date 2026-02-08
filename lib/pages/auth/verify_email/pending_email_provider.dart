import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pending_email_provider.g.dart';
/// Stores the email address of a user who just signed up
/// but doesn't have an active session yet
// pending_email_provider.dart

@riverpod
class PendingVerificationEmail extends _$PendingVerificationEmail {
  @override
  String? build() {
    return null;
  }

  void setEmail(String email) {
    state = email;
  }

  void clear() {
    state = null;
  }
}
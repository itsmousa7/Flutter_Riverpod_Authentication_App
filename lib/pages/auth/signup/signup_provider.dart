import 'package:future_riverpod/pages/auth/verify_email/pending_email_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../repositories/auth_repository_provider.dart';

part 'signup_provider.g.dart';

@riverpod
class Signup extends _$Signup {
  Object? _key;

  @override
  FutureOr<void> build() {
    _key = Object();
    ref.onDispose(() {
      print('[signupProvider] disposed');
      _key = null;
    });
  }

  // Update your signup method in signup_provider.dart
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading<void>();
    final key = _key;

    final newState = await AsyncValue.guard<void>(
      () async {
        await ref
            .read(authRepositoryProvider)
            .signup(name: name, email: email, password: password);

        // Store the pending email for verification page
        ref.read(pendingVerificationEmailProvider.notifier).setEmail(email);
      },
    );

    if (key == _key) {
      state = newState;
    }
  }
}

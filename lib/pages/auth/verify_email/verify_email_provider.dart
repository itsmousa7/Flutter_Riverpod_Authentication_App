import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../repositories/auth_repository_provider.dart';

part 'verify_email_provider.g.dart';

@riverpod
class VerifyEmail extends _$VerifyEmail {
  Object? _key;

  @override
  FutureOr<void> build() {
    _key = Object();
    ref.onDispose(() {
      print('[verifyEmailProvider] disposed');
      _key = null;
    });
  }

  Future<void> verifyOtp({
    required String email,
    required String token,
  }) async {
    state = const AsyncLoading<void>();
    final key = _key;

    final newState = await AsyncValue.guard<void>(
      () async {
        await ref
            .read(authRepositoryProvider)
            .verifyOtp(
              email: email,
              token: token,
            );
      },
    );

    if (key == _key) {
      state = newState;
    }
  }

  Future<void> resendOtp({required String email}) async {
    state = const AsyncLoading<void>();
    final key = _key;

    final newState = await AsyncValue.guard<void>(
      () async {
        await ref.read(authRepositoryProvider).resendOtp(email: email);
      },
    );

    if (key == _key) {
      state = newState;
    }
  }
}

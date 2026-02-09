import 'package:future_riverpod/constants/supabase_constants.dart';
import 'package:future_riverpod/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}

@riverpod
Stream<User?> authStateStream(Ref ref) {
  return sbAuth.onAuthStateChange.map((data) => data.session?.user);
}

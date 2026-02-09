import 'package:future_riverpod/pages/auth/verify_email/email_verification.dart';
import 'package:future_riverpod/pages/splash/supabase_error_page.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../pages/auth/reset_password/reset_password_page.dart';
import '../../pages/auth/signin/signin_page.dart';
import '../../pages/auth/signup/signup_page.dart';
import '../../pages/content/change_password/change_password_page.dart';
import '../../pages/content/home/home_page.dart';
import '../../pages/page_not_found.dart';
import '../../pages/splash/splash_page.dart';
import '../../repositories/auth_repository_provider.dart';
import 'route_names.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authStateStreamProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      // Still loading auth state
      if (authState is AsyncLoading<User?>) {
        return '/splash';
      }

      // Error with Supabase connection
      if (authState is AsyncError<User?>) {
        return '/supabaseError';
      }

      // Get the current user from the stream value
      final user = authState.value;
      final authenticated = user != null;

      final authenticating =
          state.matchedLocation == '/signin' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/resetPassword' ||
          state.matchedLocation == '/verifyEmail';

      final splashing = state.matchedLocation == '/splash';

      // Not authenticated - redirect to signin unless already on auth pages
      if (!authenticated) {
        return authenticating ? null : '/signin';
      }

      // Authenticated and verified - redirect to home if on auth/splash pages
      if (authenticating || splashing) {
        return '/home';
      }

      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (context, state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: '/supabaseError',
        name: RouteNames.supabaseError,
        builder: (context, state) {
          return const SupabaseErrorPage();
        },
      ),
      GoRoute(
        path: '/signin',
        name: RouteNames.signin,
        builder: (context, state) {
          return const SigninPage();
        },
      ),
      GoRoute(
        path: '/signup',
        name: RouteNames.signup,
        builder: (context, state) {
          return const SignupPage();
        },
      ),
      GoRoute(
        path: '/resetPassword',
        name: RouteNames.resetPassword,
        builder: (context, state) {
          return const ResetPasswordPage();
        },
      ),
      GoRoute(
        path: '/verifyEmail',
        name: RouteNames.verifyEmail,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return EmailVerification(email: email);
        },
      ),
      GoRoute(
        path: '/home',
        name: RouteNames.home,
        builder: (context, state) {
          return const HomePage();
        },
        routes: [
          GoRoute(
            path: 'changePassword',
            name: RouteNames.changePassword,
            builder: (context, state) {
              return const ChangePasswordPage();
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return PageNotFound(
        errorMessage: state.error.toString(),
      );
    },
  );
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_riverpod/config/router/route_names.dart';
import 'package:future_riverpod/constants/supabase_constants.dart';
import 'package:future_riverpod/pages/auth/verify_email/pending_email_provider.dart';
import 'package:future_riverpod/repositories/auth_repository_provider.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  Timer? timer;
  bool isEmailVerified = false;
  bool canResendEmail = true;

  @override
  void initState() {
    super.initState();

    // Start checking for verification
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      checkEmailVerified();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    try {
      // Refresh session to check if email was verified
      await ref.read(authRepositoryProvider).refreshSession();

      final user = sbAuth.currentUser;

      if (user?.emailConfirmedAt != null) {
        print('✅ Email verified! Redirecting to home...');

        // Clear the pending email since verification is complete
        ref.read(pendingVerificationEmailProvider.notifier).clear();

        setState(() {
          timer?.cancel();
          isEmailVerified = true;
        });

        if (mounted) {
          context.goNamed(RouteNames.home);
        }
      }
    } catch (e) {
      print('⚠️ Error checking email verification: $e');
    }
  }

  Future<void> sendEmailVerification() async {
    if (!canResendEmail) return;

    final user = sbAuth.currentUser;
    final pendingEmail = ref.read(pendingVerificationEmailProvider);

    if (user == null && pendingEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No email to verify'),
        ),
      );
      return;
    }

    try {
      if (user != null) {
        // User has a session - use the repository method
        await ref.read(authRepositoryProvider).sendEmailVerification();
      } else {
        // No session - we need to resend the signup email
        // You might need to add a method to your AuthRepository to resend signup email
        // For now, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please complete the signup process again'),
          ),
        );
        return;
      }

      setState(() {
        canResendEmail = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent!'),
        ),
      );

      // Reset canResendEmail after 60 seconds
      Future.delayed(const Duration(seconds: 60), () {
        if (mounted) {
          setState(() {
            canResendEmail = true;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = sbAuth.currentUser;
    final pendingEmail = ref.read(pendingVerificationEmailProvider);

    final displayEmail = user?.email ?? pendingEmail ?? 'your email';

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email, size: 100),
              const SizedBox(height: 24),
              const Text(
                'Check Your Email',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'We sent a verification link to:',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                displayEmail,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                'Click the link in the email to complete your registration.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: canResendEmail ? sendEmailVerification : null,
                icon: const Icon(Icons.refresh),
                label: Text(canResendEmail ? 'Resend Email' : 'Wait 60s'),
              ),
              const SizedBox(height: 16),
              if (user == null) ...[
                TextButton(
                  onPressed: () {
                    // Clear pending email and go back to signup
                    ref.read(pendingVerificationEmailProvider.notifier).clear();
                    context.goNamed(RouteNames.signup);
                  },
                  child: const Text('Back to Sign Up'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

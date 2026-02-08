import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_riverpod/config/router/route_names.dart';
import 'package:future_riverpod/models/custom_error.dart';
import 'package:future_riverpod/pages/auth/signin/signin_provider.dart';
import 'package:future_riverpod/pages/widgets/custom_buttons.dart';
import 'package:future_riverpod/pages/widgets/form_fields.dart';
import 'package:future_riverpod/utils/error_dialog.dart';
import 'package:go_router/go_router.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final form = _formKey.currentState;
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
    if (form == null || !form.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    ref.read(signinProvider.notifier).signin(email, password);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signinProvider, (prev, next) {
      next.whenOrNull(
        error: (error, _) {
          final customError = error as CustomError;

          if (customError.message == 'email_not_confirmed') {
            context.goNamed(RouteNames.verifyEmail);
            return;
          }

          errorDialog(context, customError);
        },
      );
    });
    final signinState = ref.watch(signinProvider);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            autovalidateMode: _autovalidateMode,
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              reverse: true,
              children: [
                const FlutterLogo(
                  size: 150,
                ),
                const SizedBox(
                  height: 20,
                ),
                EmailFormField(emailController: _emailController),
                const SizedBox(
                  height: 20,
                ),
                PasswordFormField(
                  passwordController: _passwordController,
                  labelText: 'Password',
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomFilledButtons(
                  onPressed: () {
                    signinState.maybeWhen(
                      loading: null,
                      orElse: () => _submit(),
                    );
                  },
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  child: signinState.maybeWhen(
                    loading: () => const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    orElse: () => const Text('Sign in'),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    const SizedBox(
                      width: 5,
                    ),
                    CustomTextButtons(
                      onPressed: () =>
                          GoRouter.of(context).goNamed(RouteNames.signup),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      foreground: Colors.purple,
                      child: const Text('Sign up'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextButtons(
                  onPressed: () =>
                      GoRouter.of(context).goNamed(RouteNames.resetPassword),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  foreground: Colors.green,
                  child: const Text('Forget Password?'),
                ),
              ].reversed.toList(),
            ),
          ),
        ),
      ),
    );
  }
}

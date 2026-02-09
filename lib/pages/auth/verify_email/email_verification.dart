import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../models/custom_error.dart';
import '../../../utils/error_dialog.dart';
import 'verify_email_provider.dart';

class EmailVerification extends ConsumerStatefulWidget {
  final String email;

  const EmailVerification({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends ConsumerState<EmailVerification> {
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";
  bool _canResend = false;
  int _resendCountdown = 60;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    // Start countdown immediately when page loads
    _startResendCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    errorController?.close();
    textEditingController.dispose();
    super.dispose();
  }

  void _startResendCountdown() {
    _countdownTimer?.cancel();

    if (!mounted) return;

    setState(() {
      _canResend = false;
      _resendCountdown = 60;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  void _resendOtp() {
    if (!_canResend) return;

    ref.read(verifyEmailProvider.notifier).resendOtp(email: widget.email);
    _startResendCountdown();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP code resent to your email')),
      );
    }
  }

  void _verifyOtp(String token) {
    ref
        .read(verifyEmailProvider.notifier)
        .verifyOtp(
          email: widget.email,
          token: token,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      verifyEmailProvider,
      (previous, next) {
        if (!mounted) return;

        next.whenOrNull(
          error: (e, st) {
            if (!mounted) return;

            errorController?.add(ErrorAnimationType.shake);
            textEditingController.clear();
            errorDialog(context, e as CustomError);
          },
        );
      },
    );

    final verifyState = ref.watch(verifyEmailProvider);
    final isLoading = verifyState.isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: const FlutterLogo(size: 60),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Email Verification",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 16,
              ),
            ),
            Text(
              "Enter the 6 digit code sent to ${widget.email}",
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: PinCodeTextField(
                autoFocus: true,
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                obscureText: true,
                obscuringCharacter: '*',
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                enabled: !isLoading,
                validator: (v) {
                  if (v!.length < 6) {
                    return "Please enter the complete code";
                  }
                  return null;
                },
                pinTheme: PinTheme(
                  inactiveFillColor: Colors.green,
                  inactiveColor: Colors.green,
                  selectedColor: Colors.black,
                  selectedFillColor: Colors.white,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  disabledColor: Colors.grey,
                ),
                cursorColor: Colors.black,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                errorAnimationController: errorController,
                controller: textEditingController,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  ),
                ],
                onCompleted: (v) {
                  _verifyOtp(v);
                },
                onChanged: (value) {
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (text) {
                  return true;
                },
              ),
            ),
            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            Row(
              children: [
                const Text("Didn't get any email?"),
                TextButton(
                  onPressed: _canResend && !isLoading ? _resendOtp : null,
                  child: Text(
                    _canResend
                        ? "Resend code"
                        : "Resend code in ${_resendCountdown}s",
                    style: TextStyle(
                      color: _canResend ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

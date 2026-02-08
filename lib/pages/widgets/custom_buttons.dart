// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomFilledButtons extends StatelessWidget {
  final void Function() onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final Widget child;
  const CustomFilledButtons({
    super.key,
    required this.onPressed,
    required this.fontSize,
    required this.fontWeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: child,
    );
  }
}

class CustomTextButtons extends StatelessWidget {
  final void Function() onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final Color foreground;
  final Widget child;
  const CustomTextButtons({
    super.key,
    required this.onPressed,
    required this.fontSize,
    required this.fontWeight,
    required this.foreground,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        textStyle: TextStyle(
          foreground: Paint()..color = foreground,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        minimumSize: Size.zero,

        padding: EdgeInsetsGeometry.zero,
      ),

      child: child,
    );
  }
}

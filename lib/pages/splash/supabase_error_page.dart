import 'package:flutter/material.dart';

class SupabaseErrorPage extends StatelessWidget {
  const SupabaseErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Supabase Connection Error\n\nTry later!',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.red,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

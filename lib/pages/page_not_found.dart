// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:future_riverpod/config/router/route_names.dart';
import 'package:go_router/go_router.dart';

class PageNotFound extends StatelessWidget {
  final String errorMessage;
  const PageNotFound({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              OutlinedButton(
                onPressed: () {
                  GoRouter.of(context).goNamed(RouteNames.home);
                },
                child: const Text('Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

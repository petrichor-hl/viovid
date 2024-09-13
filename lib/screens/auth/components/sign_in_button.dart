import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/base/common_variables.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        context.go('/sign-in');
      },
      style: FilledButton.styleFrom(
        fixedSize: const Size(170, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: primaryColor,
      ),
      child: const Text(
        'Đăng nhập',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}

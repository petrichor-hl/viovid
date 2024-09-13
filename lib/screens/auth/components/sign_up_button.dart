import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/base/common_variables.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        context.go('/sign-up');
      },
      style: OutlinedButton.styleFrom(
        fixedSize: const Size(170, 48),
        side: const BorderSide(width: 2, color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundColor: primaryColor,
      ),
      child: const Text(
        'Đăng ký',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}

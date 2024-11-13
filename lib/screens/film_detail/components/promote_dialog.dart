import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/base/assets.dart';
import 'package:viovid/base/common_variables.dart';

class PromoteDialog extends StatelessWidget {
  const PromoteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Assets.rubySparkles,
                width: 100,
                height: 100,
              ),
              const Gap(8),
              const Text(
                'THÔNG TIN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  // color: Colors.white,
                ),
              ),
              const Gap(12),
              const Text(
                'Bạn cần tài khoản trả phí để có thể xem nội dung này.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  // color: Colors.white,
                ),
              ),
              const Gap(20),
              FilledButton(
                onPressed: () => context.go('/register-plan'),
                style: ButtonStyle(
                  fixedSize: const WidgetStatePropertyAll(
                    Size.fromHeight(40),
                  ),
                  foregroundColor: const WidgetStatePropertyAll(
                    Colors.white,
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith(
                    (states) {
                      // WidgetState.pressed đứng trước WidgetState.hovered
                      // if (states.contains(WidgetState.pressed)) {
                      //   return primaryColor;
                      // }
                      if (states.contains(WidgetState.hovered)) {
                        return Colors.amber;
                      }
                      return primaryColor;
                    },
                  ),
                ),
                child: const Text(
                  'Nâng cấp Premium',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Gap(20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Bỏ qua",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

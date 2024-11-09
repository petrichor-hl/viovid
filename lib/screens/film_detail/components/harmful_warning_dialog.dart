import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/common_variables.dart';

class HarmfulWarningDialog extends StatelessWidget {
  const HarmfulWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      // backgroundColor: const Color(0xFF252525),
      // surfaceTintColor: Colors.transparent,
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_outlined,
                color: primaryColor,
                size: 60,
              ),
              const Gap(8),
              const Text(
                'CẢNH BÁO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  // color: Colors.white,
                ),
              ),
              const Gap(12),
              const Text(
                'Đánh giá của bạn có chứa ngôn từ tiêu cực.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  // color: Colors.white,
                ),
              ),
              const Gap(20),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  fixedSize: const Size.fromHeight(48),
                  foregroundColor: Colors.white,
                  backgroundColor: primaryColor,
                  disabledForegroundColor: Colors.black,
                  disabledBackgroundColor: const Color(0xFF676767),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Tôi hiểu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

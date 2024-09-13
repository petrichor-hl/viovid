import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/assets.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/screens/auth/components/sign_in_button.dart';
import 'package:viovid/screens/auth/components/sign_up_button.dart';

class HeadSection extends StatefulWidget {
  const HeadSection({super.key});

  @override
  State<HeadSection> createState() => _HeadSectionState();
}

class _HeadSectionState extends State<HeadSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.backgroundLogin),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Assets.viovidLogo,
                width: 140,
                fit: BoxFit.cover,
              ),
              const Spacer(),
              const SignUpButton(),
              const Gap(20),
              const SignInButton(),
            ],
          ),
          const Gap(60),
          const Text(
            'Xem trên bất kỳ thiết bị nào',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(10),
          SizedBox(
            /*
            Khi chiều rộng cửa sổ trình duyệt < 800
            thì width = chiều rộng của cửa sổ trình duyệt
            */
            width: min(800, double.infinity),
            child: const Text(
              'Phát trực tuyến trên điện thoại, máy tính bảng, laptop và TV của bạn mà không cần trả thêm phí.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const Gap(80),
          SizedBox(
            width: min(600, double.infinity),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    // controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(87, 0, 0, 0),
                      hintText: 'Email',
                      // errorText: _isEmailValid ? null : 'Email không hợp lệ',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                    ),
                    style: const TextStyle(color: Colors.white),
                    autocorrect: false,
                    enableSuggestions: false,
                  ),
                ),
                const Gap(20),
                // Sự kiện Đăng ký
                FilledButton(
                  onPressed: () => {},
                  style: FilledButton.styleFrom(
                    fixedSize: const Size(170, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: primaryColor,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Bắt đầu',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Gap(6),
                      Icon(Icons.navigate_next)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/base/assets.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/main.dart';

class ConfirmedSignUp extends StatefulWidget {
  const ConfirmedSignUp({
    super.key,
    required this.refreshToken,
  });

  final String refreshToken;

  @override
  State<ConfirmedSignUp> createState() => _ConfirmedSignUpState();
}

class _ConfirmedSignUpState extends State<ConfirmedSignUp> {
  // final String code;
  late final _futureSession = _checkSession();

  Future<void> _checkSession() async {
    print('LOG: refreshToken = ${widget.refreshToken}');
    await supabase.auth.setSession(widget.refreshToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _futureSession,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              print('LOG: ${snapshot.error}');

              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Có lỗi xảy ra khi truy vấn thông tin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Gap(30),
                    FilledButton(
                      onPressed: () {
                        context.go('/intro');
                      },
                      style: FilledButton.styleFrom(
                        fixedSize: const Size(170, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: primaryColor,
                      ),
                      child: const Text(
                        'Trang chủ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final session = supabase.auth.currentSession;

            return Center(
              child: SizedBox(
                width: 650,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.viovidLogo,
                      width: 300,
                    ),
                    const Gap(30),
                    const Text(
                      'Chúc mừng bạn đã xác nhận tài khoản thành công!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(30),
                    FilledButton(
                      onPressed: () {
                        session == null
                            ? context.go('/sign-in')
                            : context.go('/browse');
                      },
                      style: FilledButton.styleFrom(
                        fixedSize: const Size(170, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: primaryColor,
                      ),
                      child: Text(
                        session == null ? 'Đăng nhập' : 'Trang chủ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

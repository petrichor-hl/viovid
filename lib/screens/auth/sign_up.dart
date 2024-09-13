import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:viovid/base/assets.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/base/components/password_input.dart';
import 'package:viovid/main.dart';
import 'package:viovid/screens/auth/components/sign_in_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _errorText = '';
  bool _isProcessing = false;
  void _submit() async {
    // check
    final endteredFullname = _fullnameController.text;
    final enteredEmail = _emailController.text;
    final enteredPassword = _passwordController.text;
    final enteredConfirmPassword = _confirmPasswordController.text;

    _errorText = '';
    if (endteredFullname.isEmpty) {
      _errorText = 'Bạn chưa nhập Họ và Tên';
    } else if (enteredEmail.isEmpty) {
      _errorText = 'Bạn chưa nhập Email đăng nhập';
    } else if (enteredPassword.isEmpty) {
      _errorText = 'Bạn chưa nhập Mật khẩu';
    } else if (enteredConfirmPassword.isEmpty) {
      _errorText = 'Bạn chưa Xác nhận Mật khẩu';
    } else if (enteredPassword.length < 6) {
      _errorText = 'Mật khẩu có ít nhất 6 ký tự';
    } else if (enteredPassword != enteredConfirmPassword) {
      _errorText = 'Xác nhận mật khẩu không chính xác';
    }

    if (_errorText.isNotEmpty) {
      setState(() {});
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final List<Map<String, dynamic>> checkDuplicate = await supabase
          .from('profile')
          .select('email')
          .eq('email', enteredEmail);

      if (checkDuplicate.isEmpty) {
        await supabase.auth.signUp(
          email: enteredEmail,
          password: enteredPassword,
          emailRedirectTo: 'http://localhost:5416/#/confirmed-sign-up',
          data: {
            'email': enteredEmail,
            'password': enteredPassword,
            'full_name': endteredFullname,
            'dob': '01/05/2003',
            'avatar_url': 'default_avt.png',
          },
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Xác thực Email trong Hộp thư đến.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        _errorText = 'Email đã được đăng ký. Vui lòng sử dụng Email khác';
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Có lỗi xảy ra, vui lòng thử lại.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Row(
              children: [
                Image.asset(
                  Assets.viovidLogo,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                const Spacer(),
                const Text(
                  'Bạn đã có tài khoản?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Gap(10),
                const SignInButton(),
              ],
            ),
          ),
          const Divider(
            height: 1,
            color: Color.fromRGBO(0, 0, 0, 0.2),
          ),
          Expanded(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Đăng ký tài khoản',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const Gap(24),
                  Ink(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, // Màu sắc của border
                        width: 1, // Độ rộng của border
                      ),
                      borderRadius:
                          BorderRadius.circular(10), // Bán kính của border
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Họ và Tên',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextField(
                          controller: _fullnameController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Tran Van A',
                            hintStyle: TextStyle(color: Color(0xFFACACAC)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            isCollapsed: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(14),
                  Ink(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, // Màu sắc của border
                        width: 1, // Độ rộng của border
                      ),
                      borderRadius:
                          BorderRadius.circular(10), // Bán kính của border
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextField(
                          controller: _emailController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'viovid@gmail.com',
                            hintStyle: TextStyle(color: Color(0xFFACACAC)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            isCollapsed: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(14),
                  PasswordTextField(
                    passwordController: _passwordController,
                  ),
                  const Gap(14),
                  PasswordTextField(
                    title: 'Xác nhận mật khẩu',
                    passwordController: _confirmPasswordController,
                    onEditingComplete: _submit,
                  ),
                  const Gap(20),
                  Align(
                    child: Text(
                      _errorText,
                      style: errorTextStyle(context),
                    ),
                  ),
                  const Gap(12),
                  Align(
                    child: _isProcessing
                        ? const SizedBox(
                            height: 44,
                            width: 44,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            ),
                          )
                        : FilledButton(
                            onPressed: _submit,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: primaryColor,
                            ),
                            child: const Text(
                              'Đăng ký',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/data/dynamic/profile_data.dart';
import 'package:viovid/main.dart';

class ProfileDialog extends StatelessWidget {
  ProfileDialog({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: const Color(0xFF252525),
      surfaceTintColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 750),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Thông tin tài khoản',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_outlined),
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                    )
                  ],
                ),
                const Gap(14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: '$baseAvatarUrl/${profileData['avatar_url']}',
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                        // fadeInDuration: là thời gian xuất hiện của Image khi đã load xong
                        fadeInDuration: const Duration(milliseconds: 300),
                        // fadeOutDuration: là thời gian biến mất của placeholder khi Image khi đã load xong
                        fadeOutDuration: const Duration(milliseconds: 500),
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(76),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(10), // Padding all = 8
                          decoration: const BoxDecoration(
                            color: primaryColor, // Background màu đỏ
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                            ), // Border radius = 4
                          ),
                          child: const Icon(
                            Icons.image_rounded,
                            color: Colors.white,
                          ), // Widget con
                        ),
                      )
                    ],
                  ),
                ),
                const Gap(14),
                Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      child: Text(
                        'Email: ',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        enabled: false,
                        initialValue: supabase.auth.currentUser!.email,
                        style: const TextStyle(color: Colors.white54),
                        decoration: const InputDecoration(
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      child: Text(
                        'Họ tên: ',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: profileData['full_name'],
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      child: Text(
                        'Ngày sinh: ',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: profileData['dob'],
                        style: const TextStyle(color: Colors.white),
                        // onTap: () {
                        //   showDatePicker(
                        //     context: context,
                        //     firstDate: DateTime(2003, 4, 17),
                        //     lastDate: DateTime.now(),
                        //   );
                        // },
                        decoration: const InputDecoration(
                          // suffix: IconButton(
                          //   onPressed: () {},
                          //   icon: const Icon(
                          //     Icons.edit_calendar_rounded,
                          //   ),
                          //   style: IconButton.styleFrom(
                          //     foregroundColor: primaryColor,
                          //   ),
                          // ),
                          border: InputBorder.none,
                          // If you need to custom InputBorder
                          // border: MaterialStateOutlineInputBorder.resolveWith(
                          //   (states) {
                          //     if (states.contains(WidgetState.focused)) {
                          //       return const OutlineInputBorder(
                          //         borderRadius: BorderRadius.all(
                          //           Radius.circular(8),
                          //         ),
                          //         borderSide:
                          //             BorderSide(color: Colors.amber, width: 2),
                          //       );
                          //     } else if (states.contains(WidgetState.hovered)) {
                          //       return const OutlineInputBorder(
                          //         borderRadius: BorderRadius.all(
                          //           Radius.circular(8),
                          //         ),
                          //         borderSide:
                          //             BorderSide(color: Colors.amber, width: 1),
                          //       );
                          //     }
                          //     return const OutlineInputBorder(
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(8),
                          //       ),
                          //       borderSide: BorderSide(color: Colors.transparent),
                          //     );
                          //   },
                          // ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      child: Text(
                        'Thành viên: ',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      'Thường',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () => context.go('/register-plan'),
                      style: ButtonStyle(
                        foregroundColor:
                            const WidgetStatePropertyAll(Colors.white),
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
                    )
                  ],
                ),
                const Gap(8),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    fixedSize: const Size.fromHeight(44),
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Lưu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

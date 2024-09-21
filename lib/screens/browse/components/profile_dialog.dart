import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/base/assets.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/data/dynamic/profile_data.dart';
import 'package:viovid/main.dart';

class ProfileDialog extends StatelessWidget {
  ProfileDialog({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isHoverAvatar = false;

    bool isNormalUser = profileData['end_date'] == null ||
        (profileData['end_date'] != null &&
            DateTime.tryParse(profileData['end_date']) != null &&
            DateTime.parse(profileData['end_date']).isBefore(DateTime.now()));
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: const Color(0xFF252525),
      surfaceTintColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 770),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
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
                const Gap(30),
                Row(
                  children: [
                    StatefulBuilder(builder: (context, setState) {
                      return MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            isHoverAvatar = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            isHoverAvatar = false;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            DecoratedBox(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipOval(
                                  clipBehavior: Clip.antiAlias,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '$baseAvatarUrl/${profileData['avatar_url']}',
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                    // fadeInDuration: là thời gian xuất hiện của Image khi đã load xong
                                    fadeInDuration:
                                        const Duration(milliseconds: 300),
                                    // fadeOutDuration: là thời gian biến mất của placeholder khi Image khi đã load xong
                                    fadeOutDuration:
                                        const Duration(milliseconds: 500),
                                    placeholder: (context, url) =>
                                        const Padding(
                                      padding: EdgeInsets.all(76),
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (isHoverAvatar)
                              Positioned.fill(
                                child: InkWell(
                                  overlayColor: const WidgetStatePropertyAll(
                                    Colors.transparent,
                                  ),
                                  onTap: () {},
                                  child: const ClipOval(
                                    child: ColoredBox(
                                      color: Colors.black26,
                                      child: Center(
                                        child: Icon(
                                          Icons.photo_camera_rounded,
                                          size: 32,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                              bottom: -5,
                              right: -5,
                              child: Image.asset(
                                Assets.rubySparkles,
                                width: 50,
                                height: 50,
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                    const Gap(30),
                    Expanded(
                      child: Column(
                        children: [
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
                                  initialValue:
                                      supabase.auth.currentUser!.email,
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
                              isNormalUser
                                  ? const Text(
                                      'Thường',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xFFEDA145),
                                            Color(0xFFC03744),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 6, 20, 4),
                                        child: Text(
                                          profileData['plan'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                              const Spacer(),
                              if (isNormalUser)
                                FilledButton(
                                  onPressed: () => context.go('/register-plan'),
                                  style: ButtonStyle(
                                    foregroundColor:
                                        const WidgetStatePropertyAll(
                                            Colors.white),
                                    backgroundColor:
                                        WidgetStateProperty.resolveWith(
                                      (states) {
                                        // WidgetState.pressed đứng trước WidgetState.hovered
                                        // if (states.contains(WidgetState.pressed)) {
                                        //   return primaryColor;
                                        // }
                                        if (states
                                            .contains(WidgetState.hovered)) {
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
                        ],
                      ),
                    )
                  ],
                ),
                const Gap(40),
                Center(
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      fixedSize: const Size.fromHeight(44),
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Lưu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/base/assets.dart';
import 'package:viovid/data/dynamic/profile_data.dart';
import 'package:viovid/main.dart';
import 'package:viovid/screens/browse/components/profile_dialog.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      offset: const Offset(0, 4),
      itemBuilder: (ctx) => <PopupMenuEntry>[
        PopupMenuItem(
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => ProfileDialog(),
            );
          },
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.userIcon,
                width: 22,
              ),
              const Gap(12),
              const Text('Tài khoản'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {},
          child: const Row(
            children: [
              Icon(
                Icons.question_mark_rounded,
                size: 22,
              ),
              Gap(12),
              Text('Trung tâm trợ giúp'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {},
          child: const Row(
            children: [
              Icon(
                Icons.password_rounded,
                size: 22,
              ),
              Gap(12),
              Text('Đổi mật khẩu'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () async {
            await supabase.auth.signOut();
            if (context.mounted) {
              context.go('/intro');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Center(
                    child: Text(
                      'Hẹn sớm gặp lại bạn.',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 4),
                  width: 300,
                ),
              );
            }
          },
          child: const Row(
            children: [
              Icon(
                Icons.logout_rounded,
                size: 22,
              ),
              Gap(12),
              Text('Đăng xuất'),
            ],
          ),
        ),
      ],
      tooltip: '',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          imageUrl: '$baseAvatarUrl/${profileData['avatar_url']}',
          height: 50,
          width: 50,
          fit: BoxFit.cover,
          // fadeInDuration: là thời gian xuất hiện của Image khi đã load xong
          fadeInDuration: const Duration(milliseconds: 300),
          // fadeOutDuration: là thời gian biến mất của placeholder khi Image khi đã load xong
          fadeOutDuration: const Duration(milliseconds: 500),
          placeholder: (context, url) => const Padding(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

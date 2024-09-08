import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:viovid/base/assets.dart';
import 'package:viovid/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    final session = supabase.auth.currentSession;
    if (mounted) {
      if (session != null) {
        context.go('/browse');
      } else {
        context.go('/intro');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Executes a function only one time after the layout is completed
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirect());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.primary,
        highlightColor: Colors.amber,
        child: Image.asset(
          Assets.viovidLogo,
          width: 300,
        ),
      ),
    );
  }
}

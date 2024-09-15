import 'package:flutter/material.dart';
import 'package:viovid/screens/admin/_layout/components/siderbar.dart';

class AdminLayout extends StatelessWidget {
  const AdminLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7ECF7),
      body: Row(
        children: [
          const SideBar(),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

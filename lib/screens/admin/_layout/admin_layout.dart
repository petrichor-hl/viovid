import 'package:flutter/material.dart';
import 'package:viovid/data/dynamic/topics_data.dart';
import 'package:viovid/screens/admin/_layout/components/siderbar.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  Future<void> fetchData() async {
    await fetchTopicsData();
    await Future.delayed(const Duration(milliseconds: 3));
    setState(() {
      isFetchingData = false;
    });
  }

  bool isFetchingData = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
    // Executes a function only one time after the layout is completed*/
  }

  @override
  Widget build(BuildContext context) {
    return isFetchingData
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.white,
            body: Row(
              children: [
                const SideBar(),
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          );
  }
}

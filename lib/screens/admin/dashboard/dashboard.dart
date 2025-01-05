import 'package:flutter/material.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/screens/admin/dashboard/components/payment_chart.dart';
import 'package:viovid/screens/admin/dashboard/components/top_payment.dart';
import 'package:viovid/screens/admin/dashboard/components/top_view_chart.dart';
import 'package:viovid/screens/admin/dashboard/components/topic_chart.dart';
import 'package:viovid/screens/admin/dashboard/components/header.dart';
import 'package:viovid/screens/admin/dashboard/components/user_regist_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical, // Vertical scrolling

        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Header(header: "Dashboard"),
                const SizedBox(height: 6),
                const Divider(
                  color: secondaryColorBorder,
                  thickness: 1,
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: secondaryColorBorder,
                                width: 1,
                              ),
                            ),
                            child: const PaymentChart()),
                      ),
                      const SizedBox(width: defaultPadding),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: secondaryColorBorder,
                              width: 1,
                            ),
                          ),
                          child: const TopicPieChart(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Line 2
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: secondaryColorBorder,
                              width: 1,
                            ),
                          ),
                          child: const TopPaymentType(),
                        ),
                      ),
                      const SizedBox(width: defaultPadding),
                      Expanded(
                        flex: 5,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: secondaryColorBorder,
                                width: 1,
                              ),
                            ),
                            child: const UserRegistChart()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(color: Colors.white, child: const TopViewChart()),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/models/dto/dto_topic.dart';
import 'package:viovid/screens/admin/dashboard/components/payment_chart.dart';
import 'package:viovid/screens/admin/dashboard/components/top_payment.dart';
import 'package:viovid/screens/admin/dashboard/components/top_view_chart.dart';
import 'package:viovid/screens/admin/dashboard/components/topic_chart.dart';
import 'package:viovid/screens/admin/dashboard/components/header.dart';
import 'package:viovid/screens/admin/dashboard/components/user_regist_chart.dart';
import 'package:viovid/service/service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController();

  late List<DtoTopic> topicsDataFuture;
  late List<int> userRegistDataFuture;

  Future<void> fetchTopicsData() async {
    topicsDataFuture = await fetchTopics();
  }

  Future<void> fetchUserRegistData() async {
    userRegistDataFuture = await fetchUserRegist(DateTime.now().year);
  }

  @override
  Widget build(BuildContext context) {
    const List<Color> palette = [
      Color.fromARGB(255, 130, 2, 98),
      Color.fromARGB(255, 41, 23, 32),
      Color.fromARGB(255, 193, 42, 90),
      Color.fromARGB(255, 4, 167, 118),
      Color.fromARGB(255, 255, 209, 102),
      Color.fromARGB(255, 255, 81, 81),
    ];

    return SafeArea(
      child: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical, // Vertical scrolling

        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Header(),
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
                            child: PaymentChart(
                              selectedYear: DateTime.now().year,
                            )),
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
                          child: FutureBuilder(
                            future: fetchTopicsData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return TopicPieChart(
                                  palette: palette,
                                  data: topicsDataFuture,
                                );
                              }
                            },
                          ),
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
                          child: FutureBuilder(
                            future: fetchUserRegistData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return UserRegistChart(
                                  data: userRegistDataFuture,
                                );
                              }
                            },
                          ),
                        ),
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

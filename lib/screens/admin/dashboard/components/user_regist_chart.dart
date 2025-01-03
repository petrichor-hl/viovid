import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/service/service.dart';

class UserRegistChart extends StatefulWidget {
  const UserRegistChart({super.key, required this.data});

  final List<int> data;

  @override
  State<UserRegistChart> createState() => _UserRegistChartState();
}

class _UserRegistChartState extends State<UserRegistChart> {
  int selectedYear = 2025;
  int _highestNum = 90;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Số người mới đăng ký',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: secondaryColorTitle,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<BarChartGroupData>>(
                  future: _getUserRegistrationData(selectedYear),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading data'));
                    } else {
                      return BarChart(
                        BarChartData(
                          barGroups: snapshot.data,
                          borderData: FlBorderData(show: false),
                          titlesData: _buildAxes(),
                          barTouchData: BarTouchData(),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => setState(() => selectedYear--),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    selectedYear.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => setState(() => selectedYear++),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  FlTitlesData _buildAxes() {
    int topValue = _highestNum - _highestNum % 10 + 10;

    return FlTitlesData(
        show: true,
        // Build X axis.
        bottomTitles: AxisTitles(sideTitles: _bottomTitles),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: defaultGetTitle,
            reservedSize: 30,
            interval:
                ((topValue / 5).toDouble() < 2) ? 1 : (topValue / 5).toDouble(),
          ),
          // axisNameWidget: const Text('Số người đăng ký'),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)));
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: (value, meta) {
          return Text([
            'Th1',
            'Th2',
            'Th3',
            'Th4',
            'Th5',
            'Th6',
            'Th7',
            'Th8',
            'Th9',
            'Th10',
            'Th11',
            'Th12'
          ][value.toInt()]);
        },
      );

  Future<List<BarChartGroupData>> _getUserRegistrationData(int year) async {
    final data = await fetchUserRegist(selectedYear);
    _highestNum = data.reduce((a, b) => a > b ? a : b);
    return data.asMap().entries.map((entry) {
      return BarChartGroupData(x: entry.key, barRods: [
        BarChartRodData(toY: entry.value.toDouble(), color: Colors.yellow)
      ]);
    }).toList();
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/models/dto/dto_payment.dart';
import 'package:viovid/service/service.dart';

class PaymentChart extends StatefulWidget {
  const PaymentChart({super.key, required this.selectedYear});
  final int selectedYear;

  @override
  State<PaymentChart> createState() => _PaymentChartState();
}

class _PaymentChartState extends State<PaymentChart> {
  late Future<List<BarChartGroupData>> paymentDataFuture;
  int selectedYear = 2025;
  double _highestNum = 250;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'Doanh thu năm ($selectedYear)',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: secondaryColorTitle,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<BarChartGroupData>>(
                  future: _getPaymentData(selectedYear),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading data'));
                    } else {
                      return BarChart(
                        BarChartData(
                          maxY: _highestNum,
                          groupsSpace: 12,
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
              const SizedBox(height: 8),
              _buildNote(),
              const SizedBox(height: 8),
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
    double topValue = _highestNum - _highestNum % 10 + 10;

    return FlTitlesData(
        show: true,
        // Build X axis.
        bottomTitles: AxisTitles(sideTitles: _bottomTitles),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: defaultGetTitle,
            reservedSize: 50,
            interval:
                ((topValue / 5).toDouble() < 2) ? 1 : (topValue / 5).toDouble(),
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)));
  }

  Future<List<BarChartGroupData>> _getPaymentData(int year) async {
    try {
      List<DtoPayment> payments = await fetchPayments(year);
      // Add demo data
      if (selectedYear == 2024) {
        payments
            .add(const DtoPayment(month: 10, type: 'wallet', amount: 100000));
      }
      if (selectedYear == 2025) {
        payments.add(const DtoPayment(month: 1, type: 'wallet', amount: 90000));
      }
      _highestNum =
          payments.map((p) => p.amount).reduce((a, b) => a > b ? a : b);
      // Group payments by month
      Map<int, Map<String, double>> groupedPayments = {
        0: {},
        1: {},
        2: {},
        3: {},
      };
      for (var payment in payments) {
        int quarter = (payment.month - 1) ~/ 3;
        if (!groupedPayments[quarter]!.containsKey(payment.type)) {
          groupedPayments[quarter]![payment.type] = 0;
        }
        groupedPayments[quarter]![payment.type] =
            groupedPayments[quarter]![payment.type]! + payment.amount;
      }

      // Convert grouped payments to BarChartGroupData
      List<BarChartGroupData> barChartData = [];
      groupedPayments.forEach((quarter, payments) {
        List<BarChartRodData> rods = payments.entries.map((entry) {
          return BarChartRodData(
            toY: entry.value,
            width: 15, // Adjust the width of each bar
            color: _getColorForPaymentType(
                entry.key), // Customize the bar color based on payment type
          );
        }).toList();

        barChartData.add(
          BarChartGroupData(
            x: quarter - 1,
            barRods: rods,
            barsSpace: 4,
            // showingTooltipIndicators:
            //     List.generate(rods.length, (index) => index),
          ),
        );
      });

      return barChartData;
    } catch (e) {
      print(e);
      throw Exception('Failed to load payment data');
    }
  }

  Widget _buildNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNoteItem('Momo', _getColorForPaymentType('momo')),
        const SizedBox(width: 10),
        _buildNoteItem('VNPay', _getColorForPaymentType('vnpay')),
        const SizedBox(width: 10),
        _buildNoteItem('Stripe', _getColorForPaymentType('stripe')),
        const SizedBox(width: 10),
        _buildNoteItem('Wallet', _getColorForPaymentType('wallet')),
      ],
    );
  }

  Widget _buildNoteItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Color _getColorForPaymentType(String type) {
    switch (type.toLowerCase()) {
      case 'momo':
        return Colors.blue;
      case 'vnpay':
        return const Color.fromARGB(255, 129, 199, 132);
      case 'stripe':
        return const Color.fromARGB(255, 255, 184, 77);
      case 'wallet':
        return secondaryColor;
      default:
        return Colors.grey;
    }
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: (value, meta) {
          switch (value.toInt()) {
            case -1:
              return const Text('Quý 1');
            case 0:
              return const Text('Quý 2');
            case 1:
              return const Text('Quý 3');
            case 2:
              return const Text('Quý 4');
            default:
              return const Text('');
          }
        },
      );
}

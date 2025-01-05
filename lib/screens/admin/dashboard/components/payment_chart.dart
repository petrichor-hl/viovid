import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/base/components/error_dialog.dart';
import 'package:viovid/features/dashboard_management/cubit/payment_list/payment_list_list_cubit.dart';
import 'package:viovid/features/dashboard_management/cubit/payment_list/payment_list_list_state.dart';
import 'package:viovid/features/dashboard_management/dtos/payment_dto.dart';

class PaymentChart extends StatefulWidget {
  const PaymentChart({super.key});

  @override
  State<PaymentChart> createState() => _PaymentChartState();
}

class _PaymentChartState extends State<PaymentChart> {
  int selectedYear = 2025;
  double _highestNum = 10000;

  @override
  void initState() {
    super.initState();
    context.read<PaymentListCubit>().getPaymentsList(selectedYear);
  }

  void handleChangeYear() async {
    context.read<PaymentListCubit>().getPaymentsList(selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentListCubit, PaymentListState>(
      listenWhen: (previous, current) => current.errorMessage.isNotEmpty,
      listener: (ctx, state) {
        if (state.errorMessage.isNotEmpty) {
          showDialog(
            context: context,
            builder: (ctx) => ErrorDialog(errorMessage: state.errorMessage),
          );
        }
      },
      builder: (ctx, state) {
        if (state.isLoading) {
          return _buildInProgressWidget();
        }
        if (state.payments != null) {
          return _buildPaymentList(_getPaymentData(state.payments!));
        }
        if (state.errorMessage.isNotEmpty) {
          return _buildFailureWidget(state.errorMessage);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildInProgressWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        Gap(14),
        Text(
          'Đang xử lý ...',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(50),
      ],
    );
  }

  Widget _buildFailureWidget(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentList(List<BarChartGroupData> payments) {
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
                  child: BarChart(
                BarChartData(
                  maxY: _highestNum,
                  groupsSpace: 12,
                  barGroups: payments,
                  borderData: FlBorderData(show: false),
                  titlesData: _buildAxes(),
                  barTouchData: BarTouchData(),
                ),
              )),
              const SizedBox(height: 8),
              _buildNote(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      selectedYear--;
                      handleChangeYear();
                    }),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    selectedYear.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      selectedYear++;
                      handleChangeYear();
                    }),
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

  List<BarChartGroupData> _getPaymentData(List<PaymentDto> data) {
    try {
      // Add demo data
      if (selectedYear == 2024) {
        data.add(const PaymentDto(month: 10, type: 'wallet', amount: 100000));
      }
      if (selectedYear == 2025) {
        data.add(const PaymentDto(month: 1, type: 'wallet', amount: 90000));
      }
      _highestNum = data.map((p) => p.amount).reduce((a, b) => a > b ? a : b);
      // Group payments by month
      Map<int, Map<String, double>> groupedPayments = {
        0: {},
        1: {},
        2: {},
        3: {},
      };
      for (var payment in data) {
        int quarter = (payment.month - 1) ~/ 3;
        if (!groupedPayments[quarter]!.containsKey(payment.type)) {
          groupedPayments[quarter]![payment.type] = 0;
        }
        groupedPayments[quarter]![payment.type] =
            groupedPayments[quarter]![payment.type]! + payment.amount;
      }

      // Convert grouped payments to BarChartGroupData
      List<BarChartGroupData> barChartData = [];
      groupedPayments.forEach((quarter, data) {
        List<BarChartRodData> rods = data.entries.map((entry) {
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

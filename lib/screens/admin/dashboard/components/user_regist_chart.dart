import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/base/components/error_dialog.dart';
import 'package:viovid/features/dashboard_management/cubit/user_register/user_register_list_cubit.dart';
import 'package:viovid/features/dashboard_management/cubit/user_register/user_register_list_state.dart';

class UserRegistChart extends StatefulWidget {
  const UserRegistChart({super.key});

  // final List<int> data;

  @override
  State<UserRegistChart> createState() => _UserRegistChartState();
}

class _UserRegistChartState extends State<UserRegistChart> {
  int selectedYear = 2025;
  int _highestNum = 90;

  @override
  void initState() {
    super.initState();
    context.read<UserRegisterListCubit>().getUserRegist(selectedYear);
  }

  void handleChangeYear() async {
    context.read<UserRegisterListCubit>().getUserRegist(selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserRegisterListCubit, UserRegisterListState>(
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
        if (state.usersRegistered != null) {
          return _buildUserRegisterdList(state.usersRegistered!);
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

  Widget _buildUserRegisterdList(List<int> users) {
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
                  child: BarChart(
                BarChartData(
                  barGroups: _getUserRegistrationData(users),
                  borderData: FlBorderData(show: false),
                  titlesData: _buildAxes(),
                  barTouchData: BarTouchData(),
                ),
              )),
              const SizedBox(height: 10),
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

  List<BarChartGroupData> _getUserRegistrationData(List<int> data) {
    _highestNum = data.reduce((a, b) => a > b ? a : b);
    return data.asMap().entries.map((entry) {
      return BarChartGroupData(x: entry.key, barRods: [
        BarChartRodData(toY: entry.value.toDouble(), color: Colors.yellow)
      ]);
    }).toList();
  }
}

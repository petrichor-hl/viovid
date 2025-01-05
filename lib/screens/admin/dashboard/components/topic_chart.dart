import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/base/components/error_dialog.dart';
import 'package:viovid/features/topic_management/cubit/topic_management_cubit.dart';
import 'package:viovid/features/topic_management/cubit/topic_management_state.dart';
import 'package:viovid/features/topic_management/dtos/topic_dto.dart';

class TopicPieChart extends StatefulWidget {
  const TopicPieChart({
    super.key,
  });

  @override
  State<TopicPieChart> createState() => _TopicPieChartState();
}

class _TopicPieChartState extends State<TopicPieChart> {
  int touchedIndex = -1;
  bool isDrawerOpen = false; // Controls whether the drawer is visible
  int? selectedDataIndex; // Tracks the clicked slice index
  List<Color> palette = const [
    Color.fromARGB(255, 130, 2, 98),
    Color.fromARGB(255, 41, 23, 32),
    Color.fromARGB(255, 193, 42, 90),
    Color.fromARGB(255, 4, 167, 118),
    Color.fromARGB(255, 255, 209, 102),
    Color.fromARGB(255, 255, 81, 81),
  ];

  void toggleDrawer([int? index]) {
    setState(() {
      // Toggle drawer and set selected index
      if (index != null) {
        selectedDataIndex = index;
      }
      isDrawerOpen = !isDrawerOpen;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<TopicManagementCubit>().getTopicList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TopicManagementCubit, TopicManagementState>(
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
        if (state.topics != null) {
          return _buildTopicChart(state.topics!);
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

  Widget _buildTopicChart(List<TopicDto> topics) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Tổng quan chủ đề",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: secondaryColorTitle,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event,
                            PieTouchResponse? pieTouchResponse) {
                          if (event is FlTapUpEvent &&
                              pieTouchResponse != null &&
                              pieTouchResponse.touchedSection != null) {
                            final index = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                            if (index >= 0) toggleDrawer(index);
                          }
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            setState(() {
                              touchedIndex = -1;
                            });
                            return;
                          }
                          setState(() {
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      startDegreeOffset: -90,
                      sectionsSpace: 0,
                      centerSpaceRadius: 70,
                      sections: List.generate(
                        topics.length,
                        (index) => PieChartSectionData(
                          value: (topics[index].films.length).toDouble(),
                          radius: touchedIndex == index ? 60 : 40 - index * 2.0,
                          title: (topics[index].films.length).toString(),
                          showTitle: touchedIndex == index,
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          color: palette[index % palette.length],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${topics.length}",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: secondaryColorTitle,
                              ),
                        ),
                        const Text(
                          "Chủ đề",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: secondaryColorTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(defaultPadding),
                margin: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: secondaryColorBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      topics.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: palette[index % palette.length],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                topics[index].name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColorTitle,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Drawer that slides out to the left of the chart
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: isDrawerOpen ? 0 : -260, // Drawer slides in/out based on state
          top: 0,
          bottom: 0,
          child: Container(
            width: 250,
            decoration: BoxDecoration(
              color: secondaryColorBg,
              border: Border.all(
                color: secondaryColorBorder,
                width: 1,
              ),
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(4),
                  child: IconButton(
                    icon: Icon(
                      isDrawerOpen ? Icons.close : Icons.menu,
                    ),
                    onPressed: () => toggleDrawer(),
                  ),
                ),
                if (selectedDataIndex != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Danh sách phim ${topics[selectedDataIndex!].name}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (selectedDataIndex != null)
                  Expanded(
                    child: ListView.builder(
                      itemCount: topics[selectedDataIndex!].films.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              topics[selectedDataIndex!].films[index].name),
                        );
                      },
                    ),
                  ),
                const SizedBox(
                  height: defaultPadding,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

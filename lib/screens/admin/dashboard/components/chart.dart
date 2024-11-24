import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/models/topic.dart';

class DashboardChart extends StatefulWidget {
  const DashboardChart({
    super.key,
    required this.palette,
    required this.data,
  });

  final List<Color> palette;
  final List<Topic> data;

  @override
  State<DashboardChart> createState() => _DashboardChartState();
}

class _DashboardChartState extends State<DashboardChart> {
  int touchedIndex = -1;
  bool isDrawerOpen = false; // Controls whether the drawer is visible
  int? selectedDataIndex; // Tracks the clicked slice index

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
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Stack(
        children: [
          // Main container with the chart
          Container(
            height: 550,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: secondaryColorBorder,
                width: 1,
              ),
            ),
            child: Column(
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
                            widget.data.length,
                            (index) => PieChartSectionData(
                              value:
                                  widget.data[index].posters.length.toDouble(),
                              radius:
                                  touchedIndex == index ? 60 : 40 - index * 2.0,
                              title:
                                  widget.data[index].posters.length.toString(),
                              showTitle: touchedIndex == index,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              color:
                                  widget.palette[index % widget.palette.length],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${widget.data.length}",
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
                          widget.data.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: widget
                                        .palette[index % widget.palette.length],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    widget.data[index].name,
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
          ),
          // Drawer that slides out to the left of the chart
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left:
                isDrawerOpen ? 0 : -260, // Drawer slides in/out based on state
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
                        "Danh sách phim ${widget.data[selectedDataIndex!].name}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(widget.data[index].name),
                          subtitle: Text(
                              "${widget.data[index].posters.length} posters"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

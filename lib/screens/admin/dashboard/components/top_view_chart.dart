import 'package:flutter/material.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/models/dto/dto_top_view_film.dart';
import 'package:viovid/service/service.dart';

class TopViewChart extends StatefulWidget {
  const TopViewChart({super.key});

  @override
  State<TopViewChart> createState() => _TopViewChartState();
}

class _TopViewChartState extends State<TopViewChart> {
  final int number = 5;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Top các phim được xem nhiều nhất',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: secondaryColorTitle,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
              future: _getPaymentData(number),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                } else {
                  return Column(
                    children: List.generate(
                        number,
                        (index) => Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        snapshot.data![index].posterPath),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.5),
                                      BlendMode.multiply,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: defaultPadding),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 24,
                                        child: Text((index + 1).toString(),
                                            style: const TextStyle(
                                                fontSize: 24,
                                                color: Colors.black)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          snapshot.data![index].name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${snapshot.data![index].numberOfViews}  lượt xem",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: defaultPadding,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<List<DtoTopViewFilm>> _getPaymentData(int number) async {
    final data = await fetchTopViewFilms(number);
    return data;
  }
}

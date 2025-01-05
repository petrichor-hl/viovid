import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/base/components/error_dialog.dart';
import 'package:viovid/features/dashboard_management/cubit/top_film_list/top_film_list_cubit.dart';
import 'package:viovid/features/dashboard_management/cubit/top_film_list/top_film_list_state.dart';
import 'package:viovid/features/dashboard_management/dtos/top_view_film_dto.dart';

class TopViewChart extends StatefulWidget {
  const TopViewChart({super.key});

  @override
  State<TopViewChart> createState() => _TopViewChartState();
}

class _TopViewChartState extends State<TopViewChart> {
  final int number = 5;

  @override
  void initState() {
    super.initState();
    context.read<TopFilmListCubit>().getUserRegist(number);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TopFilmListCubit, TopFilmListState>(
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
        if (state.topViewFilms != null) {
          return _buildTopViewFilmList(state.topViewFilms!);
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

  Widget _buildTopViewFilmList(List<TopViewFilmDto> topViewFilms) {
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
            child: Column(
              children: List.generate(
                  number,
                  (index) => Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  NetworkImage(topViewFilms[index].posterPath),
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
                                          fontSize: 24, color: Colors.black)),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    topViewFilms[index].name,
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
                                  "${topViewFilms[index].numberOfViews}  lượt xem",
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
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

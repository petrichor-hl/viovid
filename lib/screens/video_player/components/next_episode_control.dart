import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid/bloc/cubits/video_state_cubit.dart';

class NextEpisodeControl extends StatelessWidget {
  const NextEpisodeControl(
    this.goToNextEpisode, {
    super.key,
  });

  final void Function() goToNextEpisode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoStateCubit, VideoState>(
      builder: (context, videoState) {
        return IconButton(
          onPressed: goToNextEpisode,
          icon: const Icon(
            Icons.skip_next_rounded,
            size: 40,
          ),
          style: IconButton.styleFrom(
            foregroundColor: Colors.white,
          ),
        );
      },
    );
  }
}

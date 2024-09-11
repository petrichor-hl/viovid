import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:viovid/bloc/cubits/video_state_cubit.dart';

class BackControl extends StatelessWidget {
  const BackControl(
    this.videoPlayerController,
    this.startCountdownToDismissControls, {
    super.key,
  });

  final VideoPlayerController videoPlayerController;
  final void Function() startCountdownToDismissControls;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoStateCubit, VideoState>(
      builder: (context, videoState) {
        return IconButton(
          onPressed: () {
            startCountdownToDismissControls();
            videoPlayerController.seekTo(
              videoPlayerController.value.position -
                  const Duration(seconds: 10),
            );
          },
          icon: const Icon(
            Icons.replay_10_rounded,
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

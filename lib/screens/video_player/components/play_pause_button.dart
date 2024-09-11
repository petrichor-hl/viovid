import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:viovid/bloc/cubits/video_state_cubit.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton(
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
            videoPlayerController.value.isPlaying
                ? videoPlayerController.pause()
                : videoPlayerController.play();
          },
          icon: Icon(
            videoPlayerController.value.isPlaying
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
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

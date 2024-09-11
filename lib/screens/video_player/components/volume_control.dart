import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:viovid/bloc/cubits/video_state_cubit.dart';

class VolumeControl extends StatelessWidget {
  const VolumeControl(
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
        final isMuted = videoPlayerController.value.volume == 0;
        return IconButton(
          onPressed: () {
            startCountdownToDismissControls();
            if (isMuted) {
              videoPlayerController.setVolume(1);
            } else {
              videoPlayerController.setVolume(0);
            }
          },
          icon: Icon(
            isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
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

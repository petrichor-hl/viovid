import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:video_player/video_player.dart';
import 'package:viovid/bloc/cubits/video_state_cubit.dart';

String _convertFromDuration(Duration duration) {
  int mins = duration.inMinutes;
  int secs = duration.inSeconds % 60;

  return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
}

String _convertFromSeconds(int initalSeconds) {
  int mins = (initalSeconds ~/ 60);
  int secs = (initalSeconds % 60);
  return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
}

class ProgressBar extends StatelessWidget {
  const ProgressBar(
    this.overlayVisible,
    this.videoPlayerController,
    this.startCountdownToDismissControls,
    this.cancelTimer, {
    super.key,
  });

  final bool overlayVisible;
  final VideoPlayerController videoPlayerController;

  final void Function() cancelTimer;
  final void Function() startCountdownToDismissControls;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoStateCubit, VideoState>(
      builder: (context, videoState) {
        return Row(
          children: [
            const Gap(20),
            Expanded(
              child: Slider(
                value: videoState.progress.isNaN ? 0 : videoState.progress,
                label: _convertFromSeconds(
                  ((videoState.progress.isNaN ? 0 : videoState.progress) *
                          videoPlayerController.value.duration.inSeconds)
                      .toInt(),
                ),
                onChanged: (value) {
                  context.read<VideoStateCubit>().setProgress(value);
                },
                onChangeStart: (value) async {
                  await videoPlayerController.pause();
                  cancelTimer();
                },
                onChangeEnd: (value) async {
                  await videoPlayerController.seekTo(
                    Duration(
                      milliseconds: (value *
                              videoPlayerController
                                  .value.duration.inMilliseconds)
                          .toInt(),
                    ),
                  );
                  videoPlayerController.play();
                  startCountdownToDismissControls();
                },
              ),
            ),
            Text(
              _convertFromDuration(videoPlayerController.value.duration -
                  videoPlayerController.value.position),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const Gap(50),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid/bloc/cubits/video_state_cubit.dart';
import 'package:web/web.dart';

class FullScreenControl extends StatelessWidget {
  const FullScreenControl(
    this.startCountdownToDismissControls, {
    super.key,
  });

  final void Function() startCountdownToDismissControls;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoStateCubit, VideoState>(
      builder: (context, videoState) {
        return IconButton(
          onPressed: () {
            if (videoState.isFullScreen) {
              document.exitFullscreen();
            } else {
              final flutterView =
                  document.getElementsByTagName('flutter-view').item(0)!;
              flutterView.requestFullscreen();
            }

            startCountdownToDismissControls();
          },
          icon: Icon(
            videoState.isFullScreen
                ? Icons.fullscreen_exit_rounded
                : Icons.fullscreen_rounded,
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

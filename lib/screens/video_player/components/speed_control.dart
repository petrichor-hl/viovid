import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/bloc/cubits/video_state_cubit.dart';

class SpeedControl extends StatelessWidget {
  SpeedControl(
    this.videoPlayerController,
    this.startCountdownToDismissControls, {
    super.key,
  });

  final VideoPlayerController videoPlayerController;
  final void Function() startCountdownToDismissControls;

  final speedOptions = [0.5, 0.75, 1.0, 1.25, 1.5];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoStateCubit, VideoState>(
      builder: (context, videoState) {
        return IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) {
                return Dialog(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Chọn tốc phát phát',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(20),
                          ...speedOptions.map(
                            (speedOption) => RadioListTile(
                              activeColor: primaryColor,
                              title:
                                  videoPlayerController.value.playbackSpeed ==
                                          speedOption
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${speedOption}x',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.check_rounded,
                                              color: primaryColor,
                                            ),
                                          ],
                                        )
                                      : Text('${speedOption}x'),
                              value: speedOption,
                              groupValue:
                                  videoPlayerController.value.playbackSpeed,
                              onChanged: (value) {
                                if (value != null) {
                                  videoPlayerController.setPlaybackSpeed(value);
                                  context.pop();
                                }
                              },
                              dense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );

            startCountdownToDismissControls();
          },
          icon: const Icon(
            Icons.speed_rounded,
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

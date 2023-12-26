import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ControlWidget extends StatelessWidget {
  final AudioPlayer audioPlayer;
  const ControlWidget({super.key, required this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            onPressed: audioPlayer.seekToPrevious,
            iconSize: 58,
            icon: const Icon(Icons.skip_previous_rounded)),
        StreamBuilder(
            stream: audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (!(playing ?? false)) {
                return IconButton(
                    onPressed: audioPlayer.play,
                    iconSize: 58,
                    icon: const Icon(Icons.play_arrow_rounded));
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                    onPressed: audioPlayer.pause,
                    iconSize: 58,
                    icon: const Icon(Icons.pause_rounded));
              } else {
                return const Center(child: CupertinoActivityIndicator());
              }
            }),
        IconButton(
            onPressed: audioPlayer.seekToNext,
            iconSize: 58,
            icon: const Icon(Icons.skip_next_rounded)),
      ],
    );
  }
}

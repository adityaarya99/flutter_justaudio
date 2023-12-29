import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testplayer/feature/audio_player/screen/app_audio_player.dart';
import 'package:testplayer/common/widgets/audio_tile_widget.dart';
import 'package:testplayer/feature/video_player/screen/app_video_player.dart';
import 'package:testplayer/feature/video_player/widget/app_bar_video.dart';

class VideoListScreen extends StatelessWidget {
  final List<String> videoFiles;
  const VideoListScreen({super.key, required this.videoFiles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text('Video Files (${videoFiles.length})'),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                ...List.generate(
                    videoFiles.length,
                    (index) => ListTileWidget(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AppVideoPlayer(
                                        filePath: videoFiles[index])));
                          },
                          index: index,
                          fileName: videoFiles[index],
                          isAudio: false,
                        ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

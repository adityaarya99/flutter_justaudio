import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testplayer/feature/audio_player/screen/app_audio_player.dart';
import 'package:testplayer/common/widgets/audio_tile_widget.dart';

class VideoListScreen extends StatelessWidget {
  final List<FileSystemEntity> videoFiles;
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                                    builder: (context) => AppAudioPlayer(
                                          filePath: videoFiles[index].path,
                                          index: index,
                                        )));
                          },
                          index: index,
                          fileName: videoFiles[index].path,
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

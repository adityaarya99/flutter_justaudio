import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testplayer/constant/app_asset.dart';
import 'package:testplayer/feature/audio_player/widget/app_bar_audio.dart';
import 'package:testplayer/feature/video_player/widget/app_bar_video.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatefulWidget {
  final String filePath;
  const AppVideoPlayer({super.key, required this.filePath});

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late FlickManager flickManager;
  @override
  void initState() {
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.file(
      File(widget.filePath),
    ));
    super.initState();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24,),
              const AppBarVideo(),
              const SizedBox(height: 24,),
              FlickVideoPlayer(
                flickManager: flickManager,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Sample Video',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Experience the serene beauty of nature in this breathtaking footage showcasing the vibrant colors of sunrise over the majestic mountains. Feel the tranquility of the cascading waterfalls and lush greenery as you immerse yourself in the sights and sounds of this natural wonderland. Whether you seek relaxation or inspiration, let this video transport you to a place of serene beauty and awe-inspiring landscapes",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

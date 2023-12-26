import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testplayer/feature/audio_player/screen/app_audio_player.dart';
import 'package:testplayer/feature/audio_player/screen/audio_list_screen.dart';
import 'package:testplayer/feature/home/cubit/home_cubit.dart';
import 'package:testplayer/feature/home/cubit/home_state.dart';
import 'package:testplayer/feature/video_player/screen/app_video_player.dart';
import 'package:testplayer/feature/video_player/screen/video_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FileSystemEntity> audioFiles = [];
  List<FileSystemEntity> videoFiles = [];

  @override
  void initState() {
    context.read<HomeCubit>().checkPermissionAndFetchAudioFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is FetchAudioSuccessState) {
            audioFiles.addAll(state.audioFiles);
          }
          if (state is FetchVideoSuccessState) {
            videoFiles.addAll(state.videoFiles);
          }
        },
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoListScreen(
                                    videoFiles: videoFiles,
                                  )));
                    },
                    child: Text((videoFiles.isEmpty)
                        ? 'Video Player'
                        : 'Video Player (${videoFiles.length})')),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AudioListScreen(audioFiles: audioFiles)));
                    },
                    child: Text((audioFiles.isEmpty)
                        ? 'Audio Player'
                        : 'Audio Player (${audioFiles.length})'))
              ],
            ),
          );
        },
      ),
    );
  }
}

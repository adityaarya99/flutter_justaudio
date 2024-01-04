import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:testplayer/constant/app_asset.dart';
import 'package:testplayer/feature/audio_player/screen/app_audio_player.dart';
import 'package:testplayer/feature/audio_player/screen/audio_list_screen.dart';
import 'package:testplayer/feature/home/cubit/home_cubit.dart';
import 'package:testplayer/feature/home/cubit/home_state.dart';
import 'package:testplayer/feature/video_player/screen/app_video_player.dart';
import 'package:testplayer/feature/video_player/screen/video_list_screen.dart';
import 'package:testplayer/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> audioFiles = [];
  List<String> videoFiles = [];

  @override
  void initState() {
    if(Platform.isAndroid){
      context.read<HomeCubit>().checkAndroidVersion();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffFBAB7E),
              Color(0xffF7CE68),
              // Color(0xfff1caf0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is FetchAudioSuccessState) {
              audioFiles.addAll(state.audioFiles);
            }
            if (state is FetchVideoSuccessState) {
              videoFiles.addAll(state.videoFiles);
            }
          },
          builder: (context, state) {
            if (state is FetchAudioLoadingState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LottieBuilder.asset(AppLottie.loadingOne, repeat: true),
                  const Text(
                    'Please wait while we load Audio & Video....',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoListScreen(
                                    videoFiles: videoFiles,
                                  )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16.0))),
                      child: Column(
                        children: [
                          LottieBuilder.asset(
                            AppLottie.videoLottie,
                            height: 200,
                            width: double.infinity,
                          ),
                          Text(
                            (videoFiles.isEmpty)
                                ? 'Video Player'
                                : 'Video Player (${videoFiles.length})',
                            style: const TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AudioListScreen(audioFiles: audioFiles)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16.0))),
                      child: Column(
                        children: [
                          LottieBuilder.asset(
                            AppLottie.audioLottie,
                            height: 200,
                            width: double.infinity,
                          ),
                          Text(
                            (audioFiles.isEmpty)
                                ? 'Audio Player'
                                : 'Audio Player (${audioFiles.length})',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 120,
                      child: LottieBuilder.asset(AppLottie.halloweenLottie)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

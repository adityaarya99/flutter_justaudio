import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:testplayer/constant/app_asset.dart';
import 'package:testplayer/constant/app_colors.dart';
import 'package:testplayer/feature/video_player/cubit/like_dislike_cubit.dart';
import 'package:testplayer/feature/video_player/cubit/like_dislike_state.dart';
import 'package:testplayer/feature/video_player/widget/app_bar_video.dart';
import 'package:testplayer/feature/video_player/widget/video_like_share_widget.dart';
import 'package:testplayer/feature/video_player/widget/video_name_description_widget.dart';
import 'package:testplayer/feature/video_player/widget/video_options_tile.dart';

GlobalKey _betterPlayerKey = GlobalKey();

class AppVideoPlayer extends StatefulWidget {
  final String filePath;
  const AppVideoPlayer({super.key, required this.filePath});

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer>
    with WidgetsBindingObserver {
  late BetterPlayerController _betterPlayerController;

  late bool isPictureInPictureSupported;

  String filename = "";

  bool isVideoLiked = false;

  bool isVideoDisliked = false;

  @override
  void initState() {
    filename = widget.filePath.split('/').last;
    filename = filename.split('.').first;
    WidgetsBinding.instance.addObserver(this);
    _init();
    super.initState();
  }

  void _init() {
    ///INITIALISE BETTER PLAYER
    _betterPlayerController = BetterPlayerController(
       BetterPlayerConfiguration(
        autoDetectFullscreenAspectRatio: true,
        autoDetectFullscreenDeviceOrientation: true,
        autoPlay: true,
        looping: true,
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        widget.filePath,
        notificationConfiguration: BetterPlayerNotificationConfiguration(
          showNotification: true,
          title: filename,
          author: "Some author",
          imageUrl:
              "https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/African_Bush_Elephant.jpg/1200px-African_Bush_Elephant.jpg",
          activityName: "MainActivity",
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      WidgetsBinding.instance.addPostFrameCallback((timings) {
        _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
      });
    }
    print("App Lifecycle State : $state");
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    // const AppBarVideo(),
                    AspectRatio(
                      aspectRatio:
                          (_betterPlayerController.getAspectRatio() ?? 16 / 9),
                      child: BetterPlayer(
                        key: _betterPlayerKey,
                        controller: _betterPlayerController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///VIDEO NAME
                          VideoNameDescriptionWidget(fileName: "Elephant dream"),
                          const SizedBox(
                            height: 14,
                          ),

                          ///Video Description Widget
                          VideoOptionsTile(onTapMoreVert: () {
                            Fluttertoast.showToast(msg: 'Coming Soon...');
                          }),
                          const SizedBox(
                            height: 14,
                          ),

                          ///VIDEO LIKE SHARE WIDGET
                          BlocConsumer<LikeCubit, LikeState>(
                            listener: (context, state) {
                              if (state is LikeSuccessState) {
                                if (isVideoLiked) {
                                  isVideoLiked = false;
                                } else {
                                  isVideoLiked = true;
                                }
                              }
                              if (state is DislikeSuccessState) {
                                if (isVideoDisliked) {
                                  isVideoDisliked = false;
                                } else {
                                  isVideoDisliked = true;
                                }
                              }
                            },
                            builder: (context, state) {
                              return VideoLikeShareWidget(
                                liked: isVideoLiked,
                                diLiked: isVideoDisliked,
                                likes: (isVideoLiked) ? "13" : "12",
                                onTaplike: () {
                                  ///LIKE VIDEO
                                  context.read<LikeCubit>().likeVideo();
                                },
                                onTapDislike: () {
                                  ///DISLIKE VIDEO
                                  context.read<LikeCubit>().disLikeVideo();
                                },
                                onTapShare: () {
                                  ///SHARE FILE
                                  Fluttertoast.showToast(msg: 'Coming Soon...');
                                  //   Share.shareXFiles([XFile(widget.filePath)]);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                BlocConsumer<LikeCubit, LikeState>(
                  listener: (context, state) async {
                    if (state is LikeSuccessState && isVideoLiked) {
                      await Future.delayed(const Duration(milliseconds: 2000));
                      context.read<LikeCubit>().resetState();
                    } else if (state is DislikeSuccessState &&
                        isVideoDisliked) {
                      await Future.delayed(const Duration(milliseconds: 1400));
                      context.read<LikeCubit>().resetState();
                    }
                  },
                  builder: (context, state) {
                    if (state is LikeSuccessState && isVideoLiked) {
                      return Align(
                          alignment: Alignment.bottomCenter,
                          child: LottieBuilder.asset(
                            AppLottie.confettiLottie,
                          ));
                    } else if (state is DislikeSuccessState &&
                        isVideoDisliked) {
                      return Align(
                          alignment: Alignment.bottomCenter,
                          child: LottieBuilder.asset(
                            AppLottie.carCrashLottie,
                          ));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.colorWhiteFb,
                )),
          ],
        ),
      ),
    );
  }
}

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:testplayer/feature/video_player/widget/app_bar_video.dart';

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

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _init();
    super.initState();
  }

  void _init() {
    ///INITIALISE BETTER PLAYER
    _betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(
          // autoDispose: true,
          autoPlay: true,
          looping: true,
        ),
        betterPlayerDataSource: BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,
          widget.filePath,
        ));
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      WidgetsBinding.instance.addPostFrameCallback((timings) {
        _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
      });
    }
    print("App Lifecycle State : $state");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 24,
            ),
            const AppBarVideo(),
            const SizedBox(
              height: 24,
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(
                key: _betterPlayerKey,
                controller: _betterPlayerController,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _betterPlayerController
                        .enablePictureInPicture(_betterPlayerKey);
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Enter Background'),
                      SizedBox(
                        width: 12,
                      ),
                      Icon(Icons.picture_in_picture),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  onPressed: () {
                    _betterPlayerController.disablePictureInPicture();
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Exit Background'),
                      SizedBox(
                        width: 12,
                      ),
                      Icon(Icons.disabled_by_default_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

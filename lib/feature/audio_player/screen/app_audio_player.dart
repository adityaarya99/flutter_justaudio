import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testplayer/constant/app_asset.dart';
import 'package:testplayer/feature/audio_player/model/audio_player_state.dart';
import 'package:testplayer/feature/audio_player/widget/app_bar_audio.dart';
import 'package:testplayer/feature/audio_player/widget/controls_widget.dart';
import 'package:testplayer/feature/audio_player/widget/media_meta_data_widget.dart';

class AppAudioPlayer extends StatefulWidget {
  const AppAudioPlayer({super.key});

  @override
  State<AppAudioPlayer> createState() => _AppAudioPlayerState();
}

class _AppAudioPlayerState extends State<AppAudioPlayer> {
  AudioPlayer _audioPlayer = AudioPlayer();
  var duration;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
            position: position,
            bufferedPosition: bufferedPosition,
            duration: duration ?? Duration.zero),
      );

  final _playlist = ConcatenatingAudioSource(children: [
    AudioSource.asset(
      AppAsset.sampleAudio,
      tag: const MediaItem(
        id: '01',
        album: "Album name",
        artist: 'Sample Artist',
        title: "Sample Audio",
      ),
    ),
    AudioSource.asset(
      AppAsset.congratulationsPM,
      tag: const MediaItem(
        id: '02',
        album: "Album name",
        artist: 'Post Malone',
        title: "Congratulations",
      ),
    ),
    AudioSource.asset(
      AppAsset.goFlexPM,
      tag: const MediaItem(
        id: '03',
        album: "Album name",
        artist: 'Post Malone',
        title: "Go Flex",
      ),
    ),
    AudioSource.asset(
      AppAsset.raftaRafta,
      tag: const MediaItem(
        id: '04',
        album: "Album name",
        artist: 'Mehndi Hasan',
        title: "Rafta Rafta",
      ),
    ),
  ]);

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(_playlist);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF14a6f0),
              Color(0xFFece522),
              Color(0xFFab38a0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),

            ///APP BAR
            const AppBarAudio(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ///MEDIA META DATA
                  StreamBuilder<SequenceState?>(
                      stream: _audioPlayer.sequenceStateStream,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        if (state?.sequence.isEmpty ?? true) {
                          return const Text('Stream is Empty');
                        }
                        final metadata = state!.currentSource!.tag as MediaItem;
                        return MediaMetaDataWidget(
                          title: metadata.title,
                          artist: metadata.artist,
                          imageUrl: metadata.artUri.toString(),
                        );
                      }),

                  ///PROGRESS BAR
                  StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final durationState = snapshot.data;
                      // if (duration != null) {
                      return ProgressBar(
                        barHeight: 8,
                        baseBarColor: Colors.grey[600],
                        bufferedBarColor: Colors.grey,
                        progressBarColor: Colors.red,
                        thumbColor: Colors.red,
                        timeLabelTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        progress: durationState?.position ?? Duration.zero,
                        buffered:
                            durationState?.bufferedPosition ?? Duration.zero,
                        total: durationState?.duration ?? Duration.zero,
                        onSeek: _audioPlayer.seek,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ControlWidget(
                    audioPlayer: _audioPlayer,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

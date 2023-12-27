import 'package:just_audio/just_audio.dart';

abstract class AudioPlayerState{}

class InitialAudioPlayer extends AudioPlayerState{}

class DisposeAudioPlayer extends AudioPlayerState{
  AudioPlayer audioPlayer;
  DisposeAudioPlayer({required this.audioPlayer});
}


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testplayer/feature/audio_player/cubit/audio_player_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  AudioPlayerCubit() : super(InitialAudioPlayer());


  resetState(){
    emit(InitialAudioPlayer());
  }

  disposeAudioPlayer(AudioPlayer audioPlayer) {
    emit(DisposeAudioPlayer(audioPlayer: audioPlayer));
  }
}

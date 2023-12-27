import 'dart:io';

import 'package:testplayer/common/model/custom_file_model.dart';

abstract class HomeState {}

class InitialHomeState extends HomeState {}

class FetchAudioLoadingState extends HomeState {}

class FetchVideoLoadingState extends HomeState {}

class FetchAudioSuccessState extends HomeState {
  List<String> audioFiles;
  FetchAudioSuccessState({required this.audioFiles});
}

class FetchVideoSuccessState extends HomeState {
  List<String> videoFiles;
  FetchVideoSuccessState({required this.videoFiles});
}

class StoragePermissionSuccess extends HomeState {}

class AudioPermissionSuccess extends HomeState {}

class VideoPermissionSuccess extends HomeState {}

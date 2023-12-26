import 'dart:io';

abstract class HomeState{}

class InitialHomeState extends HomeState{}

class FetchAudioLoadingState extends HomeState{}

class FetchAudioSuccessState extends HomeState{
  List<FileSystemEntity> audioFiles;
  FetchAudioSuccessState({required this.audioFiles});
}

class FetchVideoSuccessState extends HomeState{
  List<FileSystemEntity> videoFiles;
  FetchVideoSuccessState({required this.videoFiles});
}


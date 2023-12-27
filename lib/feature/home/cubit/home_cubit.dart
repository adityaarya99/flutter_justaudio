import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testplayer/feature/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitialHomeState());

  Directory? externalDir = Directory('/storage/emulated/0');
  int androidVersion = 1;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<void> checkAndroidVersion() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    androidVersion = int.tryParse(androidInfo.version.release ?? '1')!;
    if (androidVersion <= 12) {
      _checkPermissionAndFetchFiles();
    } else {
      requestPermissionAudio();
    }
  }

  Future<void> _checkPermissionAndFetchFiles() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      _fetchAudioFiles();
      _fetchVideoFiles();
    } else {
      status = await Permission.storage.request();
      if (status.isGranted) {
        _fetchAudioFiles();
        _fetchVideoFiles();
      } else {
        await Permission.storage.request();
      }
    }
  }

  Future<void> requestPermissionAudio() async {
    emit(FetchAudioLoadingState());
    var status = await Permission.audio.status;
    if (status.isGranted) {
      print('Audio Permission Granted');
      List<SongModel> audios = await _audioQuery.querySongs();
      if (audios.length > 80) {
        audios.removeRange(80, audios.length);
      }
      List<String> filePaths = [];
      for (int i = 0; i < audios.length; i++) {
        filePaths.add(audios[i].data);
      }
      emit(FetchAudioSuccessState(audioFiles: filePaths));
      requestPermissionVideo();
    } else {
      status = await Permission.audio.request();
      if (status.isGranted) {
        List<SongModel> audios = await _audioQuery.querySongs();
        if (audios.length > 80) {
          audios.removeRange(80, audios.length);
        }
        List<String> filePaths = [];
        for (int i = 0; i < audios.length; i++) {
          filePaths.add(audios[i].data);
        }
        emit(FetchAudioSuccessState(audioFiles: filePaths));
        requestPermissionVideo();
      } else {
        await Permission.audio.request();
      }
    }
  }

  Future<void> requestPermissionVideo() async {
    emit(FetchAudioLoadingState());
    var status = await Permission.videos.status;
    if (status.isGranted) {
      List<FileSystemEntity> files = await _listMp4Files(externalDir!);
      List<String> filePaths = [];
      for (int i = 0; i < files.length; i++) {
        filePaths.add(files[i].path);
      }
      emit(FetchVideoSuccessState(videoFiles: filePaths));
    } else {
      status = await Permission.videos.request();
      if (status.isGranted) {
        emit(FetchAudioLoadingState());
        List<FileSystemEntity> files =await _listMp4Files(externalDir!);
        List<String> filePaths = [];
        for (int i = 0; i < files.length; i++) {
          filePaths.add(files[i].path);
        }
        emit(FetchVideoSuccessState(videoFiles: filePaths));
        print('Video Permission Granted');
      } else {
        await Permission.videos.request();
      }
    }
  }

  Future<void> _fetchAudioFiles() async {
    try {
      emit(FetchAudioLoadingState());
      List<FileSystemEntity> files = await _listMp3Files(externalDir!);
      if (files.length > 80) {
        files.removeRange(80, files.length);
      }
      List<String>? customFileModel = [];
      for (int i = 0; i < files.length; i++) {
        customFileModel.add(files[i].path);
      }
      emit(FetchAudioSuccessState(audioFiles: customFileModel));
    } catch (e) {
      print('Error fetching audio files: $e');
    }
  }

  Future<void> _fetchVideoFiles() async {
    try {
        List<FileSystemEntity> files = await _listMp4Files(externalDir!);
        List<String>? customFileModel = [];
        for (int i = 0; i < files.length; i++) {
          customFileModel.add(files[i].path);
        }
        emit(FetchVideoSuccessState(videoFiles: customFileModel));
    } catch (e) {
      print('Error fetching audio files: $e');
    }
  }

  Future<List<FileSystemEntity>> _listMp3Files(Directory dir) async {
    List<FileSystemEntity> mp3Files = [];

    try {
      List<FileSystemEntity> files = dir.listSync();
      if (files.length > 80) {
        files.removeRange(80, files.length);
      }
      for (FileSystemEntity file in files) {
        if (file is File && file.path.toLowerCase().endsWith('.mp3')) {
          mp3Files.add(file);
        } else if (file is Directory) {
          mp3Files.addAll(await _listMp3Files(file));
        }
      }
    } catch (e) {
      log('Error listing MP3 files: $e');
    }

    return mp3Files;
  }

  Future<List<FileSystemEntity>> _listMp4Files(Directory dir) async {
    List<FileSystemEntity> mp4Files = [];

    try {
      if (dir.existsSync()) {
        List<FileSystemEntity> files = dir.listSync(recursive: false,);
        if(files.length > 10){
          files.removeRange(10, files.length);
        }
        for (FileSystemEntity file in files) {
          if (file is File && file.path.toLowerCase().endsWith('.mp4')) {
            mp4Files.add(file);
          } else if (file is Directory) {
            mp4Files.addAll(await _listMp4Files(file));
          }
        }
      }
    } catch (e) {
      print('Error listing MP4 files: $e');
    }

    return mp4Files;
  }


}

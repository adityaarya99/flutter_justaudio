import 'dart:developer';
import 'dart:io';

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

  Future<void> checkAndroidVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
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
        List<FileSystemEntity> files = await _listMp4Files(externalDir!);
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
      // List all MP3 files in the directory and its subdirectories
      List<FileSystemEntity> files = await _listMp3Files(externalDir!);
      // List<FileSystemEntity> audioFiles = files.map((file) => file).toList();
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
      // Get external storage directory
      if (externalDir != null) {
        // List all MP4 files in the directory and its subdirectories
        List<FileSystemEntity> files = await _listMp4Files(externalDir!);
        // List<FileSystemEntity> videoFiles = files.map((file) => file).toList();
        List<String>? customFileModel = [];
        for (int i = 0; i < files.length; i++) {
          customFileModel.add(files[i].path);
        }
        emit(FetchVideoSuccessState(videoFiles: customFileModel));
      }
    } catch (e) {
      print('Error fetching audio files: $e');
    }
  }

  Future<List<FileSystemEntity>> _listMp3Files(Directory dir) async {
    List<FileSystemEntity> mp3Files = [];

    try {
      // List all files in the directory
      List<FileSystemEntity> files = dir.listSync();

      for (FileSystemEntity file in files) {
        if (file is File && file.path.toLowerCase().endsWith('.mp3')) {
          // Add MP3 file to the list
          mp3Files.add(file);
        } else if (file is Directory) {
          // Recursively search for MP3 files in subdirectories
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
      // List all files in the directory
      List<FileSystemEntity> files = dir.listSync();

      for (FileSystemEntity file in files) {
        if (file is File && file.path.toLowerCase().endsWith('.mp4')) {
          // Add MP4 file to the list
          mp4Files.add(file);
        } else if (file is Directory) {
          // Recursively search for MP4 files in subdirectories
          mp4Files.addAll(await _listMp4Files(file));
        }
      }
    } catch (e) {
      log('Error listing MP4 files: $e');
    }

    return mp4Files;
  }
}

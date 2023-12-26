import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testplayer/feature/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitialHomeState());

  Directory? externalDir = Directory('/storage/emulated/0');

  Future<void> checkPermissionAndFetchAudioFiles() async {
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

  Future<void> _fetchAudioFiles() async {
    try {
      // Get external storage directory
      if (externalDir != null) {
        // List all MP3 files in the directory and its subdirectories
        List<FileSystemEntity> files = await _listMp3Files(externalDir!);
        List<FileSystemEntity> audioFiles = files.map((file) => file).toList();
        emit(FetchAudioSuccessState(audioFiles: audioFiles));
      }
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
        List<FileSystemEntity> videoFiles = files.map((file) => file).toList();
        emit(FetchVideoSuccessState(videoFiles: videoFiles));
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
          // Recursively search for MP3 files in subdirectories
          mp4Files.addAll(await _listMp4Files(file));
        }
      }
    } catch (e) {
      log('Error listing MP4 files: $e');
    }

    return mp4Files;
  }
}

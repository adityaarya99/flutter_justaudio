import 'package:flutter/material.dart';
import 'package:testplayer/constant/app_asset.dart';

class MediaMetaDataWidget extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? artist;
  const MediaMetaDataWidget(
      {super.key, this.title, this.artist, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.height * 0.8,
            child: Image.asset(AppAsset.audioCoverJpeg)),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Text(
          title ?? 'Title',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        // Text(
        //   artist ?? 'Artist',
        //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        // ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:testplayer/constant/app_asset.dart';

class ListTileWidget extends StatelessWidget {
  final int index;
  final String fileName;
  final Function() onTap;
  final bool isAudio;
  const ListTileWidget({
    super.key,
    required this.index,
    required this.fileName,
    required this.onTap,
    required this.isAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              (isAudio) ? AppAsset.musicalNoteIcon : AppAsset.videoIcon,
              width: 32,
              height: 32,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Text(
              fileName.split('/').last,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            )),
            const SizedBox(
              width: 8,
            ),
            Image.asset(
              AppAsset.playIcon,
              width: 32,
              height: 32,
            )
          ],
        ),
      ),
    );
  }
}

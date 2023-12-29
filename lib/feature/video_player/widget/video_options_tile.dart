import 'package:flutter/material.dart';
import 'package:testplayer/constant/app_asset.dart';

class VideoOptionsTile extends StatelessWidget {
  final Function() onTapMoreVert;
  const VideoOptionsTile({super.key,required this.onTapMoreVert});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: Image.asset(AppAsset.audioCoverJpeg),
            ),
            const SizedBox(
              width: 18,
            ),
            const Text(
              'Eddi Win',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Card(
              elevation: 2,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                  child: Text(
                    'Subscribe',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            )
          ],
        ),
        Row(
          children: [
            Text(
              '5.6K',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(
              width: 8,
            ),
            IconButton(
                onPressed: onTapMoreVert,
                icon: Icon(Icons.more_vert, color: Colors.grey[400]))
          ],
        )
      ],
    );
  }
}

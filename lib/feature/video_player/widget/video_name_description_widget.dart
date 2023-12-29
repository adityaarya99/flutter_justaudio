import 'package:flutter/material.dart';
import 'package:testplayer/constant/app_colors.dart';

class VideoNameDescriptionWidget extends StatelessWidget {
  final String fileName;
  const VideoNameDescriptionWidget({super.key, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fileName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.colorWhiteFb,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          '27,795 views',
          style: TextStyle(
            color: AppColors.colorSilver,
          ),
        ),
      ],
    );
  }
}

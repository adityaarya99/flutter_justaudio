import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:testplayer/constant/app_asset.dart';
import 'package:testplayer/constant/app_colors.dart';

class LikeDislikeButton extends StatelessWidget {
  final String? likes;
  final Function() onTaplike;
  final Function() onTapDislike;
  final bool? liked;
  final bool? disLiked;

  const LikeDislikeButton({
    super.key,
    required this.onTaplike,
    required this.onTapDislike,
    this.likes,
    this.liked,
    this.disLiked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.colorMidnightGray,
          borderRadius: BorderRadius.all(Radius.circular(24.0))),
      child: Row(
        children: [
          IconButton(
            onPressed: onTaplike,
            icon: (liked ?? false)
                ? Icon(
                    Icons.thumb_up_sharp,
                    color: AppColors.colorWhiteFb,
                  )
                : Icon(
                    Icons.thumb_up_off_alt_outlined,
                    color: AppColors.colorWhiteFb,
                  ),
          ),
          if (likes != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  likes ?? '',
                  style: const TextStyle(
                    color: AppColors.colorWhiteFb,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          SizedBox(
            width: 8,
          ),
          Text(
            '|',
            style: TextStyle(
              color: AppColors.colorWhiteFb,
            ),
          ),
          IconButton(
            onPressed: onTapDislike,
            icon: (disLiked ?? false)
                ? Icon(
                    Icons.thumb_down_sharp,
                    color: AppColors.colorWhiteFb,
                  )
                : Icon(
                    Icons.thumb_down_off_alt_outlined,
                    color: AppColors.colorWhiteFb,
                  ),
          ),
        ],
      ),
    );
  }
}

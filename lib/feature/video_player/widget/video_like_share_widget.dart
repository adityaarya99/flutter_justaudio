import 'package:flutter/material.dart';
import 'package:testplayer/common/widgets/like_dislike_button.dart';
import 'package:testplayer/common/widgets/share_button.dart';

class VideoLikeShareWidget extends StatelessWidget {
  final Function() onTaplike;
  final Function() onTapDislike;
  final Function() onTapShare;
  final String? likes;
  final bool? liked;
  final bool? diLiked;
  const VideoLikeShareWidget({
    super.key,
    required this.onTaplike,
    required this.onTapDislike,
    required this.onTapShare,
    this.likes,
    this.liked,
    this.diLiked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        LikeDislikeButton(
          onTaplike: onTaplike,
          onTapDislike: onTapDislike,
          likes: likes,
          liked: liked,
          disLiked: diLiked,
        ),
        const SizedBox(
          width: 18,
        ),
        ShareButton(onTapShare: onTapShare),
      ],
    );
  }
}

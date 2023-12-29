import 'package:flutter/material.dart';
import 'package:testplayer/constant/app_colors.dart';

class ShareButton extends StatelessWidget {
  final Function() onTapShare;
  const ShareButton({
    super.key,
    required this.onTapShare,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          AppColors.colorMidnightGray,
        ),
      ),
      onPressed: onTapShare,
      icon: Icon(
        Icons.share,
        color: AppColors.colorWhiteFb,
      ),
      label: Text(
        'Share',
        style: TextStyle(
          color: AppColors.colorWhiteFb,
        ),
      ),
    );
  }
}

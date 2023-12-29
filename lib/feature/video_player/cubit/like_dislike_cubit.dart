import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testplayer/feature/video_player/cubit/like_dislike_state.dart';

class LikeCubit extends Cubit<LikeState> {
  LikeCubit() : super(LikeInitialState());

  void resetState() {
    emit(LikeInitialState());
  }

  void likeVideo() {
    emit(LikeSuccessState());
  }

  void disLikeVideo() {
    emit(DislikeSuccessState());
  }
}

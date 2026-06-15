import 'package:social_app_fe/features/community/data/models/community_model.dart';

abstract class CommunityCreateState {
  CommunityCreateState();
}

class CommunityCreateInitial extends CommunityCreateState {
  CommunityCreateInitial();
}

class CommunityCreateLoading extends CommunityCreateState {
  CommunityCreateLoading();
}

class CommunityCreateSuccess extends CommunityCreateState {
  final CommunityModel community;
  final String message;

  CommunityCreateSuccess({
    required this.community,
    this.message = 'Tạo cộng đồng thành công',
  });
}

class CommunityCreateError extends CommunityCreateState {
  final String message;

  CommunityCreateError(this.message);
}

import 'package:social_app_fe/features/community/data/models/community_model.dart';

abstract class CommunityCreateState {
  const CommunityCreateState();
}

class CommunityCreateInitial extends CommunityCreateState {
  const CommunityCreateInitial();
}

class CommunityCreateLoading extends CommunityCreateState {
  const CommunityCreateLoading();
}

class CommunityCreateSuccess extends CommunityCreateState {
  final CommunityModel community;
  final String message;

  const CommunityCreateSuccess({
    required this.community,
    this.message = 'Tạo cộng đồng thành công',
  });
}

class CommunityCreateError extends CommunityCreateState {
  final String message;

  const CommunityCreateError(this.message);
}

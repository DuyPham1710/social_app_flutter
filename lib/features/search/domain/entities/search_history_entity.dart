import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

abstract class SearchHistoryEntity {
  String get id;
  String? get query;
  int? get resultCount;
  UserEntity? get viewedUser;
}



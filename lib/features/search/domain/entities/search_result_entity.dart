import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

abstract class SearchResultEntity {
  List<UserEntity> get userResponseDtos;
  PaginationEntity get pagination;
}

abstract class PaginationEntity {
  int get currentPage;
  int get totalPages;
  int get totalItems;
  int get itemsPerPage;
  bool get hasNextPage;
  bool get hasPrevPage;
}


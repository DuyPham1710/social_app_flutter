import '../../domain/entities/paginated_response_entity.dart';

class PaginatedResponseModel {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginatedResponseModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PaginatedResponseModel.fromJson(Map<String, dynamic> json) {
    return PaginatedResponseModel(
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      totalItems: json['totalItems'] as int,
      itemsPerPage: json['itemsPerPage'] as int,
      hasNextPage: json['hasNextPage'] as bool,
      hasPrevPage: json['hasPrevPage'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'currentPage': currentPage,
    'totalPages': totalPages,
    'totalItems': totalItems,
    'itemsPerPage': itemsPerPage,
    'hasNextPage': hasNextPage,
    'hasPrevPage': hasPrevPage,
  };

  PaginatedResponseEntity toEntity() => PaginatedResponseEntity(
    currentPage: currentPage,
    totalPages: totalPages,
    totalItems: totalItems,
    itemsPerPage: itemsPerPage,
    hasNextPage: hasNextPage,
    hasPrevPage: hasPrevPage,
  );
}
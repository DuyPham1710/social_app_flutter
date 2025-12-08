import 'dart:io';
import 'package:equatable/equatable.dart';

class UpdateUserEntity extends Equatable {
  final String? fullName;
  final String? bio;
  final String? school;
  final String? currentCity;
  final String? hometown;
  final String? workplace;
  final String? relationshipStatus;
  final File? avatarFile; // File ảnh đại diện mới (nếu có)
  final File? coverFile; // File ảnh bìa mới (nếu có)

  const UpdateUserEntity({
    this.fullName,
    this.bio,
    this.school,
    this.currentCity,
    this.hometown,
    this.workplace,
    this.relationshipStatus,
    this.avatarFile,
    this.coverFile,
  });

  // Utility copyWith method
  UpdateUserEntity copyWith({
    String? fullName,
    String? bio,
    String? school,
    String? currentCity,
    String? hometown,
    String? workplace,
    String? relationshipStatus,
    File? avatarFile,
    File? coverFile,
  }) {
    return UpdateUserEntity(
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      school: school ?? this.school,
      currentCity: currentCity ?? this.currentCity,
      hometown: hometown ?? this.hometown,
      workplace: workplace ?? this.workplace,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      avatarFile: avatarFile ?? this.avatarFile,
      coverFile: coverFile ?? this.coverFile,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    bio,
    school,
    currentCity,
    hometown,
    workplace,
    relationshipStatus,
    avatarFile,
    coverFile,
  ];
}

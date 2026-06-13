import 'dart:io';
import 'dart:typed_data';
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
  final Uint8List? avatarBytes;
  final String? avatarName;
  final Uint8List? coverBytes;
  final String? coverName;

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
    this.avatarBytes,
    this.avatarName,
    this.coverBytes,
    this.coverName,
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
    Uint8List? avatarBytes,
    String? avatarName,
    Uint8List? coverBytes,
    String? coverName,
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
      avatarBytes: avatarBytes ?? this.avatarBytes,
      avatarName: avatarName ?? this.avatarName,
      coverBytes: coverBytes ?? this.coverBytes,
      coverName: coverName ?? this.coverName,
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
    avatarBytes,
    avatarName,
    coverBytes,
    coverName,
  ];
}

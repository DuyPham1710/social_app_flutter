class UserEntity {
  final String userId;
  final String? fullName;
  final String? phoneNumber;
  final String? bio;
  final String? avatarUrl;
  final String? dateOfBirth;
  final String? gender;
  final String? email;
  final String? username;
  final bool? isActive;
  final DateTime? createdAt;
  final String? coverUrl;
  final String? school;
  final String? currentCity;
  final String? hometown;
  final String? workplace;
  final String? relationshipStatus;

  const UserEntity({
    required this.userId,
    this.fullName,
    this.phoneNumber,
    this.bio,
    this.avatarUrl,
    this.dateOfBirth,
    this.gender,
    this.email,
    this.username,
    this.isActive,
    this.createdAt,
    this.coverUrl,
    this.currentCity,
    this.school,
    this.hometown,
    this.relationshipStatus,
    this.workplace
  });
}

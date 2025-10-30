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
  });
}

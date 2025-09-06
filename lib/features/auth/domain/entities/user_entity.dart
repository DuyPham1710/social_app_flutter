abstract class UserEntity {
  final String userId;
  final String fullName;
  final String phoneNumber;
  final String bio;
  final String avatarUrl;
  final String dateOfBirth;
  final String gender;
  final String email;
  final String username;
  final bool isActive;
  final DateTime? createdAt;

  const UserEntity({
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.bio,
    required this.avatarUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.email,
    required this.username,
    required this.isActive,
    this.createdAt,
  });
}

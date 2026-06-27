// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      userId: ((json['_id'] ?? json['userId'])?.toString() ?? '') as String,
      fullName: json['fullName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      coverUrl: json['coverUrl'] as String?,
      school: json['school'] as String?,
      currentCity: json['currentCity'] as String?,
      hometown: json['hometown'] as String?,
      workplace: json['workplace'] as String?,
      relationshipStatus: json['relationshipStatus'] as String?,
      isFaceRegistered: json['isFaceRegistered'] as bool?,
      isBan: json['isBan'] as bool?,
      banUntil: json['banUntil'] == null
          ? null
          : DateTime.parse(json['banUntil'] as String),
      banReason: json['banReason'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(
  _$UserModelImpl instance,
) => <String, dynamic>{
  '_id': instance.userId,
  if (instance.fullName case final value?) 'fullName': value,
  if (instance.phoneNumber case final value?) 'phoneNumber': value,
  if (instance.bio case final value?) 'bio': value,
  if (instance.avatarUrl case final value?) 'avatarUrl': value,
  if (instance.dateOfBirth case final value?) 'dateOfBirth': value,
  if (instance.gender case final value?) 'gender': value,
  if (instance.email case final value?) 'email': value,
  if (instance.username case final value?) 'username': value,
  if (instance.isActive case final value?) 'isActive': value,
  if (instance.createdAt?.toIso8601String() case final value?)
    'createdAt': value,
  if (instance.coverUrl case final value?) 'coverUrl': value,
  if (instance.school case final value?) 'school': value,
  if (instance.currentCity case final value?) 'currentCity': value,
  if (instance.hometown case final value?) 'hometown': value,
  if (instance.workplace case final value?) 'workplace': value,
  if (instance.relationshipStatus case final value?)
    'relationshipStatus': value,
  if (instance.isFaceRegistered case final value?) 'isFaceRegistered': value,
  if (instance.isBan case final value?) 'isBan': value,
  if (instance.banUntil?.toIso8601String() case final value?) 'banUntil': value,
  if (instance.banReason case final value?) 'banReason': value,
};

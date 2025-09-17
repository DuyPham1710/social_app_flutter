// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      userId: json['userId'] as String,
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
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
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
    };

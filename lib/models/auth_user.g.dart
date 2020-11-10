// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) {
  return AuthUser(
    json['uid'] as String,
    json['displayName'] as String,
    json['photoUrl'] as String,
    json['email'] as String,
    json['isAnonymous'] as bool,
    json['isEmailVerified'] as bool,
    json['idToken'] as String,
    json['refreshToken'] as String,
  );
}

Map<String, dynamic> _$AuthUserToJson(AuthUser instance) => <String, dynamic>{
      'uid': instance.uid,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'email': instance.email,
      'isAnonymous': instance.isAnonymous,
      'isEmailVerified': instance.isEmailVerified,
      'idToken': instance.idToken,
      'refreshToken': instance.refreshToken,
    };

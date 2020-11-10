import 'package:dilexus/imports.dart';

part 'auth_user.g.dart';

@JsonSerializable()
class AuthUser {
  String uid;
  String displayName;
  String photoUrl;
  String email;
  bool isAnonymous;
  bool isEmailVerified;
  String idToken;
  String refreshToken;

  AuthUser(this.uid, this.displayName, this.photoUrl, this.email, this.isAnonymous,
      this.isEmailVerified, this.idToken, this.refreshToken);

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);
  Map<String, dynamic> toJson() => _$AuthUserToJson(this);
}

// class AuthUserDesSer extends JsonDesSer<AuthUser> {
//   @override
//   String get key => "AUTH_USER";
//
//   @override
//   AuthUser fromMap(Map<String, dynamic> map) => _$AuthUserFromJson(map);
//
//   @override
//   Map<String, dynamic> toMap(AuthUser authUser) => _$AuthUserToJson(authUser);
// }

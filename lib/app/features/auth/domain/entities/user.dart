import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String photoUrl;
  final String accessToken;
  final String refreshToken;

  const User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.photoUrl,
    required this.accessToken,
    required this.refreshToken,
  });

  User copyWith({
    int? id,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? photoUrl,
    String? accessToken,
    String? refreshToken,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        firstName,
        lastName,
        email,
        photoUrl,
        accessToken,
        refreshToken,
      ];
}

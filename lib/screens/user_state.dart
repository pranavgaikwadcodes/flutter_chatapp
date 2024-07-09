import 'package:equatable/equatable.dart';
import 'package:flutter_chat_application/models/user.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UsersLoaded extends UserState {
  final List<User> users;

  UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserLoggedIn extends UserState {
  final User user;

  UserLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}

class UserLoginFailed extends UserState {}

class UserLoggedOut extends UserState {}

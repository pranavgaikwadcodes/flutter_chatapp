import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUsers extends UserEvent {}

class SignUpUser extends UserEvent {
  final String username;
  final String password;

  SignUpUser(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}

class LogInUser extends UserEvent {
  final String username;
  final String password;

  LogInUser(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}

class LogOutUser extends UserEvent {}

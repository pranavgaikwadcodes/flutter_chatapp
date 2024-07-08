import 'package:equatable/equatable.dart';
import 'package:flutter_chat_application/models/session.dart';

// Session States
abstract class SessionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {}

class SessionsLoaded extends SessionState {
  final List<Session> sessions;

  SessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}
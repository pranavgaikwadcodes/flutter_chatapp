import 'package:equatable/equatable.dart';

// Session Events
abstract class SessionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSessions extends SessionEvent {}

class CreateSession extends SessionEvent {}

class DeleteSession extends SessionEvent {
  final int index;

  DeleteSession(this.index);

  @override
  List<Object?> get props => [index];
}
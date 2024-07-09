import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_application/models/session.dart';
import 'package:flutter_chat_application/screens/session_event.dart';
import 'package:flutter_chat_application/screens/session_state.dart';
import 'package:hive/hive.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final Box<Session> sessionBox;

  SessionBloc(this.sessionBox) : super(SessionInitial()) {
    on<LoadSessions>(_onLoadSessions);
    on<CreateSession>(_onCreateSession);
    on<DeleteSession>(_onDeleteSession);
  }

  void _onLoadSessions(LoadSessions event, Emitter<SessionState> emit) {
    final sessions = sessionBox.values.toList();
    emit(SessionsLoaded(sessions));
  }

  void _onCreateSession(CreateSession event, Emitter<SessionState> emit) {
    final sessionCount = sessionBox.length + 1;
    final newSession = Session(id: UniqueKey().toString(), name: 'Session $sessionCount');
    sessionBox.add(newSession);
    final sessions = sessionBox.values.toList();
    emit(SessionsLoaded(sessions));
  }

  void _onDeleteSession(DeleteSession event, Emitter<SessionState> emit) {
    sessionBox.deleteAt(event.index);
    final sessions = sessionBox.values.toList();
    emit(SessionsLoaded(sessions));
  }
}
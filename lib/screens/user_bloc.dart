import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:flutter_chat_application/models/user.dart';
import 'package:flutter_chat_application/screens/user_event.dart';
import 'package:flutter_chat_application/screens/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Box<User> userBox;

  UserBloc(this.userBox) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<SignUpUser>(_onSignUpUser);
    on<LogInUser>(_onLogInUser);
    on<LogOutUser>(_onLogOutUser);
  }

  void _onLoadUsers(LoadUsers event, Emitter<UserState> emit) {
    final users = userBox.values.toList();
    emit(UsersLoaded(users));
  }

  void _onSignUpUser(SignUpUser event, Emitter<UserState> emit) {
    final newUser = User(username: event.username, password: event.password);
    userBox.add(newUser);
    final users = userBox.values.toList();
    emit(UsersLoaded(users));
  }

  void _onLogInUser(LogInUser event, Emitter<UserState> emit) {
    final user = userBox.values.firstWhere(
      (user) => user.username == event.username && user.password == event.password,
      orElse: () => User(username: '', password: ''), // dummy user
    );

    if (user.username.isNotEmpty) {
      emit(UserLoggedIn(user));
    } else {
      emit(UserLoginFailed());
    }
  }

  void _onLogOutUser(LogOutUser event, Emitter<UserState> emit) {
    emit(UserLoggedOut());
  }
}

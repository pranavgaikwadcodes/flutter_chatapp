import 'package:flutter/material.dart';
import 'package:flutter_chat_application/models/session.dart';
import 'package:flutter_chat_application/models/user.dart';
import 'package:flutter_chat_application/screens/chat_screen.dart';
import 'package:flutter_chat_application/screens/home_screen.dart';
import 'package:flutter_chat_application/screens/login_screen.dart';
import 'package:flutter_chat_application/screens/session_list_screen.dart';
import 'package:flutter_chat_application/screens/signup_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SessionAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<Session>('sessions');
  await Hive.openBox<User>('users');
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/sessions': (context) => SessionListScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
          final args = settings.arguments as Session;
          return MaterialPageRoute(
            builder: (context) {
              return ChatScreen(session: args);
            },
          );
        }
        return null;
      },
    );
  }
}

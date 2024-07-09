import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_application/models/session.dart';
import 'package:flutter_chat_application/models/user.dart';
import 'package:flutter_chat_application/screens/chat_screen.dart';
import 'package:flutter_chat_application/screens/home_screen.dart';
import 'package:flutter_chat_application/screens/login_screen.dart';
import 'package:flutter_chat_application/screens/session_event.dart';
import 'package:flutter_chat_application/screens/session_list_screen.dart';
import 'package:flutter_chat_application/screens/signup_screen.dart';
import 'package:flutter_chat_application/screens/session_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SessionBloc(Hive.box<Session>('sessions'))..add(LoadSessions()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Chat App',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
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
            final session = settings.arguments as Session;
            return MaterialPageRoute(
              builder: (context) => ChatScreen(session: session),
            );
          }
          return null;
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_chat_application/screens/home_screen.dart';
// import 'package:flutter_chat_application/screens/login_screen.dart';
// import 'package:flutter_chat_application/screens/signup_screen.dart';
// import 'package:flutter_chat_application/screens/sessions_screen.dart';
// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_chat_application/models/user.dart';
// import 'package:flutter_chat_application/bloc/login_bloc.dart';
// import 'package:flutter_chat_application/bloc/signup_bloc.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
//   Hive.init(appDocumentDirectory.path);
//   Hive.registerAdapter(UserAdapter());
//   await Hive.openBox<User>('users');

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Chat App',
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => HomeScreen(),
//         '/login': (context) => LoginScreen(),
//         '/signup': (context) => SignupScreen(),
//         '/sessions': (context) => SessionListScreen(),
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_chat_application/models/session.dart';
import 'package:flutter_chat_application/screens/chat_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SessionListScreen extends StatefulWidget {
  @override
  _SessionListScreenState createState() => _SessionListScreenState();
}

class _SessionListScreenState extends State<SessionListScreen> {
  late Box<Session> sessionBox;

  @override
  void initState() {
    super.initState();
    sessionBox = Hive.box<Session>('sessions');
  }

  void _createNewSession() {
    final sessionNumber = sessionBox.length + 1;
    final newSession = Session(id: UniqueKey().toString(), name: 'Session $sessionNumber');
    sessionBox.add(newSession).then((_) {
      _openChat(newSession);
    });
  }

  void _openChat(Session session) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(session: session),
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sessions'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: sessionBox.listenable(),
        builder: (context, Box<Session> box, _) {
          if (box.values.isEmpty) {
            return Center(child: Text('No sessions available'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final session = box.getAt(index);
              return ListTile(
                title: Text(session!.name),
                onTap: () => _openChat(session),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewSession,
        child: Icon(Icons.add),
      ),
    );
  }
}

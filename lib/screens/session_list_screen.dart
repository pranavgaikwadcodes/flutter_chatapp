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
        title: Text(
          'Sessions',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            color: Colors.white,
          ),
        ],
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ValueListenableBuilder(
        valueListenable: sessionBox.listenable(),
        builder: (context, Box<Session> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text(
                'No sessions available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final session = box.getAt(index);
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    session!.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(Icons.chat, color: Colors.deepPurple),
                  onTap: () => _openChat(session),
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: _createNewSession,
              icon: Icon(Icons.add),
              label: Text('Start New Conversation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

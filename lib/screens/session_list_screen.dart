import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_application/models/session.dart';
import 'package:flutter_chat_application/screens/chat_screen.dart';
import 'package:flutter_chat_application/screens/session_bloc.dart';
import 'package:flutter_chat_application/screens/session_event.dart';
import 'package:flutter_chat_application/screens/session_state.dart';

class SessionListScreen extends StatelessWidget {
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
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            color: Colors.white,
          ),
        ],
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          if (state is SessionsLoaded) {
            if (state.sessions.isEmpty) {
              return Center(
                child: Text(
                  'No sessions available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: state.sessions.length,
              itemBuilder: (context, index) {
                final session = state.sessions[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      session.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => context.read<SessionBloc>().add(DeleteSession(index)),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.chat),
                          onPressed: () => Navigator.pushNamed(context, '/chat', arguments: session),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.pushNamed(context, '/chat', arguments: session),
                  ),
                );
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () => context.read<SessionBloc>().add(CreateSession()),
              icon: Icon(Icons.add),
              label: Text(
                'Start New Conversation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
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

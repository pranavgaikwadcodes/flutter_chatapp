import 'package:flutter/material.dart';
import 'package:flutter_chat_application/models/session.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final Session session;

  ChatScreen({required this.session});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late WebSocketChannel channel;
  final TextEditingController _controller = TextEditingController();
  late Session _session;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
    channel = WebSocketChannel.connect(
      Uri.parse('wss://echo.websocket.org'),
    );
    receiveMessage((message) {
      setState(() {
        final timestamp = DateFormat('hh:mm a').format(DateTime.now());
        _session.messages.add('Server: $message [$timestamp]');
        _session.save();
      });
    });
  }

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  void receiveMessage(Function(String) onMessageReceived) {
    channel.stream.listen((message) {
      onMessageReceived(message);
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        final timestamp = DateFormat('hh:mm a').format(DateTime.now());
        _session.messages.add('User: ${_controller.text} [$timestamp]');
        _session.save();
      });
      sendMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat: ${_session.name}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _session.messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_session.messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final channel = WebSocketChannel.connect(
      Uri.parse('wss://tr.atrehealthtech.com/ws-test/125'));

  List<String> _messageHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebSocket"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messageHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messageHistory[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      var message = _controller.text;
      setState(() {
        _messageHistory.add('You: $message');
      });
      channel.sink.add(message);
      _controller.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    channel.stream.listen((message) {
      setState(() {
        if (message is String) {
          _messageHistory.add('Received: $message');
        } else if (message is List<int>) {
          // Convert ASCII codes to string
          String text = String.fromCharCodes(message);
          _messageHistory.add('Received: $text');
        }
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

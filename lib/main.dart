import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebSocket Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            // ! Listen for new message and display

            StreamBuilder(
  stream: channel.stream,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data is String) {
        //covert  string data
        return Text(snapshot.data);
      } else if (snapshot.data is List<int>) {
        // Convert ASCII codes to string
        String text = String.fromCharCodes(snapshot.data);
        return Text(text);
      } else {
        return Text('Received unsupported data type');
      }
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return CircularProgressIndicator();
    }
  },
)

           
          ],
        ),
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
      
      channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

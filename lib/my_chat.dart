import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';

import "package:flutter/material.dart";
import "package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart";
import "package:provider/provider.dart";

enum Interlocutor { self, device }

class Message {
  final Interlocutor interlocutor;
  final String content;

  Message({@required this.interlocutor, @required this.content});
}

class MessageTile extends StatelessWidget {

  final Key key;
  final Message message;

  MessageTile({this.key, @required this.message}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: (
        message.interlocutor == Interlocutor.device ?
        MainAxisAlignment.start :
        MainAxisAlignment.end
      ),
      children: <Widget>[
        Container(
          child: Text(message.content),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          //width: 200.0,
          decoration: BoxDecoration(
            color: (
              message.interlocutor == Interlocutor.device ?
              Theme.of(context).cardColor :
              Theme.of(context).primaryColor
            ),
            borderRadius: BorderRadius.circular(8.0)
          ),
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        ),
      ],
    );
  }
}

class AltChat extends StatefulWidget {

  final Key key;
  final BluetoothDevice device;

  AltChat({this.key, @required this.device,}): super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<AltChat> {
  BluetoothConnection _connection;
  StreamSubscription<String> _inputSubscription;
  List<Message> messages = List();
  ScrollController listScrollController = ScrollController();

  TextEditingController _myMessageController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();

    // Establish connection to device
    BluetoothConnection.toAddress(widget.device.address).then(
      (BluetoothConnection con) {
        print("Connected to ${widget.device.name}");
        setState(() => _connection = con);

        // React to incoming messages
        _inputSubscription = parseBytes(con.input).listen(
          (String msg) {
            setState(() {
              print(msg);
              messages.add(Message(interlocutor: Interlocutor.device, content: msg));

              Future.delayed(Duration(milliseconds: 333)).then((_) {
                listScrollController.animateTo(
                  listScrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeOut 
                );
              });
            });
          },
          onDone: () => print("Input stream is done!"),
          onError: (error) => print("An error occured on input stream!\n$error"),
        );
      }
    );
  }

  @override
  void dispose() {
    print("disposing Chat widget");
    _myMessageController.dispose();
    messages.clear();
    _inputSubscription?.cancel();
    _connection?.finish()?.whenComplete(() => _connection.dispose());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String deviceName = widget.device.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          (_connection == null ? "Connecting to $deviceName" : deviceName),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: <Widget>[
          Visibility(
            visible: _connection == null,
            child: LinearProgressIndicator(),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return MessageTile(message: messages[index],);
              },
              itemCount: messages.length,
              controller: listScrollController,
            )
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    controller: _myMessageController,
                    decoration: InputDecoration(
                      hintText: "Type in a message",
                      filled: true,
                      fillColor: Theme.of(context).primaryColor,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0)
                        )
                      )
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                child: Icon(Icons.send),
                onPressed: () {
                  _sendMessage(_myMessageController.text);
                }
              )
            ],
          )
        ],
      )
    );
  }

  // TODO: Add a buffer size limit and notify user in case it is exceeded
  // In order to do that, make use of StreamController and push and error 
  // over the stream using addError
  Stream<String> parseBytes(Stream<Uint8List> bytes) async* {
    bool expectLineFeed = false;
    List<String> buffer = List<String>();
    
    await for (Uint8List chunk in bytes) {
      for (var byte in chunk) {
        if (expectLineFeed && byte == 0x0A) {
          expectLineFeed = false;
          String msg = buffer.join('');
          buffer.clear();
          
          yield msg;
        } else if (byte == 0x0D) {  // Carriage return
          // Expect line feed character
          expectLineFeed = true;
        } else {
          buffer.add(ascii.decode([byte]));
        }
      }
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    _myMessageController.clear();

    if (text.length > 0)  {
      try {
        _connection.output.add(utf8.encode(text + "\r\n"));
        await _connection.output.allSent;

        setState(() {
          messages.add(Message(interlocutor: Interlocutor.self, content: text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(listScrollController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeOut);
        });
      }
      catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}

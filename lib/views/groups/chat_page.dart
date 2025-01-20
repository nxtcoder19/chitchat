import 'package:chitchat/services/database.dart';
import 'package:chitchat/views/groups/groupProfile.dart';
import 'package:chitchat/widgets/group/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String? groupId;
  final String? userName;
  final String? groupName;

  ChatPage({this.groupId, this.userName, this.groupName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _chats;
  TextEditingController messageEditingController = TextEditingController();

  Widget _chatMessages() {
    return StreamBuilder(
      stream: _chats,
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index].data();
              return MessageTile(
                message: data["message"],
                sender: data["sender"],
                sentByMe: widget.userName == data["sender"],
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods().sendMessage(widget.groupId!, chatMessageMap);

      setState(() {
        messageEditingController.clear();
      });
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   DatabaseMethods().getChats(widget.groupId!).listen((val) {
  //     setState(() {
  //       _chats = val;
  //     });
  //   });
  // }
  @override
  void initState() {
    super.initState();
    // Assign the stream directly to _chats
    _chats = DatabaseMethods().getGroupChats(widget.groupId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupProfile(
                  groupName: widget.groupName!,
                ),
              ),
            );
          },
          child: Text(
            widget.groupName!,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black, // Change the back button color
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            _chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Colors.grey[700],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Send a message ...",
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

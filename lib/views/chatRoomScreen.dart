import 'package:chitchat/helpers/authenticate.dart';
import 'package:chitchat/helpers/constants.dart';
import 'package:chitchat/helpers/helperfunctions.dart';
import 'package:chitchat/helpers/theme.dart';
import 'package:chitchat/services/auth.dart';
import 'package:chitchat/services/database.dart';
import 'package:chitchat/views/conversationScreen.dart';
import 'package:chitchat/views/groups/profile_page.dart';
import 'package:chitchat/views/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? chatRooms;
  User? _user;
  String _email = '';

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index].data();
              return ChatRoomsTile(
                userName: data['chatRoomId']
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                chatRoomId: data['chatRoomId'],
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getUserInfogetChats();
  }

  Future<void> getUserInfogetChats() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      setState(
        () {
          _email = _user!.email!;
        },
      );
    }

    Constants.myName =
        await HelperFunctions.getUserNameSharedPreference() ?? '';
    chatRooms = DatabaseMethods().getUserChats(Constants.myName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // title: Image.asset(
        //   "assets/images/chitchat.png",
        //   height: 80,
        // ),
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              AuthService().signOut();
              HelperFunctions.deleteUserDataSharedPreference();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          children: <Widget>[
            Icon(Icons.account_circle, size: 150.0, color: Colors.grey[700]),
            SizedBox(height: 15.0),
            Text(
              Constants.myName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 7.0),
            ListTile(
              onTap: () {
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (context) => ProfilePage(
                //       userName: _userName,
                //       email: _email,
                //     ),
                //   ),
                // );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      userName: Constants.myName,
                      email: _email,
                    ),
                  ),
                );
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              onTap: () async {
                await AuthService().signOut();
                HelperFunctions.deleteUserDataSharedPreference();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Search(),
            ),
          );
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({required this.userName, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
              chatRoomId: chatRoomId,
              userName: userName,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: CustomTheme.colorAccent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  userName == ""
                      ? Constants.myName.substring(0, 1)
                      : userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Text(
              userName == "" ? "You" : userName,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:chitchat/services/auth.dart';
import 'package:chitchat/services/database.dart';
import 'package:flutter/material.dart';

class ChatProfile extends StatefulWidget {
  final String userName;

  const ChatProfile({Key? key, required this.userName}) : super(key: key);

  @override
  _ChatProfileState createState() => _ChatProfileState();
}

class _ChatProfileState extends State<ChatProfile> {
  final AuthService authService = AuthService();
  String userEmail = '';

  Future<void> getUserInfo() async {
    final userInfoSnapshot =
        await DatabaseMethods().getUserInfoWithUserName(widget.userName);
    setState(() {
      userEmail = userInfoSnapshot.docs[0]['userEmail'];
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        leading: InkWell(
          child: Icon(Icons.arrow_back),
          onTap: () {
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(
            //     builder: (context) => TabViewController(),
            //   ),
            // );
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150.0,
              color: Colors.grey[700],
            ),
            SizedBox(height: 20.0),
            _buildInfoRow('Full Name', widget.userName),
            Divider(height: 40.0, thickness: 1.0),
            _buildInfoRow('Email', userEmail),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

import 'package:chitchat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupProfile extends StatefulWidget {
  final String groupName;

  const GroupProfile({Key? key, required this.groupName}) : super(key: key);

  @override
  State<GroupProfile> createState() => _GroupProfileState();
}

class _GroupProfileState extends State<GroupProfile> {
  QuerySnapshot<Map<String, dynamic>>? groupResultSnapshot;
  String groupAdmin = '';

  Future<void> getGroupInfo() async {
    await DatabaseMethods()
        .searchByNames(widget.groupName)
        .first // Get the first snapshot from the stream
        .then(
      (snapshot) {
        setState(() {
          groupResultSnapshot = snapshot;
          groupAdmin = groupResultSnapshot!.docs[0]['admin'];
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getGroupInfo();
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
            _buildInfoRow('Group Name', widget.groupName),
            Divider(height: 40.0, thickness: 1.0),
            _buildInfoRow('Group Admin', groupAdmin),
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

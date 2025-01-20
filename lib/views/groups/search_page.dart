import 'package:chitchat/helpers/helperfunctions.dart';
import 'package:chitchat/services/database.dart';
import 'package:chitchat/views/groups/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Data
  final TextEditingController searchEditingController = TextEditingController();
  QuerySnapshot<Map<String, dynamic>>? searchResultSnapshot;
  bool isLoading = false;
  bool hasUserSearched = false;
  bool _isJoined = false;
  String _userName = '';
  User? _user;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // InitState
  @override
  void initState() {
    super.initState();
    _getCurrentUserNameAndUid();
  }

  // Functions
  Future<void> _getCurrentUserNameAndUid() async {
    _userName = await HelperFunctions.getUserNameSharedPreference();
    _user = FirebaseAuth.instance.currentUser;
  }

  // Future<void> _initiateSearch() async {
  //   if (searchEditingController.text.isNotEmpty) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     await DatabaseMethods()
  //         .searchByNames(searchEditingController.text)
  //         .then((snapshot) {
  //       setState(() {
  //         searchResultSnapshot = snapshot;
  //         isLoading = false;
  //         hasUserSearched = true;
  //       });
  //     });
  //   }
  // }

  Future<void> _initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      await DatabaseMethods()
          .searchByNames(searchEditingController.text)
          .first // Get the first snapshot from the stream
          .then(
        (snapshot) {
          setState(() {
            searchResultSnapshot = snapshot;
            isLoading = false;
            hasUserSearched = true;
          });
        },
      );
    }
  }

  void _showScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blueAccent,
        duration: Duration(milliseconds: 1500),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17.0),
        ),
      ),
    );
  }

  Future<void> _joinValueInGroup(
      String userName, String groupId, String groupName, String admin) async {
    bool value = await DatabaseMethods(uid: _user!.uid)
        .isUserJoined(groupId, groupName, userName);
    setState(() {
      _isJoined = value;
    });
  }

  // Widgets
  Widget groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot?.docs.length ?? 0,
            itemBuilder: (context, index) {
              var groupData = searchResultSnapshot!.docs[index].data();
              return groupTile(
                _userName,
                groupData["groupId"],
                groupData["groupName"],
                groupData["admin"],
              );
            },
          )
        : Container();
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    _joinValueInGroup(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      leading: CircleAvatar(
        radius: 30.0,
        backgroundColor: Colors.blueAccent,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Admin: $admin"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseMethods(uid: _user!.uid)
              .togglingGroupJoin(groupId, groupName, userName);
          setState(() {
            _isJoined = !_isJoined;
          });

          if (_isJoined) {
            _showScaffold('Successfully joined the group "$groupName"');
            Future.delayed(Duration(milliseconds: 2000), () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatPage(
                        groupId: groupId,
                        userName: userName,
                        groupName: groupName,
                      )));
            });
          } else {
            _showScaffold('Left the group "$groupName"');
          }
        },
        child: _isJoined
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.black87,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text('Joined', style: TextStyle(color: Colors.white)),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blueAccent,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text('Join', style: TextStyle(color: Colors.white)),
              ),
      ),
    );
  }

  // Building the search page widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        // backgroundColor: Colors.black87,
        title: Text(
          'Search Groups',
          style: TextStyle(
              fontSize: 27.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchEditingController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search groups...",
                        hintStyle: TextStyle(
                          color: Colors.white38,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _initiateSearch,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : groupList(),
          ],
        ),
      ),
    );
  }
}

import 'package:chitchat/helpers/authenticate.dart';
import 'package:chitchat/helpers/helperfunctions.dart';
import 'package:chitchat/services/auth.dart';
import 'package:chitchat/services/database.dart';
import 'package:chitchat/views/groups/profile_page.dart';
import 'package:chitchat/views/groups/search_page.dart';
import 'package:chitchat/widgets/group/group_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data
  User? _user;
  String? _groupName;
  String _userName = '';
  String _email = '';
  Stream? _groups;

  // InitState
  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
  }

  // Widgets
  Widget noGroupWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                _popupDialog(context);
              },
              child:
                  Icon(Icons.add_circle, color: Colors.grey[700], size: 75.0)),
          SizedBox(height: 20.0),
          Text(
            "You've not joined any group, tap on the 'add' icon to create a group or search for groups by tapping on the search button below.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget groupsList() {
    return StreamBuilder(
      stream: _groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  int reqIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                    userName: snapshot.data['fullName'],
                    groupId: _destructureId(snapshot.data['groups'][reqIndex]),
                    groupName:
                        _destructureName(snapshot.data['groups'][reqIndex]),
                  );
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // Functions
  // Future<void> _getUserAuthAndJoinedGroups() async {
  //   _user = FirebaseAuth.instance.currentUser;
  //   if (_user != null) {
  //     setState(() {
  //       _email = _user!.email!;
  //     });
  //     await HelperFunctions.getUserNameSharedPreference().then((value) {
  //       setState(() {
  //         _userName = value ?? '';
  //       });
  //     });
  //     DatabaseMethods(uid: _user!.uid).getUserGroups().then((snapshots) {
  //       setState(() {
  //         _groups = snapshots;
  //       });
  //     });
  //   }
  // }

  Future<void> _getUserAuthAndJoinedGroups() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      setState(
        () {
          _email = _user!.email!;
        },
      );

      // Get the username from shared preferences
      _userName = await HelperFunctions.getUserNameSharedPreference();

      // Listen to the user groups stream
      // _groups = await DatabaseMethods(uid: _user!.uid).getUserGroups();
      _groups = DatabaseMethods(uid: _user!.uid).getUserGroups();
      setState(() {});
    }
  }

  String _destructureId(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  void _popupDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = TextButton(
      child: Text("Create"),
      onPressed: () async {
        if (_groupName != null) {
          await HelperFunctions.getUserNameSharedPreference().then((val) {
            DatabaseMethods(uid: _user!.uid).createGroup(val, _groupName!);
          });
          Navigator.of(context).pop();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group"),
      content: TextField(
        onChanged: (val) {
          _groupName = val;
        },
        style: TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black),
      ),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Building the HomePage widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Groups',
          style: TextStyle(
            color: Colors.black,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black, // Change drawer icon color to white
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            icon: Icon(Icons.search, color: Colors.black, size: 25.0),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SearchPage()));
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          children: <Widget>[
            Icon(Icons.account_circle, size: 150.0, color: Colors.grey[700]),
            SizedBox(height: 15.0),
            Text(_userName,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
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
                      userName: _userName,
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
      body: groupsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _popupDialog(context);
        },
        child: Icon(Icons.add, color: Colors.white, size: 30.0),
        backgroundColor: Colors.grey[700],
        elevation: 0.0,
      ),
    );
  }
}

import 'package:chitchat/helpers/constants.dart';
import 'package:chitchat/services/database.dart';
import 'package:chitchat/views/conversationScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchEditingController = TextEditingController();
  // QuerySnapshot<Map<String, dynamic>>? searchResultSnapshot;
  QuerySnapshot<Map<String, dynamic>>? searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  // Future<void> initiateSearch() async {
  //   if (searchEditingController.text.isNotEmpty) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     await databaseMethods
  //         .searchByName(searchEditingController.text)
  //         .then((snapshot) {
  //       setState(() {
  //         searchResultSnapshot = snapshot;
  //         isLoading = false;
  //         haveUserSearched = true;
  //       });
  //     });
  //   }
  // }

  void initiateSearch(String searchField) async {
    if (searchField.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      try {
        // Perform the search
        final snapshot = await databaseMethods.searchByName(searchField)
            as QuerySnapshot<Map<String, dynamic>>;
        setState(() {
          searchResultSnapshot = snapshot;
          isLoading = false;
          haveUserSearched = true;
        });
      } catch (e) {
        print("Error during search: $e");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot?.docs.length ?? 0,
            itemBuilder: (context, index) {
              var userData = searchResultSnapshot!.docs[index].data();
              return userTile(
                userData["userName"],
                userData["userEmail"],
              );
            },
          )
        : Container();
  }

  /// 1. Create a chat room, send user to the chat room, and pass other user details.
  void sendMessage(String userName) {
    List<String> users = [Constants.myName, userName];
    String chatRoomId = getChatRoomId(Constants.myName, userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          chatRoomId: chatRoomId,
          userName: userName,
        ),
      ),
    );
  }

  Widget userTile(String userName, String userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getChatRoomId(String a, String b) {
    return a.toLowerCase().compareTo(b.toLowerCase()) > 0 ? "$b\_$a" : "$a\_$b";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: appBarMain(context),
      appBar: AppBar(
        title: Text("Search Users"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: Color(0x54FFFFFF),
                  child: Row(
                    children: [
                      Expanded(
                        child:
                            // TextField(
                            //   controller: searchEditingController,
                            //   style: simpleTextStyle(),
                            //   decoration: InputDecoration(
                            //     hintText: "Search username ...",
                            //     hintStyle: TextStyle(
                            //       color: Colors.black,
                            //       fontSize: 16,
                            //     ),
                            //     border: InputBorder.none,
                            //   ),
                            // ),
                            TextField(
                          controller: searchEditingController,
                          style: TextStyle(
                            color: Colors
                                .black, // Ensure text color is visible on white background
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: "Search username ...",
                            hintStyle: TextStyle(
                              color: Colors
                                  .grey, // Use a lighter grey for the hint text
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        // onTap: initiateSearch(searchEditingController.text),
                        onTap: () =>
                            initiateSearch(searchEditingController.text),

                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF29B6F6),
                                const Color(0xFF29B6F6),
                              ],
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          // decoration: BoxDecoration(
                          //   color: Colors.blueAccent,
                          //   borderRadius: BorderRadius.circular(40),
                          // ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            "assets/images/search_white.png",
                            height: 25,
                            width: 25,
                          ),
                          // child: Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: userList()),
              ],
            ),
    );
  }
}

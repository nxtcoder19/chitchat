import 'package:chitchat/views/chatRoomScreen.dart';
import 'package:chitchat/views/groups/home_page.dart';
import 'package:flutter/material.dart';

class TabViewController extends StatefulWidget {
  const TabViewController({Key? key}) : super(key: key);

  @override
  _TabViewControllerState createState() => _TabViewControllerState();
}

class _TabViewControllerState extends State<TabViewController> {
  int tabIndex = 0;
  final List<Widget> tabs = [
    ChatRoom(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            tabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
        ],
      ),
    );
  }
}

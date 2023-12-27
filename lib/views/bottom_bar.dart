import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/profilescreen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({
    super.key,
  });

  @override
  State<BottomBarScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<BottomBarScreen> {
  int selectedIndex = 0;
  Color? color0;
  Color? color1;
  Color? color2;

  static final List<Widget> _widgetOptions = <Widget>[
    const ChatScreen(),
    const SearchScreen(),
    const ProfileScreen()
  ];

  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
      color0 = selectedIndex == 0 ? Colors.deepPurple : Colors.white;
      color1 = selectedIndex == 1 ? Colors.deepPurple : Colors.white;
      color2 = selectedIndex == 2 ? Colors.deepPurple : Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            currentIndex: selectedIndex,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            onTap: onItemTap,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(CupertinoIcons.chat_bubble_2, color: color0),
                label: "Chats",
              ),
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(CupertinoIcons.search, color: color1),
                label: "Search",
              ),
              BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(CupertinoIcons.profile_circled, color: color2),
                label: "Profile",
              ),
            ],
          ),
        ),
        body: Center(child: _widgetOptions.elementAt(selectedIndex)));
  }
}

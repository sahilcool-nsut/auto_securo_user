import 'package:auto_securo_user/main_screens/request_notifications.dart';

import 'homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

import 'notification_screen.dart';
import 'request_screen.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPage = 0;

  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        circleColor: Colors.red,
        inactiveIconColor: Colors.red,
        tabs: [
          TabData(
            iconData: Icons.home,
            title: "Home",
            // onclick: () {
            //   final FancyBottomNavigationState fState = bottomNavigationKey
            //       .currentState as FancyBottomNavigationState;
            //   fState.setPage(2);
            // },
          ),
          TabData(
            iconData: Icons.search,
            title: "Search",
            // onclick: () => Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => ScannerScreen(),
            //   ),
            // ),
          ),
          TabData(iconData: Icons.notifications, title: "Requests"),
          TabData(iconData: Icons.history, title: "History")
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return HomeScreen();
      case 1:
        return RequestScreen();
      case 2:
        return RequestNotificationScreen();
      default:
        return NotificationScreen();
    }
  }
}

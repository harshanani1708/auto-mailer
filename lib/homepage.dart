import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipr_hackathon/emailTest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'historypage.dart';
import 'historytile.dart';

class HomePage extends StatefulWidget {
  String email, password;
  HomePage({required this.email, required this.password});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          controller: _pageController,
          children: [
            FutureMailsHomePage(email: widget.email, password: widget.password),
            HistoryPage(),
          ],
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          iconSize: 30,
          showElevation: false,
          containerHeight: 70,
          onItemSelected: (index) => setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.apps),
              title: Text('Home'),
              activeColor: Colors.red,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.person),
                title: Text('History'),
                activeColor: Colors.purpleAccent),
          ],
        ),
      ),
    );
  }
}

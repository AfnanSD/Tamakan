import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamakan/View/manage_family.dart';
import 'package:tamakan/View/myChildren.dart';
import 'package:tamakan/View/parentProfileView.dart';

class navigation extends StatefulWidget {
  static const String screenRoute = 'welcomeView';

  const navigation({Key? key}) : super(key: key);

  @override
  State<navigation> createState() => _navigationState();
}

class _navigationState extends State<navigation> {
  int index = 1;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final screens = [ManageFamily(), myChildren(), parentprofileview()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(
          color: Color(0xff1A535C),
        )),
        child: CurvedNavigationBar(
          key: _bottomNavigationKey,
          color: Color(0xff4ECDC4),
          index: index,
          height: 60,
          animationCurve: Curves.easeInOut,
          backgroundColor: Colors.transparent,
          items: <Widget>[
            Icon(Icons.people_alt, size: 30),
            Icon(Icons.home, size: 30),
            Icon(Icons.person, size: 30),
          ],
          onTap: (index) {
            if (index == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ManageFamily()));
            }
            if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const myChildren()));
            }
            if (index == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const parentprofileview()));
            }
          },
        ),
      ),
      body: screens[index],
    );
  }
}

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
  final screens = [parentprofileview(), myChildren(), ManageFamily()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          key: _bottomNavigationKey,
          color: Color(0xffFF6B6B),
          index: index,
          height: 60,
          animationCurve: Curves.easeInOut,
          backgroundColor: Colors.transparent,
          items: <Widget>[
            Icon(Icons.person, size: 30),
            Icon(Icons.home, size: 30),
            Icon(Icons.people_alt, size: 30),
          ],
          onTap: (index) => setState(() => this.index = index),
        ),
      ),
      body: screens[index],
    );
  }
}

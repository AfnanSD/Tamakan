import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamakan/View/manage_family.dart';
import 'package:tamakan/View/myChildren.dart';
import 'package:tamakan/View/parentProfileView.dart';

class navigation extends StatefulWidget {
  navigation({
    Key? key,
    index = 1,
  }) : super(
          key: key,
        ) {
    this.index = index;
  }
  int index = 1;

  @override
  State<navigation> createState() => _navigationState();
}

class _navigationState extends State<navigation> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final screens = [
    const parentprofileview(),
    const myChildren(),
    const ManageFamily()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: const IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          key: _bottomNavigationKey,
          color: const Color(0xffFF6B6B),
          index: widget.index,
          height: 60,
          animationCurve: Curves.easeInOut,
          backgroundColor: Colors.transparent,
          items: const <Widget>[
            Icon(Icons.person, size: 30),
            Icon(Icons.home, size: 30),
            Icon(Icons.group_add, size: 30),
          ],
          onTap: (index) => setState(() => widget.index = index),
        ),
      ),
      body: screens[widget.index],
    );
  }
}

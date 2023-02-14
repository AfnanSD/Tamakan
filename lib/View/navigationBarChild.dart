import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamakan/View/child_coupons_view.dart';
import 'package:tamakan/View/levels/levels.dart';
import 'package:tamakan/View/manage_family.dart';
import 'package:tamakan/View/myChildren.dart';
import 'package:tamakan/View/parentProfileView.dart';
import 'package:tamakan/View/quranMap.dart';
import 'package:tamakan/View/quran_view.dart';
import 'package:tamakan/View/surah_view.dart';

class navigationChild extends StatefulWidget {
  const navigationChild({super.key, required this.childID});
  final String childID;

  @override
  State<navigationChild> createState() => _navigationChildState();
}

class _navigationChildState extends State<navigationChild> {
  int index = 1;
  var screens;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screens = [
      ChildCouponsVIew(
        childID: widget.childID,
      ),
      levels(
        childID: widget.childID,
      ),
      //Quran_map()
      QuranView(
        childID: widget.childID,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: const IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          color: const Color(0xffFF6B6B),
          index: index,
          height: 60,
          animationCurve: Curves.easeInOut,
          backgroundColor: Colors.transparent,
          items: const <Widget>[
            Icon(Icons.card_giftcard, size: 30),
            Icon(Icons.home, size: 30),
            Icon(Icons.menu_book_rounded, size: 30),
          ],
          onTap: (index) => setState(() => this.index = index),
        ),
      ),
      body: screens[index],
    );
  }
}

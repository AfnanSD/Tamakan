import 'package:flutter/material.dart';

import '../../Model/child.dart';

class ChildPoints extends StatelessWidget {
  const ChildPoints({super.key, required this.child});
  final Child child;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(20),
          child: Card(
            shadowColor: Colors.grey,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: Container(
                width: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${child.points}'),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/images/star3.png',
                      scale: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

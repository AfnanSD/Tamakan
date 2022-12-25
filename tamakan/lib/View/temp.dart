import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:tamakan/View/add_child.dart';
import 'package:tamakan/View/child_homepage.dart';
import 'package:tamakan/View/parentProfile.dart';
import 'package:tamakan/View/view_child_profile.dart';

class Temp extends StatelessWidget {
  const Temp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddChild(),
                    ));
              },
              child: Text('add child')),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChildHomePage(
                            childID: 'K2WRY0J6f2TkffrQcI9w',
                          )));
            },
            child: Text('child home page'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ViewChildProfile(
                            childID: 'K2WRY0J6f2TkffrQcI9w',
                          )));
            },
            child: Text('view child profile'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const parentprofileview()));
            },
            child: Text('parent profile'),
          ),
        ],
      ),
    );
  }
}

//\\\Not used///\\\

import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';

class LevelMapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LevelMap(
      backgroundColor: Colors.limeAccent,
      levelMapParams: LevelMapParams(
        levelCount: 5,
        currentLevel: 2.4,
        currentLevelImage: ImageParams(
          path: "Image.asset('assets/images/rabbit.png',scale: 0.5,)",
          size: Size(25, 25),
        ),
        lockedLevelImage: ImageParams(
          path: "Image.asset('assets/images/star.png',scale: 0.5,)",
          size: Size(15, 15),
        ),
        completedLevelImage: ImageParams(
          path: "Image.asset('assets/images/book.png',scale: 0.5,)",
          size: Size(10, 10),
        ),
      ),
    );
  }
}

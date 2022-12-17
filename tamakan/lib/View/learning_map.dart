import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tamakan/View/game.dart';
import 'package:tamakan/View/lesson.dart';

class LearningMap extends StatefulWidget {
  const LearningMap({super.key});

  @override
  State<LearningMap> createState() => _LearningMapState();
}

class _LearningMapState extends State<LearningMap> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        ElevatedButton(
            child: Text('game'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Game(
                      practiceID: '21.5',
                    ),
                  ));
            }),
        ElevatedButton(
            child: Text('lesson'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Lesson(lessonID: '1')));
            }),
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class labelGrey extends StatelessWidget {
  final String? inputLabel;
  labelGrey({Key? key, required this.inputLabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ' ${inputLabel}',
            style: TextStyle(
                color: Color(0xff1A535C), //Color.fromARGB(255, 153, 159, 158),
                fontWeight: FontWeight.bold,
                fontSize: 23),
          ),
        ],
      ),
    );
  }
}

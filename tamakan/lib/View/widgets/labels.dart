import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class label extends StatelessWidget {
  final String inputLabel;
  label({Key? key, required this.inputLabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            ' ${inputLabel}',
            style: TextStyle(
                color: Color.fromARGB(255, 71, 81, 80),
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          Text(
            '*',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

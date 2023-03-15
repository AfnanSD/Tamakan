import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class labelContent extends StatelessWidget {
  final String? inputLabel;
  final Color labelColor;
  final double fontSize;

  labelContent(
      {Key? key,
      required this.inputLabel,
      required this.labelColor,
      required this.fontSize})
      : super(key: key);

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
                color: labelColor, //Color.fromARGB(255, 153, 159, 158),
                fontWeight: FontWeight.bold,
                fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget({
    super.key,
    required this.fun,
    required this.buttonLabel,
    required this.buttonColor,
  });

  late VoidCallback fun;
  late String buttonLabel;
  late Color
      buttonColor; //Color(0xffFF6B6B) - Color(0xff1A535C) - Color(0xff4ECDC4)

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        onPressed: fun,
        child: Container(
          padding: EdgeInsets.all(7),
          child: Center(
              child: Text(
            buttonLabel,
            style: TextStyle(fontSize: 18),
            //style: TextStyle(color: Color.fromARGB(255, 71, 81, 80)),
          )),
          width: double.infinity,
        ),
      ),
    );
  }
}

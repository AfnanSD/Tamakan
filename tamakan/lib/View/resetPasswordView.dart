import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tamakan/Controller/authController.dart';
import 'package:tamakan/View/widgets/TextInputField.dart';
import 'package:tamakan/View/widgets/labels.dart';

class resetPasswordView extends StatelessWidget {
  resetPasswordView({Key? key}) : super(key: key);

  TextEditingController _emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Reset button
    final resetButton = Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromRGBO(255, 230, 109, 1),
      child: MaterialButton(
        // padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        // minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          AuthController().resetpass(_emailController.text.trim());
        },
        child: Text(
          "إرسـال",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 71, 81, 80),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/password.png"),
              fit: BoxFit.fill //BoxFit.cover,
              ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 600,
                    ),
                    const Text(
                      "الرجاء إدخال البريد الإلكتروني حتى نتمكن من إعادة تعيين كلمة مرورك",
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 66, 63, 63),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    label(inputLabel: 'البريد الإلكتروني'),
                    TextInputField(
                        controller: _emailController,
                        myLabelText: 'البريد الإلكتروني',
                        myHintText: 'admin@gmail.com'),
                    const SizedBox(
                      height: 40,
                    ),
                    resetButton,
                    const SizedBox(
                      height: 130,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

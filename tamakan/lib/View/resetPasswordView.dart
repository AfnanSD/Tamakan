import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          try {
            EasyLoading.show(status: '..انتظر قليلًا');
            await FirebaseAuth.instance
                .sendPasswordResetEmail(email: _emailController.text.trim());
            EasyLoading.dismiss();
            EasyLoading.showSuccess(
                'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني');
            if (_emailController.text.trim() != null) {
              Navigator.pushNamed(context, '/registerview');
            }
          } catch (e) {
            print(e);
            EasyLoading.dismiss();
            EasyLoading.showError('الرجاء التحقق من صلاحية البريد الإلكتروني');
          }
        },
        child: Text(
          "إرسـال",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 22,
              color: Color.fromARGB(255, 71, 81, 80),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/b2.png"),
                fit: BoxFit.fill //BoxFit.cover,
                ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/logo3.png',
                    height: 150,
                    width: 150,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  const Text(
                    "إعادة تعيين كلمة المرور",
                    style: TextStyle(
                        fontSize: 40,
                        color: Color.fromARGB(255, 71, 81, 80),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(
                    width: 120,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/loginview');
                      },
                      icon: Icon(Icons.arrow_forward_outlined))
                ],
              ),
              SizedBox(
                height: 50,
              ),
              SingleChildScrollView(
                child: Center(
                  child: Container(
                    height: 500,
                    width: 600,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 5),
                              blurRadius: 10,
                              spreadRadius: 1,
                              color: Colors.grey[300]!)
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
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
                              height: 40,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 250,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

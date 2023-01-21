import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tamakan/Controller/authController.dart';
import 'package:tamakan/View/myChildren.dart';
import 'package:tamakan/View/widgets/TextInputField.dart';
import 'package:tamakan/View/widgets/labels.dart';
import 'package:tamakan/View/resetPasswordView.dart';

class loginview extends StatelessWidget {
  static const String screenRoute = 'login_screen';

  loginview({Key? key}) : super(key: key);

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
//Login button
    final signupButton = Container(
      margin: const EdgeInsets.only(right: 150, left: 150),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(30),
        color: Color.fromRGBO(255, 230, 109, 1),
        child: MaterialButton(
          // padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          // minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            Future<bool> user = AuthController().login(
                _emailController.text.trim(), _passwordController.text.trim());
            print(user);
            if (await user) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const myChildren()));
            } else {
              Navigator.pushNamed(context, '/loginview');
            }
          },
          child: Text(
            "تسجيل الدخول",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 71, 81, 80),
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

    // ignore: prefer_const_constructors
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
                      width: 120,
                    ),
                    const Text(
                      "  اهــلاََ بــك",
                      style: TextStyle(
                          fontSize: 50,
                          color: Color.fromARGB(255, 71, 81, 80),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  child: Center(
                    child: Container(
                      height: 550,
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
                          Text(
                            "  تسجيل الدخول",
                            style: TextStyle(
                                fontSize: 30,
                                color: Color.fromARGB(255, 71, 81, 80),
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          //here starts the text fields that the user will enter
                          label(inputLabel: 'البريد الإلكتروني'),
                          TextInputField(
                            controller: _emailController,
                            myLabelText: 'البريد الإلكتروني',
                            myHintText: 'admin@gmail.com',
                            //myIcon: Icons.mail,
                            obsecure: false,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          label(inputLabel: 'كلمة المرور'),
                          TextInputField(
                            controller: _passwordController,
                            myLabelText: 'كلمة المرور',
                            myHintText: '********',
                            //myIcon: Icons.mail,
                            obsecure: true,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          resetPasswordView()));
                            },
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                ' هل نسيت كلمة المرور؟',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 71, 81, 80),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ), //SIGN UP BUTTON
                          signupButton,
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                child: const Text(
                                  ' أنشئ حسابك الان',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 20,
                                      color: Color(0xffFF6B6B),
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                                onPressed: () {
                                  //Navigator.pushNamed(context, '/login');
                                  //No
                                  //Navigator.pushNamed(context, LoginScreen.screenRoute);
                                  Navigator.pushNamed(context, '/registerview');
                                },
                              ),
                              const Text(
                                'لا تمتلك حساب بعد؟',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 71, 81, 80),
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 140,
                ),
              ])),
    );
  }
}

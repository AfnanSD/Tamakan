import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tamakan/Controller/authController.dart';
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
            Future<bool> user = AuthController()
                .login(_emailController.text, _passwordController.text);
            print(user);
            if (await user) {
              Navigator.pushNamed(context, '/ParentProfile');
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
              image: AssetImage("assets/images/login.png"),
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
                SizedBox(
                  height: 600,
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
                            builder: (context) => resetPasswordView()));
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
                            fontSize: 25,
                            color: Color.fromARGB(255, 71, 81, 80),
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
                          fontSize: 25,
                          color: Color.fromARGB(255, 71, 81, 80),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

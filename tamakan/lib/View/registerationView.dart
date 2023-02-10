import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tamakan/Controller/authController.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tamakan/Controller/authController.dart';
import 'package:tamakan/View/myChildren.dart';
import 'package:tamakan/View/navigationBarParent.dart';
import 'package:tamakan/View/widgets/TextInputField.dart';
import 'package:tamakan/View/widgets/button_widget.dart';
import 'package:tamakan/View/widgets/labels.dart';

class registerationview extends StatefulWidget {
  static const String screenRoute = 'register_screen';

  const registerationview({Key? key}) : super(key: key);

  @override
  State<registerationview> createState() => _registerationviewState();
}

class _registerationviewState extends State<registerationview> {
  String p = "";
  //The variables that are going to store the values entered by the parent(user)

  DateTime date = DateTime(
    2000,
    01,
    01,
  );
  bool nameField = false;
  bool BDField = false;
  bool emailField = false;
  bool passwordField = false;
  bool conpasswordField = false;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _password2Controller = new TextEditingController();

  final List<String> genders = [
    'أنثى',
    'ذكر',
  ];
  String? gender = 'أنثى';

  @override
  Widget build(BuildContext context) {
//Sign up button not fit
    final signupButton1 = ButtonWidget(
        fun: () async {
          Future<bool> user = AuthController().register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _password2Controller.text.trim(),
            gender,
            _dateController.text,
          );
          print(user);
          if (await user) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const navigation()));
          } else {
            Navigator.pushNamed(context, '/registerview');
          }
        },
        buttonLabel: 'إنشاء حساب',
        buttonColor: Color(0xff1A535C) //Color.fromRGBO(255, 230, 109, 1),
        );
    //Sign up button
    final signupButton = Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromRGBO(255, 230, 109, 1)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        onPressed: (nameField &
                BDField &
                emailField &
                passwordField &
                conpasswordField)
            ? () async {
                Future<bool> user = AuthController().register(
                  _nameController.text.trim(),
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                  _password2Controller.text.trim(),
                  gender,
                  _dateController.text,
                );
                print(user);
                if (await user) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const navigation()));
                } else {
                  Navigator.pushNamed(context, '/registerview');
                }
              }
            : null,
        child: Text(
          "إنشاء الحساب",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 22,
              color: Color.fromARGB(255, 71, 81, 80),
              fontWeight: FontWeight.bold),
        ),
      ),
    );

    // ignore: prefer_const_constructors
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              Container(
                  child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo3.png',
                    height: 150,
                    width: 150,
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  const Text(
                    "  تـمـكـــن",
                    style: TextStyle(
                        fontSize: 50,
                        color: Color.fromARGB(255, 71, 81, 80),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ],
              )),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                child: Center(
                  child: Container(
                    //sheight: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.height * 0.8,
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
                        const Text(
                          "  إنشاء حساب جديد",
                          style: TextStyle(
                              fontSize: 30,
                              color: Color.fromARGB(255, 71, 81, 80),
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        //here starts the text fields that the user will enter
                        label(inputLabel: 'الإسم'),
                        TextInputField(
                          controller: _nameController,
                          myLabelText: 'الإسم',
                          myHintText: 'مثل: أمل',
                          validator: (name) {
                            RegExp regexname = RegExp(r'^.{2,}$');
                            if (name!.isEmpty || name.trim().isEmpty)
                              return "الرجاء أدخال الأسم";
                            else if (!regexname.hasMatch(name)) {
                              return "يجب ان يحتوي الأسم على حرفين على الأقل";
                            } else if (!RegExp(r"^[\p{L} ,.'-]*$",
                                    caseSensitive: false,
                                    unicode: true,
                                    dotAll: true)
                                .hasMatch(name)) {
                              return "يجب ان يحتوي الأسم على أحرف فقط";
                            } else if (name.length > 20) {
                              return "يجب ان يكون الاسم اقل من 20 حرف";
                            }
                            nameField = true;
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),

                        //Drop down button
                        //GENDER
                        label(inputLabel: 'الجنس'),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                            //margin:EdgeInsets.only(right: 100, left: 100),
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                    color: Color.fromARGB(115, 60, 69, 69)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              )),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 4),
                                child: DropdownButton<String>(
                                    isExpanded: true,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    value: gender,
                                    items: genders
                                        .map((item) => DropdownMenuItem(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54),
                                            )))
                                        .toList(),
                                    onChanged: (item) => setState(
                                          (() => gender = item),
                                        )),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        label(inputLabel: 'تاريخ الميلاد'),
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              //margin:EdgeInsets.only(right: 100, left: 100),
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54),
                                controller: _dateController,
                                validator: (bDate) {
                                  if (bDate!.isEmpty || bDate.trim().isEmpty) {
                                    return "الرجاء أدخال تاريخ الميلاد";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    //ENABLED BORDER: NOT CLICKED BY USER YET
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                115, 60, 69, 69)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    //FOCUSED BORDER: CLICKED BY USER
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.amber, width: 2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    //labelText: "تاريخ الميلاد",
                                    hintText: "اختر سنة ميلادك",
                                    hintTextDirection: TextDirection.rtl,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20)),
                                onTap: () async {
                                  // Below line stops keyboard from appearing
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  DateTime? newDate = await showDatePicker(
                                      context: context,
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            primaryColor: Colors.amber,
                                            colorScheme: ColorScheme.light(
                                                primary: Colors.amber),
                                            buttonTheme: ButtonThemeData(
                                                textTheme:
                                                    ButtonTextTheme.primary),
                                          ),
                                          child: child!,
                                        );
                                      },
                                      initialDate: DateTime(2000),
                                      firstDate: DateTime(1930),
                                      lastDate: DateTime(2010));
                                  //if Cancel
                                  if (newDate == null) return;
                                  //if OK
                                  setState(() => date = newDate);
                                  _dateController.text =
                                      intl.DateFormat.yMMMd().format(newDate);
                                  BDField = true;
                                },
                              ),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        label(inputLabel: 'البريد الإلكتروني'),
                        TextInputField(
                          controller: _emailController,
                          myLabelText: 'البريد الإلكتروني',
                          myHintText: 'admin@gmail.com',
                          validator: (email) {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regexemail = RegExp(pattern.toString());

                            if (email!.isEmpty || email.trim().isEmpty) {
                              return "الرجاء إدخال بريدك الإلكتروني";
                            }

                            if (!regexemail.hasMatch(email)) {
                              return 'بريدك الإلكتروني غير صحيح';
                            }
                            emailField = true;
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        label(inputLabel: 'كلمة المرور'),
                        TextInputField(
                          controller: _passwordController,
                          myLabelText: 'كلمة المرور',
                          myHintText:
                              ' يجب ان تحتوي على الاقل من عشرة خانات من الارقام و الاحرف',
                          obsecure: true,
                          validator: (password) {
                            print(password);
                            p = password!;
                            RegExp regexpass = new RegExp(r'^.{8,}$');
                            if (password.isEmpty || password.trim().isEmpty) {
                              return "الرجاء تعيين كلمة مرور";
                            }
                            if (password.length < 8) {
                              return 'الرجاء إدخال كلمة مرور تحتوي على 8 خانات';
                            }
                            if (!(password.contains(new RegExp(r'[A-Z]')) &&
                                password.contains(new RegExp(r'[0-9]')) &&
                                password.contains(new RegExp(r'[a-z]')))) {
                              return 'الرجاء إدخال كلمة مرور تحتوي على حرف كبير وصغير ورقم';
                            }
                            passwordField = true;
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        label(inputLabel: 'تأكيد كلمة المرور '),
                        TextInputField(
                          controller: _password2Controller,
                          myLabelText: 'تأكيد كلمة المرور ',
                          myHintText:
                              'يجب ان تكون متطابقة مع كلمه المرور اعلاه',
                          obsecure: true,
                          validator: (passward2) {
                            print("ppp" + p);
                            print(passward2);
                            if (p != passward2) {
                              return "يجب ان تكون كلمات المرور متطابقة";
                            }
                            conpasswordField = true;
                            return null;
                          },
                        ),
                        //SIGN UP BUTTON
                        SizedBox(
                          height: 25,
                        ),
                        signupButton,
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: const Text(
                                'تفضل بالدخول',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 25,
                                    color: Color(0xffFF6B6B),
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                              onPressed: () {
                                //Navigator.pushNamed(context, '/login');
                                //No
                                //Navigator.pushNamed(context, LoginScreen.screenRoute);
                                Navigator.pushNamed(context, '/loginview');
                              },
                            ),
                            const Text(
                              'لديك حساب؟',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 71, 81, 80),
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 15,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:biometric/services/authservice.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import 'components/backgroundcreateemail.dart';

class BodyEmails extends StatefulWidget {
  // final Registration register;
  // BodyEmails({Key key, @required this.register}) : super(key: key);
  @override
  _BodyEmailsState createState() => _BodyEmailsState();
}

class _BodyEmailsState extends State<BodyEmails> {
  final _kwesi = GlobalKey<FormState>();

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  String? validatePassword(String value) {
    if (value.length != 6) {
      return 'Password must only be six digits long';
    }
    return null;
  }

  checkFields() {
    final form = _kwesi.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  String? validatePhoneNumber(String value) {
    if (value.length != 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String email = '';
  String password = '';
  String confirmpassword = '';
  @override
  Widget build(BuildContext context) {
    TextEditingController _confirmPass = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    // email = register.email;
    TextEditingController _pass = TextEditingController();
    // password = register.password;
    Color greenColor = const Color(0xFF00AF19);
    //provides total height and width of our screen
    Size size = MediaQuery.of(context).size;
    return BackgroundCreateEmail(
        child: Form(
      key: _kwesi,
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Terry',
                    style: TextStyle(fontFamily: 'Trueno', fontSize: 60.0),
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Container(
                      height: 10.0,
                      width: 10.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: greenColor))
                ],
              ),
              Lottie.asset("assets/signup.json", height: size.height * 0.2),
              TextFormField(
                controller: _emailController,
                validator: (value) =>
                    value!.isEmpty ? 'Email is required' : validateEmail(value),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: 'EMAIL',
                    labelStyle: TextStyle(
                        fontFamily: 'Trueno',
                        fontSize: 12.0,
                        color: Colors.grey.withOpacity(0.5)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: greenColor),
                    )),
                onChanged: (value) {
                  this.email = value.trim();
                },
              ),
              TextFormField(
                controller: _pass,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'PASSWORD',
                    labelStyle: TextStyle(
                        fontFamily: 'Trueno',
                        fontSize: 12.0,
                        color: Colors.grey.withOpacity(0.5)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: greenColor),
                    )),
                onChanged: (value) {
                  this.password = value.trim();
                },
                validator: (value) => value!.isEmpty
                    ? 'Password is required'
                    : validatePassword(value),
              ),
              TextFormField(
                controller: _confirmPass,
                validator: (value) {
                  if (value!.isEmpty) return 'Password is required';
                  if (value != _pass.text) {
                    return 'Please enter a matching password';
                  }

                  return null;
                },
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'CONFIRM PASSWORD',
                    labelStyle: TextStyle(
                        fontFamily: 'Trueno',
                        fontSize: 12.0,
                        color: Colors.grey.withOpacity(0.5)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: greenColor),
                    )),
                onChanged: (value) {
                  this.confirmpassword = value.trim();
                },
              ),
              SizedBox(
                height: size.height * 0.07,
              ),
              GestureDetector(
                onTap: () {
                  if (checkFields()) {
                    AuthService().signUp(email, password, context);

                    Navigator.pop(context);
                  }
                },
                child: Container(
                  height: 50.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.greenAccent,
                    color: greenColor,
                    elevation: 7.0,
                    child: const Center(
                      child: Text(
                        'NEXT',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Trueno'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

import 'package:biometric/createemail.dart';
import 'package:biometric/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:io';

import 'package:local_auth/local_auth.dart';

import 'components/backgroundlogin.dart';

class BodyLogin extends StatefulWidget {
  @override
  _BodyLoginState createState() => _BodyLoginState();
}

class _BodyLoginState extends State<BodyLogin> {
  bool userHasTouchId = false;
  final LocalAuthentication localAuth = LocalAuthentication();
  bool _useTouchId = false;
  final storage = const FlutterSecureStorage();

  checkFields() {
    final form = _sokwe.currentState;
    if (form!.validate()) {
      FocusScope.of(context).unfocus();
      form.save();
      return true;
    }
    return false;
  }

  final _sokwe = GlobalKey<FormState>();
  late String email, password;
  String? validateEmail(String value) {
    String? pattern =
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
      return 'Password must be at least six digits long';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    getSecureStorage();
  }

  void _authentimanenoz() async {
    final canCheck = await localAuth.canCheckBiometrics;
    final deviceIsSupported = await localAuth.isDeviceSupported();
    if (canCheck && deviceIsSupported) {
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();
      if (Platform.isIOS) {
        try {
          if (availableBiometrics.contains(BiometricType.face)) {
            // Face ID.
            final authenticated = await localAuth.authenticate(
                localizedReason: 'Enable Face ID to sign in more easily');
            // .
            //     catchError((e) {
            //   ErrorHandler().errorDialog(context, e);
            // });
            if (authenticated) {
              String? userStoredEmail = await storage.read(
                key: 'email',
              );
              String? userStoredPassword = await storage.read(
                key: 'password',
              );
              AuthService()
                  .signIn(userStoredEmail!, userStoredPassword!, context);
            }
          }
        } on Exception catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      } else {
        // Face ID.
        try {
          final authenticated = await localAuth.authenticate(
              localizedReason: 'Sign in with Face ID or Touch ID',
              useErrorDialogs: true,
              stickyAuth: true);

          if (authenticated) {
            String? userStoredEmail = await storage.read(
              key: 'email',
            );
            String? userStoredPassword = await storage.read(
              key: 'password',
            );
            AuthService()
                .signIn(userStoredEmail!, userStoredPassword!, context);
          }
        } on Exception catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    } else {
      return;
    }
  }

  void getSecureStorage() async {
    final isUsingBio = await storage.read(key: 'usingBiometric');
    if (mounted) {
      setState(() {
        userHasTouchId = isUsingBio == 'true';
      });
    }
  }

  void _authenticaterero() async {
    final canCheck = await localAuth.canCheckBiometrics;
    final deviceIsSupported = await localAuth.isDeviceSupported();

    if (canCheck && deviceIsSupported) {
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();

      if (Platform.isIOS) {
        if (availableBiometrics.contains(BiometricType.face)) {
          // Face ID.
          try {
            final authenticated = await localAuth.authenticate(
                localizedReason: 'Enable Face ID to sign in more easily',
                useErrorDialogs: true,
                stickyAuth: true);

            if (authenticated) {
              storage.write(key: 'email', value: email);
              storage.write(key: 'password', value: password);
              storage.write(key: 'usingBiometric', value: 'true');
            }
          } on Exception catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          // Touch ID.
          try {
            final authenticated = await localAuth.authenticate(
                localizedReason: 'Enable Touch ID to sign in more easily',
                useErrorDialogs: true,
                stickyAuth: true);

            if (authenticated) {
              storage.write(key: 'email', value: email);
              storage.write(key: 'password', value: password);
              storage.write(key: 'usingBiometric', value: 'true');
            }
          } on Exception catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
        }
      } else {
        // Face ID.
        try {
          final authenticated = await localAuth.authenticate(
              localizedReason: 'Sign in with Face ID or Touch ID',
              useErrorDialogs: true,
              stickyAuth: true);

          if (authenticated) {
            storage.write(key: 'email', value: email);
            storage.write(key: 'password', value: password);
            storage.write(key: 'usingBiometric', value: 'true');
          }
        } on Exception catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color greenColor = const Color(0xFF00AF19);
    Size size = MediaQuery.of(context).size;
    //provides total height and width of our screen
    return BackgroundLogin(
        child: Form(
      key: _sokwe,
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            // reverse: true,
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
                    width: size.width * 0.03,
                  ),
                  Container(
                      height: 10.0,
                      width: 10.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: greenColor))
                ],
              ),
              SizedBox(
                height: size.height * 0.07,
              ),
              TextFormField(
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
                validator: (value) =>
                    value!.isEmpty ? 'Email is required' : validateEmail(value),
              ),
              TextFormField(
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
              SizedBox(
                height: size.height * 0.06,
              ),
              userHasTouchId
                  ? InkWell(
                      onTap: () => _authentimanenoz(),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                  color: Colors.greenAccent, width: 2.0),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: const Icon(
                            Icons.fingerprint_outlined,
                            size: 30,
                          )),
                    )
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Checkbox(
                        activeColor: Colors.greenAccent,
                        value: _useTouchId,
                        onChanged: (newVal) {
                          if (mounted) {
                            setState(() {
                              _useTouchId = newVal!;
                            });
                          }
                        },

                       
                      ),
                      SizedBox(width: size.width * 0.01),
                      const Text(
                        'Biometric login',
                      )
                    ]),
              SizedBox(
                height: size.height * 0.04,
              ),
              GestureDetector(
                onTap: () {
                  if (checkFields()) {
                    if (_useTouchId) {
                      _authenticaterero();
                      AuthService().signIn(email, password, context);
                    } else {
                      AuthService().signIn(email, password, context);
                    }
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
                      child:  Text(
                        'LOGIN',
                        style:  TextStyle(
                            color: Colors.white, fontFamily: 'Trueno'),
                      ),
                    ),
                  ),
                 
                ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('New to Terry?'),
              const  SizedBox(width: 5.0),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>   MailScreen(
                              
                              )));
                    },
                    child: Text('Register',
                        style: TextStyle(
                            color: greenColor,
                            fontFamily: 'Trueno',
                            decoration: TextDecoration.underline)))
              ])
            ],
          ),
        ),
      ),
    ));
  }
}

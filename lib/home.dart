import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'loginpage.dart';

class HomePage extends StatelessWidget {
   HomePage({Key? key}) : super(key: key);
final _auth=FirebaseAuth.instance;
Color greenColor = const Color(0xFF00AF19);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Text('Home screen',style: TextStyle(color: greenColor,fontWeight: FontWeight.w700,fontSize: 35),),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenColor,
        onPressed: ()async {
          await _auth.signOut();
          Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child:const  Icon(Icons.logout,),
      ),
    );
  }
}

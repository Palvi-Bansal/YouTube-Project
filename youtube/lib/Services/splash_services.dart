import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube/Screens/home_screen.dart';
import 'package:youtube/Screens/post_screen.dart';

class SplashServices{

  void isHomeScreen(BuildContext context)
  {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if(user!= null){
      Timer(const Duration(seconds: 2), ()
      {
        Navigator.push(context, MaterialPageRoute
          (builder: (context) => const PostScreen()));
      });
    } else {
      Timer(const Duration(seconds: 2), () {
        Navigator.push(context, MaterialPageRoute
          (builder: (context) => const HomeScreen()));
      });
    }
  }
}
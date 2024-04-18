import 'package:flutter/material.dart';
import 'package:youtube/CustomFields/custom_button.dart';
import 'package:youtube/Screens/Authentication/sign_in_screen.dart';
import 'package:youtube/Screens/Authentication/sign_in_with_google.dart';
import 'package:youtube/Screens/Authentication/sign_in_with_phone.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier userCredential = ValueNotifier('');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Image.asset('images/images.png', height: 60, width: 60,),
        ),
        title: const Text('YouTube', style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            buttonText: 'SignIn with Email & Password',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignIn()),
              );
            },
          ),
          const SizedBox(height: 30),
          CustomButton(
            buttonText: 'SignIn with Phone No.',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const SignInWithPhone()),
              );
            },
          ),
          const SizedBox(height: 30),
          CustomButton(
            buttonText: 'SignIn with Google',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const GoogleSignInScreen()),
              );
            },
          ),

      ],
    ),
    );
  }


}

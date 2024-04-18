import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube/Screens/Authentication/sign_in_screen.dart';
import 'package:youtube/Services/utility.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
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
          title: const Text(
            'YouTube',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        actions: [
          IconButton(onPressed: (){
            auth.signOut().then((value) {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => const SignIn()));
            }).onError((error, stackTrace) {
              Utils().toastMessage(error.toString());

          });
          },
            icon: const Icon(Icons.logout_outlined),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome in my App', style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.red),),
          ],
        ),
      ),
    );
  }
}

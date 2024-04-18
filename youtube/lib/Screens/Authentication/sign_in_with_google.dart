import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({Key? key}) : super(key: key);

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  final auth = FirebaseAuth.instance;
  ValueNotifier userCredential = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    signIn();
  }

  Future<void> signIn() async {
    userCredential.value = await signInWithGoogle();
    if (userCredential.value != null) {
      return userCredential.value.user!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: userCredential,
        builder: (context, value, child) {
          if (userCredential.value == '' || userCredential.value == null) {
            return const Center(
              child: CircularProgressIndicator(), // Show loading indicator
            );
          } else {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.5, color: Colors.black54),
                    ),
                    child: Image.network(
                      userCredential.value.user!.photoURL.toString(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userCredential.value.user!.displayName.toString(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userCredential.value.user!.email.toString(),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () async {
                        bool result = await signOutFromGoogle();
                        if (result) userCredential.value = '';
                      },
                      child: const Text('Logout'))
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      return 'exception->$e';
    }
  }

  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}

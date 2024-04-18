import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube/Screens/forgot_password.dart';
import 'package:youtube/Screens/home_screen.dart';
import 'package:youtube/Screens/post_screen.dart';
import 'package:youtube/Screens/sign_up.dart';
import 'package:youtube/Services/utility.dart';
import 'package:youtube/CustomFields/custom_button.dart';
import 'package:youtube/CustomFields/custom_text_form_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordToggle = true;
  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  void dispose()
  {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  void signin(){
    setState(() {
      loading = true;
    });
    auth.signInWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
    ).then((value){
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => const PostScreen())
      );
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace){
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }
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
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        actions: [
          IconButton(onPressed: (){
            auth.signOut().then((value) {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
            }).onError((error, stackTrace) {
              Utils().toastMessage(error.toString());
            });
          },
            icon: const Icon(Icons.logout_outlined),
          ),
          const SizedBox(width: 10),
      ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.red],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                Container(
                  height: 500,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 25),
                      CustomTextFormField(
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        onChanged: (value) {},
                        validator: (value) {
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value!);
                          if (value.isEmpty) {
                            return '''Email is required''';
                          } else if (!emailValid) {
                            return '''Enter Valid Email''';
                          } else if (!value.endsWith('.com')) {
                            return '''Email must be from valid domain''';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        label: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordController,
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '''Password is required''';
                          } else if (value.length < 6 || value.length > 8) {
                            return '''Password should be between 6 to 8 characters''';
                          } else if (!_containsLowerCase(value)) {
                            return '''Password should contain at least one lowercase letter''';
                          } else if (!_containsUpperCase(value)) {
                            return '''Password should contain at least one uppercase letter''';
                          } else if (!_containsDigit(value)) {
                            return '''Password should contain at least one digit''';
                          } else if (!_containsSpecialChar(value)) {
                            return '''Password should contain at least one special character''';
                          }
                          return null; // Validation passed
                        },
                        obscureText: passwordToggle,
                        onTogglePassword: () {
                          setState(() {
                            passwordToggle = !passwordToggle;
                          });
                        },
                      ),
                   GestureDetector(
                     onTap: () {
                       Navigator.pushReplacement(
                         context,
                         MaterialPageRoute(
                             builder: (context) => const ForgotPassword()),
                       );
                     },
                     child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontSize:15,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                   ),
                      const SizedBox(height: 25),
                      CustomButton(
                        loading: loading,
                        buttonText: 'SUBMIT',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signin();
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signup()),
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Do not have account? ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              TextSpan(
                                text: 'Signup now',
                                style:
                                    TextStyle(color: Colors.red, fontSize:15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _containsLowerCase(String value) {
    return value.contains(RegExp(r'[a-z]'));
  }

  bool _containsUpperCase(String value) {
    return value.contains(RegExp(r'[A-Z]'));
  }

  bool _containsDigit(String value) {
    return value.contains(RegExp(r'\d'));
  }

  bool _containsSpecialChar(String value) {
    return value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }
}

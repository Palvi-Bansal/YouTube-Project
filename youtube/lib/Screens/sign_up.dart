import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube/Screens/Authentication/sign_in_screen.dart';
import 'package:youtube/Services/utility.dart';
import 'package:youtube/CustomFields/custom_button.dart';
import 'package:youtube/CustomFields/custom_text_form_field.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordToggle = true;
  bool confirmPasswordToggle = true;
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

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
          )),
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white70, Colors.red],
            ),
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
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
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 25),
                      CustomTextFormField(
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        onChanged: (value) {},
                        validator: (value) {
                          bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value!);
                          if (value.isEmpty) {
                            return '''Email is required''';
                          }
                          else if (!emailValid) {
                            return '''Enter Valid Email''';
                          }
                          else if(!value.endsWith('.com')){
                            return '''Email must be from valid domain''';
                          }
                          else {
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
                            return '''Password should be between 6 and 8 characters''';
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
                      const SizedBox(height: 25),
                      CustomButton(
                        loading: loading,
                        buttonText: 'REGISTER',
                        onPressed: () {
                          if (_formKey.currentState!.validate())
                          {
                            setState(() {
                              loading = true;
                            });
                            auth.createUserWithEmailAndPassword(
                                email: emailController.text.toString(),
                                password: passwordController.text.toString())
                                .then((value) {
                              setState(() {
                                loading = false;
                              });
                            }).onError((error, stackTrace) {
                              Utils().toastMessage(error.toString());
                              setState(() {
                                loading = false;
                              });
                            });
                          }
                          emailController.clear();
                          passwordController.clear();
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignIn()),
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Have an Account? ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              TextSpan(
                                text: 'Sign in',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    ),
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

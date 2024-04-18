import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube/CustomFields/custom_button.dart';
import 'package:youtube/CustomFields/custom_text_form_field.dart';
import 'package:youtube/Screens/Authentication/verify_code.dart';
import 'package:youtube/Screens/home_screen.dart';
import 'package:youtube/Services/utility.dart';

class SignInWithPhone extends StatefulWidget {
  const SignInWithPhone({super.key});

  @override
  State<SignInWithPhone> createState() => _SignInWithPhoneState();
}

class _SignInWithPhoneState extends State<SignInWithPhone> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override

  void dispose()
  {
  phoneController.dispose();
    super.dispose();
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
          IconButton(
            onPressed: (){
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
                      'Sign In With Number',
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 25),
                    CustomTextFormField(
                      label: 'Phone No.',
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      onChanged: (value) {},
                      validator: (value) {
                        bool phoneValid = RegExp(r"0-9").hasMatch(value!);
                        if (value.isEmpty) {
                          return '''Phone Number is required''';
                        }
                        else if (!phoneValid) {
                          return '''Enter Valid Phone Number''';
                        }
                        else if (value.length==10) {
                          return '''Phone Number should be of 10 digits''';
                        }
                        else{
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 25),
                    CustomButton(
                      loading: loading,
                      buttonText: 'SUBMIT',
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        auth.verifyPhoneNumber(
                            phoneNumber: phoneController.text,
                            verificationCompleted: (_){
                              setState(() {
                                loading = false;
                              });
                            },
                            verificationFailed: (e){
                              Utils().toastMessage(e.toString());
                            },
                            codeSent: (String verificationId, int? token){
                              Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VerifyCodeScreen(verificationId: verificationId,)
                              ));
                              setState(() {
                                loading = false;
                              });
                            },
                            codeAutoRetrievalTimeout: (e){
                              Utils().toastMessage(e.toString());
                              setState(() {
                                loading = false;
                              });
                            },
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    const Text('NOTE: Phone number must start with your country code.',
                        style:TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
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
}

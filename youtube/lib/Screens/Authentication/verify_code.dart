import 'package:firebase_auth/firebase_auth.dart';
import'package:flutter/material.dart';
import 'package:youtube/CustomFields/custom_button.dart';
import 'package:youtube/CustomFields/custom_text_form_field.dart';
import 'package:youtube/Screens/home_screen.dart';
import 'package:youtube/Screens/post_screen.dart';
import 'package:youtube/Services/utility.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController verifyCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override

  void dispose()
  {
    verifyCodeController.dispose();
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
                        'Verification Screen',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 25),
                      CustomTextFormField(
                        label: 'Enter 6 Digit Code',
                        keyboardType: TextInputType.phone,
                        controller: verifyCodeController,
                        onChanged: (value) {},
                        validator: (value) {
                          bool codeValid = RegExp(r"0-9").hasMatch(value!);
                          if (value.isEmpty) {
                            return '''Code is required''';
                          }
                          else if (!codeValid) {
                            return '''Enter Valid Code''';
                          }
                          else if (value.length==6) {
                            return '''Code should be of 6 digits''';
                          }
                          else{
                            return null;
                          }
                        },
                      ),

                      const SizedBox(height: 25),
                      CustomButton(
                        buttonText: 'VERIFY',
                        loading: loading,
                        onPressed: () async{
                          setState(() {
                            loading = true;
                          });
                          final credential = PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: verifyCodeController.text.toString(),
                          );
                          try{
                            await auth.signInWithCredential(credential);
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PostScreen()));

                          } catch(e){
                            setState(() {
                              loading = false;
                            });
                            Utils().toastMessage(e.toString());
                          }
                        },
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
}

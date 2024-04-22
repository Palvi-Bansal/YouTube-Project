import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:youtube/CustomFields/custom_button.dart';
import 'package:youtube/Services/utility.dart';
import 'package:youtube/download.dart';


class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key});

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  final auth = FirebaseAuth.instance;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles();
    if(result == null){
      return;
    }
      pickedFile = result.files.first;

  }

  Future uploadFile() async
  {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');

    setState(() {
      uploadTask = null;
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
                      builder: (context) => const DownloadFileScreen()));
            }).onError((error, stackTrace) {
              Utils().toastMessage(error.toString());
            });
          },
            icon: const Icon(Icons.download_outlined),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(pickedFile != null)
                Expanded(
                  child: Container(
                    color: Colors.blue[100],
                    child: Center(
                      child: Text(pickedFile!.name),
                      /*Image.file(
                      File(pickedFile!.path!),
                      width: double.infinity,
                      fit: BoxFit.cover,),*/
                    ),
                  ),
                ),
            const SizedBox(height: 32),
            CustomButton(
              buttonText: 'Select File',
              onPressed: selectFile,
            ),
            const SizedBox(height: 32),
            CustomButton(
              buttonText: 'Upload File',
              onPressed: uploadFile,
            ),
            const SizedBox(height: 32),
            buildProgress(),
          ],
        ),
      ),
    );
  }
  Widget buildProgress() => StreamBuilder<TaskSnapshot>
    (
    stream: uploadTask?.snapshotEvents,
    builder: (context, snapshot){
      if(snapshot.hasData){
        final data = snapshot.data!;
        double progress = data.bytesTransferred/data.totalBytes;
        return SizedBox(
          height: 50,
          child: Stack(
            fit: StackFit.expand,
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey,
                color: Colors.green,
              ),
              Center(
                child: Text(
                  '${(100 * progress).roundToDouble()}%',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }
      else
        {
          return const SizedBox(height: 50);
        }
    });
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube/Screens/home_screen.dart';
import 'package:youtube/Services/utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube/upload_file.dart';

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
          IconButton(onPressed: () {
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
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 20,
        itemBuilder: (context, index) =>
            Card(
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                leading: buildImage(index),
                title: Text(
                  'Live Post'
                      ' ${index + 1}',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context)=> const UploadFileScreen()));
        },
        backgroundColor: Colors.red,
        child: const Icon(
            Icons.upload_outlined,
            color: Colors.white,
        ),
      ),
    );
  }
    Widget buildImage(int index) =>
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            key: UniqueKey(),
            imageUrl: 'https://source.unsplash.com/random?sig=$index',
            height: 50,
            width: 50,
            fit: BoxFit.cover,
            maxHeightDiskCache: 75,
            placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
          ),
        );
}

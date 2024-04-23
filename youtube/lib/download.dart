import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube/Services/utility.dart';
import 'package:youtube/upload_file.dart';
import 'package:gallery_saver/gallery_saver.dart';

class DownloadFileScreen extends StatefulWidget {
  const DownloadFileScreen({super.key});

  @override
  State<DownloadFileScreen> createState() => _DownloadFileScreenState();
}

class _DownloadFileScreenState extends State<DownloadFileScreen> {
  final auth = FirebaseAuth.instance;
  late Future<ListResult> futureFiles;
  Map<int,double> downloadProgress = {};
  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseStorage.instance.ref('/files').listAll();
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
                        builder: (context) => const UploadFileScreen()));
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
              icon: const Icon(Icons.upload_outlined),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: FutureBuilder<ListResult>(
          future: futureFiles,
          builder: (context, snapshot)
          {
            if(snapshot.hasData)
            {
              final files = snapshot.data!.items;

              return ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index){
                  final file = files[index];
                  double? progress = downloadProgress[index];
                  return ListTile(
                    title: Text(file.name),
                    subtitle: progress != null
                        ? LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.black,
                    ): null,
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.download,
                        color: Colors.black,
                      ),
                      onPressed: () => downloadFile(index, file),
                    ),
                  );
                },
              );
            }
            else if(snapshot.hasError)
            {
              return const Center(
                child: Text('Error Occurred'),
              );
            }
            else{
              return const Center(
                child: CircularProgressIndicator(),);
            }
          },
        )
    );
  }
  Future downloadFile(int index, Reference ref) async{
    final url = await ref.getDownloadURL();
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/${ref.name}';
    await Dio().download(
        url,
        path,
        onReceiveProgress: (received, total){
          double progress = received/total;

          setState(() {
            downloadProgress[index] = progress;
          });
        });
    if(url.contains('.mp4')){
      await GallerySaver.saveVideo(path, toDcim: true);
    }
    else if(url.contains('.jpg')){
      await GallerySaver.saveImage(path, toDcim: true);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Download ${ref.name}')),
    );
  }
}

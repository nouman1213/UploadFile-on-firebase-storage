import 'dart:io';

import 'package:firebas_storage/service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class uploadfile extends StatefulWidget {
  @override
  _uploadfileState createState() => _uploadfileState();
}

class _uploadfileState extends State<uploadfile> {
  File? file;
  UploadTask? task;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;

    setState(() {
      file = File(path);
    });
  }

  uploadfile() {
    if (file == null) return;
    final fileName = basename(file!.path);
    final destination = 'files/$fileName';
    task = fbStorage.uploadfile(destination, file!);
    setState(() {});
  }

  Widget uploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final uploadPercent = (progress * 100).toStringAsFixed(2);
          return Text('$uploadPercent %');
        } else {
          return Container();
        }
      });

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            selectFile();
          },
          child: Text("Select Files"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.amber),
          ),
        ),
        Text(fileName),
        ElevatedButton(
          onPressed: () {
            uploadfile();
          },
          child: Text("Upload Files"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.amber),
          ),
        ),
        task != null ? uploadStatus(task!) : Container(),
      ],
    );
  }
}

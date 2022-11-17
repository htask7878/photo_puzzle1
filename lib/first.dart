import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_puzzle/assetimage.dart';
import 'package:photo_puzzle/runningpage.dart';

class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
 static String dr_path = "";
  XFile? img;
  ImagePicker imagePicker = ImagePicker();
  bool b = false;

  folder() async {
    var directory = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS) +
        "/photo";
    Directory dr = Directory(directory);

    if (await dr.exists()) {
      print("Already create");
    } else {
      dr.create();
    }
    dr_path = dr.path;
  }

  @override
  void initState() {
    super.initState();
    folder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                img = await imagePicker.pickImage(
                                    source: ImageSource.gallery);
                                insert();
                                setState(() {});
                                print("Gallery");
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return runningpage(null,dr_path);
                                },));

                              },
                              child: Text("Gallery")),
                          ElevatedButton(
                              onPressed: () async {
                                img = await imagePicker.pickImage(
                                    source: ImageSource.camera);
                                insert();
                                setState(() {});
                                print("camera");
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return runningpage(null,dr_path);
                                },));
                              },
                              child: Text("Camera")),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.add_a_photo_outlined)),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return imagepage(dr_path);
              },));
            }, child: Text("Select App Image"))
          ],
        ),
      ),
    );
  }

  insert() async {
    DateTime datetime = DateTime.now();
    String setin = "${datetime.year.toString() + datetime.month.toString() + datetime.day.toString() + datetime.hour.toString() + datetime.minute.toString() + datetime.second.toString() + datetime.microsecond.toString()}";
    String image1 = "${dr_path}/${setin}.jpg";
    File Createfile = File(image1);

    if (!await Createfile.exists()) {
      await Createfile.create();
      await Createfile.writeAsBytes(await img!.readAsBytes());
    }
  }
}

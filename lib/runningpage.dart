import 'dart:typed_data';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;

class runningpage extends StatefulWidget {
  String? ph;
  String? dr_path;///

  runningpage(this.ph, this.dr_path);

  @override
  State<runningpage> createState() => _runningpageState();
}

class _runningpageState extends State<runningpage> {
  int div = 3;
  List<Image> im = [];
  List<Image> temil = [];

  List<Image> splitImage(List<int> input) {
    // convert image to image from image package
    imglib.Image? image = imglib.decodeImage(input);

    int x = 0, y = 0;
    int width = (image!.width / div).round();
    int height = (image.height / div).round();

    // split image to parts
    List<imglib.Image> parts = [];
    for (int i = 0; i < div; i++) {
      for (int j = 0; j < div; j++) {
        parts.add(imglib.copyCrop(image, x, y, width, height));
        x += width;
      }
      x = 0;
      y += height;
    }

    // convert image from image package to Image Widget to display
    List<Image> output = [];
    for (var img in parts) {
      //
      output.add(Image.memory(Uint8List.fromList(imglib.encodeJpg(img))));
    }

    return output;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');
    DateTime datetime = DateTime.now();

    String setin =
        "${datetime.year.toString() + datetime.month.toString() + datetime.day.toString() + datetime.hour.toString() + datetime.minute.toString() + datetime.second.toString() + datetime.microsecond.toString()}";
    String imagepath = "${widget.dr_path}/${setin}.jpg";
    final file = File('$imagepath');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  declareimage() async {
    File f = await getImageFileFromAssets('myimage/${widget.ph}');
    List<int> imagelist = await f.readAsBytes();
    im = await splitImage(imagelist);
    temil.addAll(im);
    im.shuffle();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    declareimage();
  }

  List<bool> isselect = List.filled(9, false);
  bool winimage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //todo mr000142indy
      appBar: AppBar(),
      body: winimage
          ? Column(
            children: [
              Image(image: AssetImage("myimage/${widget.ph}")),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      winimage = false;
                      im.shuffle();
                    });
                  },
                  child: Text("Reset"))
            ],
          )
          : GridView.builder(
              itemCount: im.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  crossAxisCount: div),
              itemBuilder: (context, index) {
                return isselect[index]
                    ? DragTarget(
                        onAccept: (int data) {
                          setState(() {
                            print(index);
                            print(data);
                            Image timg = im[data];
                            im[data] = im[index];
                            im[index] = timg;
                            if (listEquals(temil, im)) {
                              print("You are winner");
                              winimage = true;
                            }
                          });
                        },
                        builder:
                            (context, candidateData, rejectedData) {
                          return Container(
                            child: im[index],
                          );
                        },
                      )
                    : Draggable(
                        onDraggableCanceled: (velocity, offset) {
                          setState(() {
                            isselect = List.filled(div * div, false);
                          });
                        },
                        onDragStarted: () {
                          setState(() {
                            for (int i = 0; i < isselect.length; i++) {
                              if (index != i) {
                                isselect[i] = true;
                              }
                            }
                            print(isselect);
                          });
                        },
                        onDragEnd: (details) {
                          setState(() {
                            isselect = List.filled(div * div, false);
                          });
                        },
                        data: index,
                        child: Container(
                          child: im[index],
                        ),
                        feedback: Container(
                            height: 100, width: 100, child: im[index]),
                      );
              },
            ),
    );
  }
}

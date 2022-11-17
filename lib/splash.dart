import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'first.dart';

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState() {
    super.initState();
    loading();
  }

  loading() async {
    var status = await Permission.storage.status;
    if(status.isDenied)
    {
      await [Permission.storage].request();
    }
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return first();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("Photo")),
        color: Color(0xffFFFFFF),
      ),
    );
  }
}
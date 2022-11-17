import 'package:flutter/material.dart';
import 'runningpage.dart';

class imagepage extends StatefulWidget {
  String? dr_path;
  imagepage(this.dr_path);

  @override
  State<imagepage> createState() => _imagepageState();
}

class _imagepageState extends State<imagepage> {
  List ph = [
    "a1.jpg",
    "a2.jpg",
    "a3.jpg",
    "a4.jpg",
    "a5.jpg",
    "a6.jpg",
    "a7.jpg",
    "a8.jpg",
    "a9.jpg",
    "a10.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body:GridView.builder(
        itemCount: ph.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 3, mainAxisSpacing: 3),
        itemBuilder: (context, index) {
          return Container(
            child: InkWell(onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return runningpage(ph[index],widget.dr_path);
              },));
            },),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("myimage/${ph[index]}"), fit: BoxFit.fill),
            ),
          );
        },///
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({
    Key? key,
    required this.titleSection,
    required this.buttonSection,
    required this.descriptionSection,
  }) : super(key: key);

  final Widget titleSection;
  final Widget buttonSection;
  final Widget descriptionSection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes notes :"),
      ),
      body: ListView(
          children: [Stack(

            children: [Container(width: 600,height: 240,child: Center(child:CircularProgressIndicator()),),
              Image.network("https://cdn.pixabay.com/photo/2017/09/22/19/48/tomato-2776824_1280.jpg")],),
            titleSection,
            buttonSection,
            descriptionSection]
      ),
    );
  }
}
import 'package:calcul_moyenne/noteListScreen.dart';
import 'package:flutter/material.dart';

import 'package:calcul_moyenne/noteListScreen.dart';
import 'package:calcul_moyenne/noteScreen.dart';
import 'noteListScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);





  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget titleSection =   Container(padding: const EdgeInsets.all(15),child: Row(
      children: [Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Text("Pizza facile",style: TextStyle(fontSize: 20)),
          ),Text("Par Sami ROUDJI",style: TextStyle(color: Colors.grey[500]))],
      ))],
    ));
    Widget buttonSection = Container(padding:const EdgeInsets.all(8),
        child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButtonColumn(Colors.blue, Icons.ad_units_outlined, "Commente"),
              _buildButtonColumn(Colors.blue, Icons.ad_units_outlined, "Share")
            ]));
    Widget descriptionSection = Container(padding: const EdgeInsets.all(24),child: Text("Lorem ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin profe"
        "ssor at Hampden-Sydney College in Virginia, looked up one of "
        "the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going throug"
        "h the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from",softWrap: true,style: TextStyle(fontSize: 20),));
    return MaterialApp(
        title: 'Ma premiere app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NoteListScreen()
    );
  }
}



Column _buildButtonColumn(Color color, IconData icon,String label){
  return Column(children: [Container( padding: const EdgeInsets.only(bottom: 8),child:Icon(icon,color: color)), Text(label,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color:color))]);
}



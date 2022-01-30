import 'package:calcul_moyenne/noteListScreen.dart';
import 'package:flutter/material.dart';

class Tutoriel extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ma moyenne facile"),
        ),
        body: Padding(padding: const EdgeInsets.all(20),
          child: Column(children: [Text("Apprendre à utiliser Ma moyenne facile :", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.blue,decoration: TextDecoration.underline,
            decorationColor: Colors.black,)),
                                  SizedBox(height: 20,),
                                  Align(alignment:Alignment.topLeft,child:Text("1- Ajouter vos matières",style: TextStyle(fontSize: 22),)),
                                  SizedBox(height: 30,),
                                  Text("2- Cliquez sur les matières de votre choix et ajoutez y vos notes",style: TextStyle(fontSize: 22)),
                                  SizedBox(height: 30,),
                                  Text("3- Vos moyennes sont calculés automatiquement par matière,"
                                      " votre moyenne général s'affiche dans la page d'accueil de l'application",style: TextStyle(fontSize: 22)),
                                  SizedBox(height: 30,),
                                  Text("4- Pour supprimer une matière ou une note faites flisser à droite ou à gauche l'element",style: TextStyle(fontSize: 22))
          ])

        )
    );
  }
}
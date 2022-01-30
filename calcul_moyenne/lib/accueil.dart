import 'package:calcul_moyenne/MatiereBDD.dart';
import 'package:calcul_moyenne/noteListScreen.dart';
import 'package:calcul_moyenne/tutoriel.dart';
import 'package:flutter/material.dart';

import 'Matiere.dart';

class Accueil extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ma moyenne facile"),
      ),
      body: Padding(padding: const EdgeInsets.all(20),
      child: FutureBuilder<List<Matiere>>(
        future : MatiereBDD.instance.matieres(),
        builder: (BuildContext context, AsyncSnapshot<List<Matiere>> snapshot) {
          double somme = 0;
          double sum_coef = 0;

          var taille = 0;
          if(snapshot.hasData) {
            taille = snapshot.data!.length;
            for (int i = 0; i < taille; i++) {
               somme+=(snapshot.data![i].moyenne/20)*snapshot.data![i].coef;
              sum_coef += snapshot.data![i].coef;
            }
            print("DATA");
          }
          print("ICI");
          print(somme);
          double moyenne = (somme/sum_coef)*20;
          //moyenne = 7;
          var moy = "?/20";
          if(taille>0)
            moy = moyenne.toStringAsPrecision(4) + "/20";
          return Column(
          children :
          [Text("Ta Moyenne", style: TextStyle(height: 2, fontSize: 55)),
          Text(moy.toString(), style: TextStyle(height: 2, fontSize: 75)),
          SizedBox(height: 70,),
          Column(
          children: [
                  ElevatedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) =>  NoteListScreen()));}, style: ElevatedButton.styleFrom(shape:StadiumBorder(),padding: EdgeInsets.all(13)), child: Row(mainAxisAlignment : MainAxisAlignment.center,
            children: [Text("Mes Matières",style: TextStyle(fontSize: 22),)],)),
            SizedBox(height: 25,),
            ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(shape:StadiumBorder(),padding: EdgeInsets.all(13)), child: Row(mainAxisAlignment : MainAxisAlignment.center,
            children: [Text("Mes Paramètres",style: TextStyle(fontSize: 22),)],)),
            SizedBox(height: 25,),
            ElevatedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> Tutoriel()));}, style: ElevatedButton.styleFrom(shape:StadiumBorder(), primary: Colors.black38,padding: EdgeInsets.all(13)), child: Row(mainAxisAlignment : MainAxisAlignment.center,
            children: [Text("Tutoriel",style: TextStyle(fontSize: 22),)],))

            ],)]
            );
    }

      ),
    )
    );
  }
}
import 'package:calcul_moyenne/MatiereBDD.dart';
import 'package:calcul_moyenne/NoteDataBase.dart';
import 'package:calcul_moyenne/noteListScreen.dart';
import 'package:flutter/material.dart';

import 'Matiere.dart';
import 'Note.dart';

class NoteMatiere extends StatefulWidget {
  const NoteMatiere( {Key? key, required this.matiere}) : super(key: key);
  final Matiere matiere;

  @override
  State<NoteMatiere> createState() => _NoteMatiereState();
}

class _NoteMatiereState extends State<NoteMatiere> {
  createAddNote(BuildContext context){

    TextEditingController noteController = TextEditingController();
    TextEditingController coeffController = TextEditingController();
    TextEditingController maxnoteController = TextEditingController();

    return showDialog(context: context, builder:(context){
      return AlertDialog(title:Text("Formulaire"),
        content: Column(children: [
          TextField( decoration: new InputDecoration(labelText: "Entrez votre note"), keyboardType: TextInputType.number,controller: noteController,),
          TextField( decoration: new InputDecoration(labelText: "Entrez le maximum de la note"),keyboardType: TextInputType.number,controller: maxnoteController),
          TextField( decoration: new InputDecoration(labelText: "Entrez le coefficient de votre note"), keyboardType: TextInputType.number,controller:coeffController)
        ],)
        ,actions: <Widget>[MaterialButton(
          elevation:5.0,child:Text("Valider"),onPressed: (){Navigator.of(context).pop("");
          setState(() {
              NoteDataBase.instance.insertRecipe(new Note(matiere : this.widget.matiere.id, note : double.parse(noteController.text.toString()),coef:double.parse(coeffController.text.toString()),note_max:double.parse(maxnoteController.text.toString())));
              double moyMatiere = double.parse(noteController.text.toString());

              moyMatiere = NoteDataBase.instance.getMoy();
              print("ROUDJI");
              print(moyMatiere);
              MatiereBDD.instance.updateMatiere(new Matiere(this.widget.matiere.id, 12, 1));
          })
          ;},)],);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(child : FutureBuilder<List<Note>>(
              future : NoteDataBase.instance.notesByMatiere(this.widget.matiere.id),
              builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
                print("Les Notes...");
                double somme = 0;
                double sum_coef = 0;
                  //return Center(child: CircularProgressIndicator());
                for(int i=0;i<snapshot.data!.length;i++){
                  somme+=(snapshot.data![i].note/snapshot.data![i].note_max)*snapshot.data![i].coef;
                  sum_coef += snapshot.data![i].coef;
                }
                double moyenne = (somme/sum_coef)*20;

                  return Text(this.widget.matiere.id + " (" + moyenne.toStringAsPrecision(4) + ")");

              }
          ), padding: const EdgeInsets.all(10),
          ),
        ),
        body: Padding(child : FutureBuilder<List<Note>>(
            future : NoteDataBase.instance.notesByMatiere(this.widget.matiere.id),
            builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
              print("Les Notes...");
              if (snapshot.hasData) {
                List<Note>? recipes = snapshot.data;

                return ListView.builder(
                  itemCount: recipes!.length,
                  itemBuilder: (context, index){
                    final recipe = recipes[index];
                    return Dismissible(key: UniqueKey(),
                        onDismissed: (direction){
                         setState(() {
                            NoteDataBase.instance.deleteRecipe(recipe.id!);

                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Evaluation ${recipe.id} supprimé")));
                        },
                        background: Container(color: Colors.red,child: Row(children: [Text("Supprimer note -->"),Spacer(),Text("<-- Supprimer note")]),),
                        child: NoteItemWidget(recipe: recipe));
                  },
                );
              } else {
                //return Center(child: CircularProgressIndicator());
                return Center(child: Text("Chargement"),);
              }
            }
        ), padding: const EdgeInsets.all(10),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
                createAddNote(context);
            },
            child: Icon(Icons.add)
        )


    );
  }
}

class NoteItemWidget extends StatelessWidget {
  const NoteItemWidget({required this.recipe})
      : super();
  final Note recipe;
  onDl(){

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap : () {},child: Card(
        elevation: 5,
        color: Colors.cyanAccent,

        child: Row(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Evaluation",style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.3)),
                  Row( children : [Text("Note : "),Text(recipe.note.toString() + "/" + recipe.note_max.toString()
                      ,style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5))])
                ],),
              Spacer(),
              Text("Coefficient : " + recipe.coef.toString()),
            ]
        )
    ));
  }
}
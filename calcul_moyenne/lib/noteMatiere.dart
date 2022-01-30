import 'package:calcul_moyenne/MatiereBDD.dart';
import 'package:calcul_moyenne/NoteDataBase.dart';
import 'package:calcul_moyenne/accueil.dart';
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
  final _formKey = GlobalKey<FormState>();

  final _nameFormKey = GlobalKey<FormState>();
  createAddVerif(BuildContext context){
    TextEditingController noteController = TextEditingController();
    TextEditingController coeffController = TextEditingController();
    TextEditingController maxnoteController = TextEditingController();
    TextEditingController titleController = TextEditingController();

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
              onWillPop: () async {
              Navigator.pop(context);

              return false;
              },
              child: AlertDialog(
                title: Text('Ajouter une note'),
                content: Form(
                  key: _nameFormKey,
                  child: Column(children: [TextFormField(decoration: new InputDecoration(labelText: "Entrez votre note"), keyboardType: TextInputType.number,
                    controller: noteController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vous devez rentrer une note !';
                      }
                      return null;
                    },
                  ),TextFormField(decoration: new InputDecoration(labelText: "Entrez le maximum de la note"), keyboardType: TextInputType.number,
                    controller: maxnoteController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vous devez rentrer le maximum de la note !';
                      }
                      return null;
                    },
                  ),
                  TextFormField(decoration: new InputDecoration(labelText: "Entrez le coefficient (coeff 1 par defaut)"), keyboardType: TextInputType.number,
                    controller: coeffController,
                  ),
                  ],)
                ),
                actions: <Widget>[
                  MaterialButton(
                    elevation:5.0,child:Text("Ajouter"),onPressed: (){
                    if (_nameFormKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      setState(() {
                        noteController.text = noteController.text.replaceAll(",", ".");
                        maxnoteController.text = maxnoteController.text.replaceAll(",", ".");
                        if(coeffController.text == "")
                          coeffController.text = "1";
                        NoteDataBase.instance.insertRecipe(new Note(matiere : this.widget.matiere.id, note : double.parse(noteController.text.toString()),coef:double.parse(coeffController.text.toString()),note_max:double.parse(maxnoteController.text.toString())));
                        double moyMatiere = double.parse(noteController.text.toString());
                        print("ROUDJI 2");

                        // moyMatiere = NoteDataBase.instance.getMoy();
                        print("ROUDJI 3");
                        print(moyMatiere);

                      });
                    }

                  }
                    ,)
                ],
              ));
        });
  }
  createAddNote(BuildContext context){

    TextEditingController noteController = TextEditingController();
    TextEditingController coeffController = TextEditingController();
    TextEditingController maxnoteController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    return showDialog(context: context, builder:(context){
      return AlertDialog(title:Text("Formulaire"),
        key: _formKey,
        content: Column(children: [
          TextField( decoration: new InputDecoration(labelText: "Entrez votre note"), keyboardType: TextInputType.number,controller: noteController,),
          TextField( decoration: new InputDecoration(labelText: "Entrez le maximum de la note"),keyboardType: TextInputType.number,controller: maxnoteController),
          TextField( decoration: new InputDecoration(labelText: "Entrez le coefficient de votre note"), keyboardType: TextInputType.number,controller:coeffController),
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(20.0)))),
            validator: (value) {
              print("JM");
              return "okk";
              if (value!.isEmpty) {
                return 'Please enter a title';
              }
              return "ttt";
            },
          ),],)
        ,actions: <Widget>[MaterialButton(
          elevation:5.0,child:Text("Ajouter"),onPressed: (){
            if(_formKey.currentState != null) {
              print("ih");
              if (_formKey.currentState!.validate()) {
                print("ah");
              }

            }else {
              print("oh");
            }


      Navigator.of(context).pop();
      setState(() {
      if(coeffController.text == "")
      coeffController.text = "1";
      NoteDataBase.instance.insertRecipe(new Note(matiere : this.widget.matiere.id, note : double.parse(noteController.text.toString()),coef:double.parse(coeffController.text.toString()),note_max:double.parse(maxnoteController.text.toString())));
      double moyMatiere = double.parse(noteController.text.toString());
      print("ROUDJI 2");

      // moyMatiere = NoteDataBase.instance.getMoy();
      print("ROUDJI 3");
      print(moyMatiere);

      });
      }
          ,)],);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => NoteListScreen()),)
            .then((value) => setState(() {}));
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () =>
                {

                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NoteListScreen()),)
                      .then((value) => setState(() {}))
                }),
            title: Padding(child : FutureBuilder<List<Note>>(
                future : NoteDataBase.instance.notesByMatiere(this.widget.matiere.id),
                builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {

                  double somme = 0;
                  double sum_coef = 0;
                  double moyenne = 0;
                  String moy = "?";
                  //return Center(child: CircularProgressIndicator());
                  if(snapshot.hasData) {
                    for (int i = 0; i < snapshot.data!.length; i++) {
                      somme += (snapshot.data![i].note /
                          snapshot.data![i].note_max) * snapshot.data![i].coef;
                      sum_coef += snapshot.data![i].coef;
                    }
                     moyenne = (somme/sum_coef)*20;
                    print("UPDATE");
                    print(this.widget.matiere.id);
                    if(!moyenne.isNaN) {
                      MatiereBDD.instance.updateMatiere(new Matiere(this.widget.matiere.id, moyenne, 1));
                      moy = moyenne.toStringAsPrecision(4);
                    }
                    else{
                      MatiereBDD.instance.updateMatiere(new Matiere(this.widget.matiere.id, 0, 1));
                    }
                  }

                  return Text(this.widget.matiere.id + " (" + moy + "/20)");

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
                              MatiereBDD.instance.updateMatiere(new Matiere(this.widget.matiere.id, 14, 1));

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
                createAddVerif(context);
                // createAddNote(context);
              },
              child: Icon(Icons.add)
          )


      ),
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


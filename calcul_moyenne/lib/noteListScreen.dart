import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Note.dart';
class NoteListScreen extends StatefulWidget{
  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final List<Note> recipes = [];

  createAlertDialiog(BuildContext context){
    TextEditingController customController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    TextEditingController coeffController = TextEditingController();
    TextEditingController maxnoteController = TextEditingController();

    return showDialog(context: context, builder:(context){
      return AlertDialog(title:Text("La matièredd"),
        content: Column(children: [
          TextField(decoration: new InputDecoration(labelText: "Entre la matière"), keyboardType: TextInputType.text,controller: customController,),
          TextField( decoration: new InputDecoration(labelText: "Enter votre note"), keyboardType: TextInputType.number,controller: noteController,),
          TextField( decoration: new InputDecoration(labelText: "Enter le maximum de la note"),keyboardType: TextInputType.number,controller: maxnoteController),
          TextField( decoration: new InputDecoration(labelText: "Entrer le coefficient de votre note"), keyboardType: TextInputType.number,controller:coeffController)
        ],)
        ,actions: <Widget>[MaterialButton(
          elevation:5.0,child:Text("Submit "),onPressed: (){Navigator.of(context).pop(customController.text.toString()); setState(() {
          recipes.add(new Note(int.parse(noteController.text.toString()),customController.text.toString(),int.parse(coeffController.text.toString()),int.parse(maxnoteController.text.toString())));
          });},)],);
    });
  }
  @override
  Widget build(BuildContext context) {
    double somme = 0;
    double sum_coef = 0;
    for (var i = 0; i < recipes.length; i++) {
      somme+=(recipes[i].note/recipes[i].note_max)*recipes[i].coef;
      sum_coef += recipes[i].coef;
    }
    var moy = (somme/sum_coef)*20;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ma moyenne : "+moy.toStringAsFixed(2)),
      ),
      body:(ListView.builder(itemCount : recipes.length,itemBuilder: (context,index){
        return RecipeItemWidget(recipe : recipes[index]);
      })),
      floatingActionButton: FloatingActionButton(
      onPressed: (){
        setState(() {
         createAlertDialiog(context);
        });



      },
      child: Icon(Icons.add)
    ),
    );
  }
}
class RecipeItemWidget extends StatelessWidget{
  const RecipeItemWidget({required this.recipe}) : super();
  final Note recipe;
  @override
  Widget build(BuildContext context) {

    return GestureDetector( child :Card(
        elevation: 5,
        child:Row(
            children: [
              Column( crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(recipe.matiere),
                  Text("Note : " + recipe.note.toString() + "/" + recipe.note_max.toString())],)]
        )
    ));
  }

}



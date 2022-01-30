import 'package:calcul_moyenne/MatiereBDD.dart';
import 'package:calcul_moyenne/NoteDataBase.dart';
import 'package:calcul_moyenne/accueil.dart';
import 'package:calcul_moyenne/noteMatiere.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Matiere.dart';
import 'Note.dart';

class NoteListScreen extends StatefulWidget{
  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  String? notevalue = "Pas encore de note";
  final List<Note> recipes = [];
  double newvalue = 0;
  void yourFunction() async {
    var x =  await NoteDataBase.instance.recipes();
    print("Sami");
    print(x.length);
    double somme = 0;
    double sum_coef = 0;
    for(int i=0;i<recipes.length;i++){
      somme+=(recipes[i].note/recipes[i].note_max)*recipes[i].coef;
      sum_coef += recipes[i].coef;
    }
    double moyenne = (somme/sum_coef)*20;
    setNoteData(moyenne.toString());
    getNote();

  }
  createAlertDialiog(BuildContext context){
    TextEditingController customController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    TextEditingController coeffController = TextEditingController();
    TextEditingController maxnoteController = TextEditingController();

    return showDialog(context: context, builder:(context){
      return AlertDialog(title:Text("Formulaire"),
        content: Column(children: [
          TextField(decoration: new InputDecoration(labelText: "Entrez la matière"), keyboardType: TextInputType.text,controller: customController,),
          TextField( decoration: new InputDecoration(labelText: "Entrez votre note"), keyboardType: TextInputType.number,controller: noteController,),
          TextField( decoration: new InputDecoration(labelText: "Entrez le maximum de la note"),keyboardType: TextInputType.number,controller: maxnoteController),
          TextField( decoration: new InputDecoration(labelText: "Entrez le coefficient de votre note"), keyboardType: TextInputType.number,controller:coeffController)
        ],)
        ,actions: <Widget>[MaterialButton(
          elevation:5.0,child:Text("Valider"),onPressed: (){Navigator.of(context).pop(customController.text.toString()); setState(() {
          //recipes.add(new Note(customController.text.toString(),int.parse(noteController.text.toString()),int.parse(coeffController.text.toString()),int.parse(maxnoteController.text.toString())));


         // NoteDataBase.instance.insertRecipe(new Note(int.parse(noteController.text.toString()),int.parse(coeffController.text.toString()),int.parse(maxnoteController.text.toString())))

          });},)],);
    });
  }

  otherFunction(String oh) async {
    final String test = await MatiereBDD.instance.MatiereExist(oh);
    return test;
  }


  FormAddMatiere(BuildContext context){
    TextEditingController customController = TextEditingController();


    return showDialog(context: context, builder:(context){
      return AlertDialog(title:Text("Formulaire"),
        content: Column(children: [
          TextField(decoration: new InputDecoration(labelText: "Entrez la matière"), keyboardType: TextInputType.text,controller: customController,),
        ],)
        ,actions: <Widget>[MaterialButton(
          elevation:5.0,child:Text("Valider"),onPressed: (){Navigator.of(context).pop(customController.text.toString());
          setState(() {
          //recipes.add(new Note(customController.text.toString(),int.parse(noteController.text.toString()),int.parse(coeffController.text.toString()),int.parse(maxnoteController.text.toString())));

              MatiereBDD.instance.insertMatiere(new Matiere(customController.text, 0, 1));

        });},)],);
    });
  }
  @override
  void initState(){
    super.initState();
    getNote();
  }
  void test() async{
    final prefs = await SharedPreferences.getInstance();
     newvalue = prefs.getDouble('moyenne') ?? 10;

  }

  Future<void> setNoteData(notevalue) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("moy", notevalue);
  }

  void getNote() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    notevalue = pref.getString("moy");
    setState(() {

    });
  }
  /*@override
  List<Note> getAll(){
    List<Note> _list;
    Future<List<Note>> listFuture;
    listFuture = NoteDataBase.instance.recipes();
    listFuture.then((value){
      if(value!=null) value.forEach((item) => _list.add(item)));
    });

    return _list;
  }*/
  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: () async {
        // Do something here
        Navigator.push( context, MaterialPageRoute( builder: (context) => Accueil()), ).then((value) => setState(() {}));
        return false;
      },
      child:  Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.push( context, MaterialPageRoute( builder: (context) => Accueil()), ).then((value) => setState(() {}))
          ),
          title: Text("Mes matières") ,
        ),
        body: Padding(child : FutureBuilder<List<Matiere>>(
            future : MatiereBDD.instance.matieres(),
            builder: (BuildContext context, AsyncSnapshot<List<Matiere>> snapshot) {

              if (snapshot.hasData) {

                List<Matiere>? recipes = snapshot.data;

                return ListView.builder(
                  itemCount: recipes!.length,
                  itemBuilder: (context, index){
                    final recipe = recipes[index];
                    return Dismissible(key: UniqueKey(),
                        onDismissed: (direction){
                          setState(() {
                            MatiereBDD.instance.deleteMatiere(recipe.id);

                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${recipe.id} supprimé")));
                        },
                        background: Container(color: Colors.red,child: Row(children: [Text("Supprimer matière -->"),Spacer(),Text("<--Supprimer matière")]),),
                        child: RecipeItemWidget(recipe: recipe));
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

              setState(() {
                FormAddMatiere(context);
              });



            },
            child: Icon(Icons.add)
        ),
      ),
    );
  }
}


class RecipeItemWidget extends StatelessWidget {
  const RecipeItemWidget({required this.recipe})
      : super();
  final Matiere recipe;
  onDl(){

  }

  @override
  Widget build(BuildContext context) {
    bool existe = true;
    String moyenne;
    if(existe)
       moyenne = recipe.moyenne.toStringAsPrecision(4) + "/20";
    else
      moyenne = "Aucune";
    return GestureDetector(onTap : () {Navigator.push(context, MaterialPageRoute(builder: (context) =>  NoteMatiere(matiere: recipe)));},child: Card(
        elevation: 5,
        color: Colors.greenAccent,

        child: Row(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(recipe.id,style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.3)),
                  Row( children : [Text("Moyenne : "),Text(moyenne
                      ,style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5))])
                ],),
              Spacer(),
            Text("Coefficient : " + recipe.coef.toString()),
            ]
        )
    ));
  }
}




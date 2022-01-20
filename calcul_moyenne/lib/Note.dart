import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';


class Note {
  int ?id;
  String matiere;
  double note;
  double coef;
  double note_max;
  Note({this.id, required this.matiere, required this.note, required this.coef, required this.note_max});
  //Note(this.matiere,this.note,this.coef,this.note_max);
  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'note': note,
      'matiere': matiere,
      'coef': coef,
      'note_max': note_max,
    };
  }
  factory Note.fromMap(Map<String, dynamic> json) => new Note(
    id: json['id'],
    matiere: json['matiere'],
    note: json['note'],
    coef: json['coef'],
    note_max: json['note_max'],
  );
 /* factory Note.fromMap(Map<String, dynamic> map) => new Note(

    map['matiere'],
    map['note'],
    map['coef'],
    map['note_max'],
  );
*/
}


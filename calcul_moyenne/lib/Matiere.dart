import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';


class Matiere {

  String id;
  double moyenne;
  double coef;

  Matiere(this.id,this.moyenne,this.coef);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'moyenne': moyenne,
      'coef': coef,
    };
  }

  factory Matiere.fromMap(Map<String, dynamic> map) => new Matiere(
    map['id'],
    map['moyenne'],
    map['coef'],
  );

}


import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteDataBase {
  Future<void> setNoteData(notevalue) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("moy", notevalue);
  }
  NoteDataBase._();

  static final NoteDataBase instance = NoteDataBase._();
  static Database? _database;
  double moyenne = 0;


  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'recipe_database3.db'),
      onCreate: (db, version) {
        print("CREATION");
        return db.execute(
          "CREATE TABLE note(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, matiere TEXT, note DOUBLE, note_max DOUBLE,coef DOUBLE)",
        );
      },
      version: 1,
    );
  }
  void insertRecipe(Note recipe) async {
    final Database? db = await database;

    await db?.insert(
      'note',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    final List<Map<String, Object?>>? maps = await db?.query('note');
    List<Note> recipes = List.generate(maps!.length, (i) {
      return Note.fromMap(maps[i]);
    });


  }

  void updateRecipe(Note note) async {
    final Database? db = await database;
    await db?.update("caca", note.toMap(),
        where: "title = ?", whereArgs: [note.matiere]);
  }

  void deleteRecipe(int id) async {
    final Database? db = await database;
    final List<Map<String, Object?>>? maps = await db?.query('note');
    List<Note> recipes = List.generate(maps!.length, (i) {
      return Note.fromMap(maps[i]);
    });
    db?.delete("note", where: "id = ?", whereArgs: [id]);

  }
  getMoy() async{
    final Database? db = await database;
    final List<Map<String, Object?>>? maps = await db?.query('note');
    List<Note> recipes = List.generate(maps!.length, (i) {
      return Note.fromMap(maps[i]);
    });
    print("getMoy");
    print(recipes.length);
    return 10;

  }
  Future<List<Note>> recipes() async {
    final Database? db = await database;
    final List<Map<String, Object?>>? maps = await db?.query('note');
    
    List<Note> recipes = List.generate(maps!.length, (i) {
      return Note.fromMap(maps[i]);
    });
    if (recipes.isEmpty) {
      print("vIDE");
      for (Note recipe in defaultRecipes) {
        print("Tentative d'insertion");
        insertRecipe(recipe);
      }
      recipes = defaultRecipes;
    }


    return recipes;
  }
  Future<List<Note>> notesByMatiere(String matiere) async {
    final Database? db = await database;
    final List<Map<String, Object?>>? maps = await db?.rawQuery('SELECT * FROM note WHERE matiere=?', [matiere]);
    List<Note> recipes = List.generate(maps!.length, (i) {
      return Note.fromMap(maps[i]);
    });
    if (recipes.isEmpty) {
  
    }


    return recipes;
  }



  final List<Note> defaultRecipes = [];

}
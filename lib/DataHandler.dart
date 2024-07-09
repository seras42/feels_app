import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart' as cipher;
import 'package:sqflite_sqlcipher/sqflite.dart';


class Note {
  late int id;
  late String textNote;
  final String dateTime;
  ///from 1 to 10
  final int moodLevel;
  ///0 neutral, 1 angry, 2 happy, 3 sad, 4 fear, 5 disgust,
  final int moodType;

  Note({
    //required this.id,
    required this.textNote,
    required this.dateTime,
    required this.moodLevel,
    required this.moodType,
  });

  Note.withId({
    required this.id,
    required this.textNote,
    required this.dateTime,
    required this.moodLevel,
    required this.moodType,
  });

  Map<String, dynamic> toMap() {
    return {
      'textNote': textNote,
      'dateTime': dateTime,
      'moodLevel': moodLevel,
      'moodType' : moodType,
    };
  }
  @override
  String toString() {
    return 'Note{textNote: $textNote, datetime: $dateTime, moodLevel: $moodLevel, moodType: $moodType}';
  }
}

class DataHandler {
  cipher.Database? _database;
  DataHandler();
  bool isDatabaseOpen = false;

  Set<Note>? listOfAllNotes;


  dispose(){
    if(listOfAllNotes != null) {
      listOfAllNotes!.clear();
    }
  }

  Future<void> deleteWholeDatabase() async {

    final path = join(await cipher.databaseFactory.getDatabasesPath(), 'feelNotes_database.db');
    if(_database != null) {
      _database!.close();
    }
    await cipher.deleteDatabase(path);
    databaseClosed();
    _database = null;
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'database_password');
    if(listOfAllNotes != null) {
      listOfAllNotes!.clear();
    }
  }

   Future<void> createTables(cipher.Database database) async{
    await database.execute( """CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, textNote TEXT, dateTime TEXT, moodLevel INTEGER, moodType INTEGER)""");
  }
  void databaseOpened(){
    isDatabaseOpen = true;
  }
  void databaseClosed(){
    isDatabaseOpen = false;
  }
  Future<bool> doesDatabaseExist() async {
    final databasePath = join(await cipher.databaseFactory.getDatabasesPath(), 'feelNotes_database.db');
    bool ret = await cipher.databaseExists(databasePath);
    return ret;
  }

  Future<void> closeDatabase() async{
    if(_database != null){
      _database!.close();
      _database = null;
    databaseClosed();
    }
  }
  bool isDataBaseOpen() {
    if(_database == null){
      return false;
    } else {
      if (kDebugMode) {
        print("_database is $_database");
      }
      return true;
    }
  }

  ///returns true if database has been opened false if it failed
  Future<bool> openDatabaseNoPassword() async {
    const storage = FlutterSecureStorage();
    String? retrievedPassword = await storage.read(key: 'database_password');
    if(retrievedPassword != null){
      try{
        final databasePath = join(await cipher.databaseFactory.getDatabasesPath(), 'feelNotes_database.db');
        cipher.Database database = await cipher.openDatabase(
          databasePath,
          password: retrievedPassword,
        );
        _database = database;
        databaseOpened();
        return true;
      } catch (e) {
        _database = null;
        databaseClosed();
        return false;
      }
    }
    return false;
  }


  Future<bool> initDatabaseNoPassword() async {
    const storage = FlutterSecureStorage();

    final random = Random();
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+';
    String password = '';
    for (int i = 0; i < 30; i++) {
      password += characters[random.nextInt(characters.length-1)];
    }
    await storage.write(key: 'database_password', value: password);
    String? retrievedPassword = await storage.read(key: 'database_password');
    if(retrievedPassword != null){

      try {
        final databasePath = join(await cipher.databaseFactory.getDatabasesPath(), 'feelNotes_database.db');
        cipher.Database database = await cipher.openDatabase(
          databasePath,
          password: retrievedPassword,
          version: 1,
          onCreate: (db, version) {
            return db.execute(
              'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, textNote TEXT, dateTime TEXT, moodLevel INTEGER, moodType INTEGER)',
            );
          },
        );

        if (database != null) {
          _database = database;
          databaseOpened();
          return true;
        } else {
          databaseClosed();
          return false;
        }
      } catch (e){
        if (e is DatabaseException) {
          _database = null;
          databaseClosed();
          if (kDebugMode) {
            print('Failed to create a database $e');
          }
          return false;
        } else {
          databaseClosed();
          return false;
        }
      }
    }

    return false;
  }


  /// returns true if initialization was complete and database is open
   Future<bool> initDatabase(String password) async {
    final databasePath = join(await cipher.databaseFactory.getDatabasesPath(), 'feelNotes_database.db');
    bool dbExists = await cipher.databaseExists(databasePath);
    if (!dbExists) {
      // Prompt user for password and show progress indicator

      try {
        cipher.Database database = await cipher.openDatabase(
          databasePath,
          password: password,
          version: 1,
          onCreate: (db, version) {
            return db.execute(
              'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, textNote TEXT, dateTime TEXT, moodLevel INTEGER, moodType INTEGER)',
            );
          },
        );

        if (database != null) {
          _database = database;
          databaseOpened();
          return true;
        } else {
          databaseClosed();
          return false;
        }
      }catch (e){
        if (e is DatabaseException) {
          _database = null;
          databaseClosed();
          if (kDebugMode) {
            print('Failed to create a database $e');
          }
          return false;
        } else {
          databaseClosed();
          return false;
        }
      } finally {
        password = " ";
      }
    } else {

      try {
        // Attempt to open the database
        cipher.Database database = await cipher.openDatabase(
          databasePath,
          password: password,
        );

        _database = database;
        databaseOpened();
        return true;

      } catch (e) {
        if (kDebugMode) {
          print("exception $e");
        }

        if (e is DatabaseException) {
          _database = null;
          databaseClosed();
          password = " ";
          if (kDebugMode) {
            print('Incorrect password, failed OpenFailedError in DataHandler $e');
          }
          return false;
        } else {
          _database = null;
          if (kDebugMode) {
            print('Incorrect password, failed OpenFailedError in DataHandler $e');
          }
          databaseClosed();
          password = " ";
          return false;
        }
      }
    }
  }

  Future<void> insertNote(Note note) async {
    // Get a reference to the database.
    if(_database != null) {

      // Insert the note into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same note is inserted twice.
      //
      // In this case, replace any previous data.

      int id = await _database!.insert(
        'notes',
        note.toMap(),
        conflictAlgorithm: cipher.ConflictAlgorithm.replace,
      );

      note.id = id;
      if(listOfAllNotes != null){
        listOfAllNotes!.add(note);
      }
    }
  }
  
  Future<Map<int, HashSet<Note>>> notesSortedByYear() async {
    Set<Note> allNotes = await getNotes();
    Map<int, HashSet<Note>> sorted = HashMap();
    if(allNotes.isNotEmpty){
      for(Note note in allNotes){
        DateTime dateTime = DateTime.parse(note.dateTime);
        HashSet hashSet = sorted.putIfAbsent(dateTime.year, () => HashSet<Note>());
        hashSet.add(note);
      }
    }
    
    return sorted;
  }


  /// int year, int month, int day, int hour, HashSet<note>
  Future<Map<int, Map<int, HashMap<int,Map<int, HashSet<Note>>>>>> getNotesSortedByDate() async {

    Set<Note> allNotes = await getNotes();

    Map<int, Map<int, HashMap<int,Map<int, HashSet<Note>>>>> ns = HashMap();

    if(allNotes.isNotEmpty){

      //for(Note note in allNotes)
      for (var note in allNotes) {
        DateTime dateTime = DateTime.parse(note.dateTime);
        //print(dateTime.toString());


        ns
            .putIfAbsent(dateTime.year, () => HashMap())
            .putIfAbsent(dateTime.month, () => HashMap())
            .putIfAbsent(dateTime.day, () => HashMap())
            .putIfAbsent(dateTime.hour, () => HashSet())
            .add(note);
      }
    }

    ns.forEach((year, yearMap) {
      yearMap.forEach((month, monthMap) {
        monthMap.forEach((day, dayMap) {
          dayMap.forEach((hour, notesSet) {
            //print('$year/$month/$day $hour: - ${notesSet.map((note) => note.textNote).join(', ')}');
          });
          });
        });
      });
    return ns;
  }
  ///int year, int month, int day, HashSet<note>
   Future<Map<int, HashMap<int,Map<int, HashSet<Note>>>>> getNotesSortedByDay() async {
    Set<Note> allNotes = await getNotes();



    Map<int, HashMap<int,Map<int, HashSet<Note>>>> ns = HashMap();

    void sortNotesByDate(List<Note> notes) {
      notes.sort((a, b) => DateTime.parse(a.dateTime).compareTo(DateTime.parse(b.dateTime)));
    }


    if(allNotes.isNotEmpty){

      sortNotesByDate(allNotes.toList());


      //for(Note note in allNotes)
      for (var note in allNotes) {
        DateTime dateTime = DateTime.parse(note.dateTime);
        //print(dateTime.toString());


        ns
            .putIfAbsent(dateTime.year, () => HashMap())
            .putIfAbsent(dateTime.month, () => HashMap())
            .putIfAbsent(dateTime.day, () => HashSet())
            .add(note);
      }
    }

    if (kDebugMode) {
      print("returning ns");
    }
    return ns;
  }

// A method that retrieves all the notes from the notes table.
  Future<Set<Note>> getNotes() async {
    // Initialize an empty list to store the notes

    if(_database != null && _database!.isOpen && listOfAllNotes == null) {
      List<Note> toReturn = [];
      try {
        // Query the table for all the notes.
        final List<Map<String, dynamic>> maps = await _database!.query('notes');

        if(maps.isEmpty){
          if (kDebugMode) {
            print("Empty notes");
          }
          listOfAllNotes = toReturn.toSet();
          return toReturn.toSet();
        }

        toReturn = List.generate(maps.length, (i) {
          return Note.withId(
            id: maps[i]['id'] as int,
            textNote: maps[i]['textNote'] as String,
            dateTime: maps[i]['dateTime'] as String,
            moodLevel: maps[i]['moodLevel'] as int,
            moodType: maps[i]['moodType'] as int,
          );
        });
        listOfAllNotes = toReturn.toSet();
        return toReturn.toSet();

      } catch (e) {
        if (kDebugMode) {
          print(e);
        }

        //listOfAllNotes = toReturn;
        return toReturn.toSet();
      }
    } else {
      return listOfAllNotes!;
    }
  }
  Future<void> updateNote(Note note) async {
    // Get a reference to the database.
    if(_database != null) {
      final db = _database;
      // Update the given Noe.
      await db!.update(
        'notes',
        note.toMap(),
        // Ensure that the Note has a matching id.
        where: 'id = ?',
        // Pass the note id as a whereArg to prevent SQL injection.
        whereArgs: [note.id],
      );
    }
  }

  Future<void> deleteNote(Note note) async {
    // Get a reference to the database.
    if(_database != null) {
      int id = note.id;
      if (kDebugMode) {
        print('delete in DataHadler ID $note.id');
      }
      // Remove the Note from the database.
      await _database?.delete(
        'notes',
        // Use a `where` clause to delete a specific note.
        where: 'id = ?',
        // Pass the note id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );
      if(listOfAllNotes != null){
        listOfAllNotes!.remove(note);
      }
    }
  }
}
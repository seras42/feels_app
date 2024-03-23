

import 'dart:collection';


import 'package:feels_app/password_prompt.dart';
import 'package:feels_app/pages/DataPage.dart';
import 'package:feels_app/pages/HomePageButtons.dart';
import 'package:feels_app/pages/NotePage.dart';
import 'package:feels_app/Settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:feels_app/DataHandlerOLd.dart';

import 'DataHandler.dart';


void main() async{
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {

   const MyApp({
    super.key});




  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Feels App',
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.blue[900],
            selectionColor: Colors.blue[400],
            selectionHandleColor: Colors.blue[900],
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),

          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
          iconTheme: const IconThemeData(color: Colors.white),
          primaryColor: Colors.white, // Change the primary color as needed
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        //home: const MyHomePage(title: 'Flutter Demo Home Page'),
        home: const MainPage());
  }

  }


class MainPage extends StatefulWidget {
   const MainPage({
     super.key});


  @override
  State<StatefulWidget> createState() => _MainPageState();


}


class _MainPageState extends State<MainPage> {


  var currentSelectedIndex = 0;
  final myController = TextEditingController();
  bool isDatabaseOpen = false;

  DataHandler dataHandler = DataHandler();

  Map<int, Map<int, Map<int, HashMap<int, HashSet<Note>>>>> notesSorted = {};

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
    //dataHandler.closeDatabase();
  }
  @override
  void initState() {
    super.initState();
    //_refreshNotes(); // Loading the notes when the app starts


  }
  bool _isLoading = true;

  void databaseDeleted(){
    if(mounted) {
      setState(() {
        _isLoading = true;
      });
    }

  }

  int getIndex(){
    if(currentSelectedIndex > 2){
      return 2;
    } else {
      return currentSelectedIndex;
    }
  }
  void databaseIsOpen(){
    if(mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    if(!dataHandler.isDataBaseOpen()){
      _isLoading = true;
    } else {

      if (kDebugMode) {
        print('Database is open');
      }
    }
    void goToSettings(){
      setState(() {
        currentSelectedIndex = 3;
      });
    }
    void goToHome(){
      if(mounted) {
        setState(() {
          currentSelectedIndex = 0;
        });
      }
    }

    Widget page;
    switch (currentSelectedIndex) {
      case 0:
        page = HomePage(myController: myController, dataHandler:  dataHandler, goToSettings:  goToSettings,);
        break;
      case 1:
        page = DataPage(dataHandler: dataHandler,);
        break;
      case 2:
        page = NotePage(dataHandler: dataHandler,);
        break;
      case 3:
        page = Settings(dataHandler: dataHandler,databaseDeleted: databaseDeleted, goBack: goToHome,);
        break;
      default:
        throw UnimplementedError('no widget for $currentSelectedIndex');
    }

    return Scaffold(


        body: _isLoading
            ? UnlockOrMakeTheDatabase(dataHandler: dataHandler, isDone: databaseIsOpen,)
            : page,
      bottomNavigationBar: SafeArea(

        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.green,
          fixedColor: Colors.black,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Data'),
            BottomNavigationBarItem(icon: Icon(Icons.pages),label: 'notes'),
            //BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
            // Add more items if needed
          ],

          currentIndex: getIndex(),
          onTap: (value) {
            setState(() {
              if (currentSelectedIndex == 2 && value == 2) {
                if(page is NotePage){
                  NotePage notePage = page;
                  notePage.resetNote();
                }
              }
              currentSelectedIndex = value;
            });
          },
        ),
      ),
    );

  }



}

class HomePage extends StatelessWidget {
  final VoidCallback goToSettings;
  final TextEditingController myController;
  final DataHandler dataHandler;

  const HomePage({
    required this.myController,
    Key? key, required this.dataHandler, required this.goToSettings,
  }) : super(key: key);

  // 1 sad 2-neutral 3-happy

  /// moodLevel, moodType
  void addNewNote(int moodLevel, int moodType){
    if (kDebugMode) {
      print("making new note moodLevel is $moodLevel moodType $moodType");
    }
    var note = Note(
      textNote: myController.text,
      dateTime: DateTime.now().toIso8601String(),
      moodLevel: moodLevel,
      moodType: moodType,
    );
    dataHandler.insertNote(note);
  }



  @override
  Widget build(BuildContext context) {

    return SafeArea(child:

        Center(
            child: Stack(
              children: [
                GridView.count(
                 shrinkWrap: true,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                crossAxisCount: 2, // Number of columns
                children: <Widget> [
                  FeelingHappy(happyButtonPressed: addNewNote, myController: myController,),
                  FeelingSad(sadButtonPressed: addNewNote, myController: myController),
                  FeelingNeutral(neutralButtonPressed: addNewNote, myController: myController),

                  FeelingAngry(angryButtonPressed: addNewNote, myController: myController,),
                  FeelingDisgust(disgustButtonPressed: addNewNote, myController: myController),
                  FeelingFear(fearButtonPressed: addNewNote, myController: myController),
                ]
               ),
                Positioned(
                  right: 0,
                  child:

                  IconButton(
                    icon: const Icon(Icons.settings),
                    tooltip: 'Show Settings',
                    onPressed: () => goToSettings(),
                  ),
                )
            ],

            ),

        )



    );
  }

}



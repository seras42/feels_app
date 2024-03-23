import 'dart:math';

import 'package:feels_app/DataHandler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final DataHandler dataHandler;
  final VoidCallback databaseDeleted;
  final VoidCallback goBack;
  const Settings({super.key, required this.dataHandler, required this.databaseDeleted, required this.goBack});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Use Visibility widget to conditionally show/hide the dialog

              ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => DeleteConfirmation(dataHandler: widget.dataHandler, databaseDeleted: widget.databaseDeleted,));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),

                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical:
                            20), // Adjust the horizontal padding as needed
                  ),
                ),
                child: const Text(
                  "Delete Everything",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              //GenerateTests(dataHandler: widget.dataHandler,),

              ElevatedButton(onPressed: () async {
               await widget.dataHandler.closeDatabase();
                widget.databaseDeleted();
              }, child: const Text('Close database')),


              ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),),onPressed: () => widget.goBack(), child: const Text("Go Back"))

            ],
          ),
        ),
      ),
    );
  }
}

class DeleteConfirmation extends StatefulWidget {
  final DataHandler dataHandler;
  final VoidCallback databaseDeleted;
  const DeleteConfirmation({
    super.key, required this.dataHandler, required this.databaseDeleted,
  });

  @override
  State<DeleteConfirmation> createState() => _DeleteConfirmationState();
}

class _DeleteConfirmationState extends State<DeleteConfirmation> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(

            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Are you sure you want to delete everything? It cannot be reversed",
                textAlign: TextAlign.center, // Align text to the center
                style: TextStyle(
                  fontSize: 18, // Adjust the font size as needed
                  fontWeight: FontWeight.bold, // Make the text bold
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: TextField(
                    expands: false,
                    maxLines: 1,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Type yes to delete',
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      focusColor: Colors.white60,
                      fillColor: Colors.white60,
                      filled: true,
                      border: OutlineInputBorder(
                        // Add borders
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    )),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    //myController.clear();
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () async {
                    if (controller.text.toLowerCase() == "yes") {
                      await widget.dataHandler.deleteWholeDatabase();
                      widget.databaseDeleted();
                      controller.clear();
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    }
                    //myController.clear();
                  },
                  child: const Text('Yes'),
                )
              ])
            ]),
      ),
    );
  }
}
class GenerateTests extends StatelessWidget{
  final DataHandler dataHandler;

  const GenerateTests({super.key, required this.dataHandler});

  void addTest() {

    Random random = Random();
    int amount = 0;

    for(int i = 1; i < 12; i++){
      for(int y = 1; y < 31; y++){
        int toGen = random.nextInt(5);
        int mood = random.nextInt(5);
        int moodLevel = random.nextInt(5);

        int currentMood = moodLevel * 2;

        DateTime dataTime = DateTime(2023, i, y, i, mood, 30, 10, 10);

        for(int c = 0; c < toGen; c++){
          amount++;
          Note note = Note(
              textNote: "Testing from custom Testing class $c" ,
              dateTime: dataTime.toIso8601String(),
              moodType: mood,
              moodLevel: currentMood);
              dataHandler.insertNote(note);
        }

      }
    }
    if (kDebugMode) {
      print('Amount of notes generates $amount');
    }
  }


  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => addTest(), child: const Text('Generate Test'));
  }

}

import 'dart:async';

import 'package:feels_app/DataHandler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UnlockOrMakeTheDatabase extends StatefulWidget {
  final DataHandler dataHandler;
  final VoidCallback isDone;
  const UnlockOrMakeTheDatabase(
      {super.key, required this.dataHandler, required this.isDone});


  @override
  State<UnlockOrMakeTheDatabase> createState() =>
      _UnlockOrMakeTheDatabaseState();
}

class _UnlockOrMakeTheDatabaseState extends State<UnlockOrMakeTheDatabase> {

  void reset(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    if (widget.dataHandler.isDataBaseOpen() && widget.dataHandler.isDatabaseOpen) {
      if (kDebugMode) {
        print('database is open so returning empty container');
        print('is database open' + widget.dataHandler.isDataBaseOpen().toString() + " " + widget.dataHandler.isDatabaseOpen.toString() );
      }
      if(!widget.dataHandler.isDatabaseOpen && widget.dataHandler.isDataBaseOpen()){

      }


      return const Center(child: Text("Database is open yet this window is still visible, this is a bug"));
    } else {



      return FutureBuilder<bool>(

          future: widget.dataHandler.doesDatabaseExist(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              if (snapshot.data == true) {
                // The database exists
                return SafeArea(child: PasswordPromptOpenDatabase(reset: reset,
                  dataHandler: widget.dataHandler,
                  isDone: widget.isDone,
                ));
              } else {
                // The database does not exist
                return SafeArea(child: PasswordPromptNewDatabase(
                  dataHandler: widget.dataHandler,
                  isDone: widget.isDone,
                ));
              }
            }
          });
    }
  }
}

class PasswordPromptOpenDatabase extends StatefulWidget {
  final DataHandler dataHandler;
  final VoidCallback isDone;
  final VoidCallback reset;

  const PasswordPromptOpenDatabase({
    super.key,
    required this.dataHandler,
    required this.isDone, required this.reset,
  });
  @override
  State<PasswordPromptOpenDatabase> createState() => _PasswordPromptOpenDatabaseState();
}


class _PasswordPromptOpenDatabaseState extends State<PasswordPromptOpenDatabase> {
  final _controller = TextEditingController();

  String showStatus = "";

  void wrongPassword(){
    showStatus = "wrong password";
    Timer(const Duration(seconds: 2), () => setState(() {
      showStatus = "";
    }));
  }

  void rebuild(){
    setState(() {

    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: widget.dataHandler.openDatabaseNoPassword(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        if(snapshot.data == true ) {
          widget.dataHandler.databaseOpened();
          widget.isDone();
          return const Center(child: Text("Database unlocked with System Key Successfully"));
        } else {
              return Center(

                child: Dialog.fullscreen(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10.0),
                          const Text('Enter Password for an existing Database.'),
                          const SizedBox(height: 20.0),
                          TextField(
                            controller: _controller,
                            obscureText: true,
                            autofocus: true,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextButton(
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(color: Colors.brown, width: 2.0),
                              )),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteConfirmation(
                                      dataHandler: widget.dataHandler,
                                      reset: widget.reset,
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                "Delete an Existing Database",
                              )),
                          const SizedBox(height: 20.0),
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side:
                                  const BorderSide(color: Colors.brown, width: 2.0),
                                )),
                            child: const Text('Open'),
                            onPressed: () async {
                              if (await widget.dataHandler
                                  .initDatabase(_controller.text)) {
                                if (kDebugMode) {
                                  print("database should be open");
                                }
                                if (widget.dataHandler.isDataBaseOpen()) {
                                  if (kDebugMode) {
                                    print("Correct password");
                                  }
                                  showStatus = "Correct password";
                                  widget.dataHandler.databaseOpened();
                                  widget.isDone();
                                  if (!context.mounted) return;
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop(_controller.text);
                                  }
                                } else {
                                  if (kDebugMode) {
                                    print("database is not opened for some reason");
                                  }
                                }
                              } else {
                                setState(() {
                                  widget.dataHandler.databaseClosed();
                                  if (kDebugMode) {
                                    print('Wrong password');
                                  }
                                  wrongPassword();
                                });
                              }
                              _controller.clear();
                            },
                          ),
                          const SizedBox(height: 20.0),
                          Text(showStatus)
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        });
  }

}


class DeleteConfirmation extends StatefulWidget {
  final DataHandler dataHandler;
  final VoidCallback reset;
  const DeleteConfirmation({
    super.key, required this.dataHandler, required this.reset,
  });

  @override
  State<DeleteConfirmation> createState() => _DeleteConfirmationState();
}
class _DeleteConfirmationState extends State<DeleteConfirmation> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
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
              const SizedBox(height: 10),
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
                  onPressed: () {
                    if (controller.text.toLowerCase() == "yes") {
                      if (kDebugMode) {
                        print("Database Deleted");
                      }
                      setState(() {
                        widget.dataHandler.deleteWholeDatabase();
                        widget.reset;
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      });
                      controller.clear();
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
class PasswordPromptNewDatabase extends StatefulWidget {
  final DataHandler dataHandler;
  final VoidCallback isDone;

  const PasswordPromptNewDatabase({
    super.key,
    required this.dataHandler,
    required this.isDone,
  });

  @override
  State<PasswordPromptNewDatabase> createState() =>
      _PasswordPromptNewDatabaseState();
}
class _PasswordPromptNewDatabaseState extends State<PasswordPromptNewDatabase> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String showStatus = "";
  @override
  Widget build(BuildContext context) {

    bool enabled = true;


    return Center(
      child: Dialog.fullscreen(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('To use the App you need to create a password.', textAlign: TextAlign.center,),
                const SizedBox(height: 5,),
                const Text('The password will be used to encrypt your data.', textAlign: TextAlign.center,),
                const SizedBox(height: 5,),
                const Text('If you choose No Password option the data will still be encrypted using generated key.', textAlign: TextAlign.center,),
                const SizedBox(height: 20,),
                TextField(
                  controller: _controller,
                  obscureText: true,
                  autofocus: true,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Colors.black, width: 2.0),
                          )
                      ),
                      onPressed: enabled ? () async {
                        enabled = false;
                        await widget.dataHandler.initDatabase(_controller.text);
                        if (widget.dataHandler.isDataBaseOpen()) {
                          setState(() {
                            showStatus = "Good";
                            widget.dataHandler.databaseOpened();
                            widget.isDone();
                            enabled = true;
                            if (!context.mounted) return;
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop(_controller.text);
                            }
                          });
                          _controller.clear();
                        } else {
                          setState(() {
                            enabled = true;
                            widget.dataHandler.databaseClosed();
                            showStatus = "failed to create a database";
                          });
                        }
                        _controller.clear();
                      } : null,
                      child: const Text('OK'),


                    ),
                    const SizedBox(width: 4),
                    TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Colors.black, width: 2.0),
                            )
                        ),
                        onPressed: enabled ? () async {
                          enabled = false;

                         await widget.dataHandler.initDatabaseNoPassword();
                         if (widget.dataHandler.isDataBaseOpen()) {
                           setState(() {
                             showStatus = "Good";
                             widget.dataHandler.databaseOpened();
                             widget.isDone();
                             if (Navigator.of(context).canPop()) {
                               Navigator.of(context).pop(_controller.text);
                             }
                             enabled = true;
                           });
                           _controller.clear();
                         } else {
                           setState(() {
                             enabled = true;
                             widget.dataHandler.databaseClosed();
                             showStatus = "failed to create a database";
                           });
                         }
                         _controller.clear();
                        } : null,
                        child: const Text("I don't want password"))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

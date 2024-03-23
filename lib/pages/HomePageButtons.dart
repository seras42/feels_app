
import 'package:flutter/material.dart';

class FeelingAngry extends StatelessWidget {
  final Function(int, int) angryButtonPressed;
  final TextEditingController myController;

  FeelingAngry({
    required this.angryButtonPressed,
    required this.myController,
    super.key,
  });

  final Map<int, Color> colorMapping = {
    2: Colors.red[200] ?? Colors.redAccent,
    4: Colors.red[400] ?? Colors.redAccent,
    6: Colors.red[600] ?? Colors.redAccent,
    8: Colors.red[800] ?? Colors.redAccent,
    10: Colors.red[900] ?? Colors.redAccent,
  };

  @override
  Widget build(BuildContext context) {
    int moodLevel = 2;
    Color textFieldFillColor = colorMapping[2] ?? Colors.redAccent;

    textFieldFillColor = Colors.red[100] ?? Colors.redAccent;

    void setNewMoodLevel(int index) {
      moodLevel = index;
    }

    MaterialStateProperty.all<EdgeInsetsGeometry>(
      const EdgeInsets.symmetric(
          horizontal: 16.0), // Adjust the horizontal padding as needed
    );

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.all(2.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    8.0), // Set the radius of the rounded corners
                color: Colors.white, // Set the color of the DecoratedBox
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Dialog.fullscreen(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            controller: myController,
                            decoration: InputDecoration(
                              hintText: 'Why Do You Feel Angry',
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              focusColor: textFieldFillColor,
                              fillColor: textFieldFillColor,
                              filled: true,
                              border: const OutlineInputBorder(
                                // Add borders
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red[800] ?? Colors.red),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 18.0,
                              height: 1.5,
                              //color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Rate your anger from 2 to 10",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        const SizedBox(height: 8),
                        NumbersSelector(
                          onSelected: setNewMoodLevel,
                          colorMappings: colorMapping,
                        ),
                        const SizedBox(height: 8),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.grey),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .zero), // Set zero border radius
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  myController.clear();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .zero), // Set zero border radius
                                  ),
                                ),
                                onPressed: () {
                                  angryButtonPressed(moodLevel, 1);
                                  Navigator.pop(context);
                                  myController.clear();
                                  moodLevel = 2;
                                },
                                child: const Text('Add'),
                              )
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red[900] ?? Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(20),
        child: const FittedBox(
          fit: BoxFit
              .scaleDown, // This ensures that the text scales down to fit within the available space
          child: Text(
            'Feeling Angry',
            style: TextStyle(fontSize: 40, color: Colors.white),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}

class FeelingHappy extends StatelessWidget {
  final Function(int, int) happyButtonPressed;
  final TextEditingController myController;
  FeelingHappy({
    required this.happyButtonPressed,
    required this.myController,
    super.key,
  });

  final Map<int, Color> colorMapping = {
    2: Colors.green[200] ?? Colors.greenAccent,
    4: Colors.green[400] ?? Colors.greenAccent,
    6: Colors.green[600] ?? Colors.greenAccent,
    8: Colors.green[800] ?? Colors.greenAccent,
    10: Colors.green[900] ?? Colors.greenAccent,
  };

  @override
  Widget build(BuildContext context) {
    Color textFieldColor = Colors.green[300] ?? Colors.greenAccent;

    int moodLevel = 2;
    final theme = Theme.of(context);
    final style = theme.textTheme.displayLarge!.copyWith(
      color: Colors.white,
    );
    void setNewMoodLevel(int index) {
      moodLevel = index;
      //textFieldColor = colorMapping[index] ?? Colors.greenAccent;
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => Dialog.fullscreen(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      controller: myController,
                      decoration: InputDecoration(
                        hintText: 'Why Do You Feel Happy',
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                        focusColor: textFieldColor,
                        fillColor: textFieldColor,
                        filled: true,
                        border: const OutlineInputBorder(
                          // Add borders
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.green[800] ?? Colors.green),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 18.0,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rate your happiness from 2 to 10",
                    style: TextStyle(color: Colors.green[800] ?? Colors.green),
                  ),
                  const SizedBox(height: 8),
                  NumbersSelector(
                    onSelected: setNewMoodLevel,
                    colorMappings: colorMapping,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.grey),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            myController.clear();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: () {
                            happyButtonPressed(moodLevel, 2);
                            Navigator.pop(context);
                            myController.clear();
                            moodLevel = 2;
                          },
                          child: const Text('Add'),
                        )
                      ]),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[600],
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(20),
        child: FittedBox(
          fit: BoxFit
              .scaleDown, // This ensures that the text scales down to fit within the available space
          child: Text(
            'Feeling Happy',
            style: style,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class FeelingSad extends StatelessWidget {
  final Function(int, int) sadButtonPressed;
  final TextEditingController myController;

  FeelingSad({
    required this.sadButtonPressed,
    required this.myController,
    super.key,
  });

  final Map<int, Color> colorMapping = {
    2: Colors.blue[200] ?? Colors.blueAccent,
    4: Colors.blue[400] ?? Colors.blueAccent,
    6: Colors.blue[600] ?? Colors.blueAccent,
    8: Colors.blue[800] ?? Colors.blueAccent,
    10: Colors.blue[900] ?? Colors.blueAccent,
  };

  @override
  Widget build(BuildContext context) {
    int moodLevel = 2;
    final theme = Theme.of(context);
    final style = theme.textTheme.displayLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    Color textFieldFillColor = colorMapping[2] ?? Colors.blueAccent;

    textFieldFillColor = Colors.blue[100] ?? Colors.blueAccent;

    void setNewMoodLevel(int index) {
      moodLevel = index;
    }

    MaterialStateProperty.all<EdgeInsetsGeometry>(
      const EdgeInsets.symmetric(
          horizontal: 16.0), // Adjust the horizontal padding as needed
    );
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.all(2.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    8.0), // Set the radius of the rounded corners
                color: Colors.white, // Set the color of the DecoratedBox
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Dialog.fullscreen(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            controller: myController,
                            decoration: InputDecoration(
                              hintText: 'Why Do You Feel Sad',
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              focusColor: textFieldFillColor,
                              fillColor: textFieldFillColor,
                              filled: true,
                              border: const OutlineInputBorder(
                                // Add borders
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue[900] ?? Colors.blue),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 18.0,
                              height: 1.5,
                              //color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Rate your sadness from 2 to 10",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        const SizedBox(height: 8),
                        NumbersSelector(
                          onSelected: setNewMoodLevel,
                          colorMappings: colorMapping,
                        ),
                        const SizedBox(height: 8),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.grey),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .zero), // Set zero border radius
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  myController.clear();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue[800] ?? Colors.blue),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .zero), // Set zero border radius
                                  ),
                                ),
                                onPressed: () {
                                  sadButtonPressed(moodLevel, 3);
                                  Navigator.pop(context);
                                  myController.clear();
                                  moodLevel = 2;
                                },
                                child: const Text('Add'),
                              )
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[900] ?? Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(20),
        child: FittedBox(
          fit: BoxFit
              .scaleDown, // This ensures that the text scales down to fit within the available space
          child: Text(
            'Feeling Sad',
            style: style,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class FeelingFear extends StatelessWidget {
  final Function(int, int) fearButtonPressed;
  final TextEditingController myController;

  FeelingFear({
    required this.fearButtonPressed,
    required this.myController,
    super.key,
  });

  final Map<int, Color> colorMapping = {
    2: Colors.black12,
    4: Colors.black26,
    6: Colors.black38,
    8: Colors.black45,
    10: Colors.black87
  };

  @override
  Widget build(BuildContext context) {
    int moodLevel = 2;
    final theme = Theme.of(context);
    final style = theme.textTheme.displayLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    Color textFieldFillColor = colorMapping[2] ?? Colors.blueAccent;

    textFieldFillColor = Colors.black;

    void setNewMoodLevel(int index) {
      moodLevel = index;
    }

    MaterialStateProperty.all<EdgeInsetsGeometry>(
      const EdgeInsets.symmetric(
          horizontal: 16.0), // Adjust the horizontal padding as needed
    );
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.all(2.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    8.0), // Set the radius of the rounded corners
                color: Colors.white, // Set the color of the DecoratedBox
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Dialog.fullscreen(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            controller: myController,
                            decoration: InputDecoration(
                              hintText: 'Why Do You Feel Fear',
                              hintStyle: const TextStyle(color: Colors.white),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              focusColor: textFieldFillColor,
                              fillColor: textFieldFillColor,
                              filled: true,
                              border: const OutlineInputBorder(
                                // Add borders
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 18.0,
                              height: 1.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Rate your fear from 2 to 10",
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        NumbersSelector(
                          onSelected: setNewMoodLevel,
                          colorMappings: colorMapping,
                        ),
                        const SizedBox(height: 8),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.grey),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .zero), // Set zero border radius
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  myController.clear();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black87),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .zero), // Set zero border radius
                                  ),
                                ),
                                onPressed: () {
                                  fearButtonPressed(moodLevel, 4);
                                  Navigator.pop(context);
                                  myController.clear();
                                  moodLevel = 2;
                                },
                                child: const Text('Add'),
                              )
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(20),
        child: FittedBox(
          fit: BoxFit
              .scaleDown, // This ensures that the text scales down to fit within the available space
          child: Text(
            'Feeling Fearful',
            style: style,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class FeelingDisgust extends StatelessWidget {
  final Function(int, int) disgustButtonPressed;
  final TextEditingController myController;

  FeelingDisgust({
    required this.disgustButtonPressed,
    required this.myController,
    super.key,
  });

  final Map<int, Color> colorMapping = {
    2: Colors.lime[200] ?? Colors.limeAccent,
    4: Colors.lime[400] ?? Colors.limeAccent,
    6: Colors.lime[600] ?? Colors.limeAccent,
    8: Colors.lime[800] ?? Colors.limeAccent,
    10: Colors.lime[900] ?? Colors.limeAccent,
  };

  @override
  Widget build(BuildContext context) {
    int moodLevel = 2;
    final theme = Theme.of(context);
    final style = theme.textTheme.displayLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    Color textFieldFillColor = colorMapping[2] ?? Colors.redAccent;

    textFieldFillColor = Colors.lime[400] ?? Colors.redAccent;

    void setNewMoodLevel(int index) {
      moodLevel = index;
    }

    MaterialStateProperty.all<EdgeInsetsGeometry>(
      const EdgeInsets.symmetric(
          horizontal: 16.0), // Adjust the horizontal padding as needed
    );
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.all(2.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    8.0), // Set the radius of the rounded corners
                color: Colors.white, // Set the color of the DecoratedBox
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Dialog.fullscreen(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            controller: myController,
                            decoration: InputDecoration(
                              hintText: 'Why Do You Feel Disgust',
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              focusColor: textFieldFillColor,
                              fillColor: textFieldFillColor,
                              filled: true,
                              border: const OutlineInputBorder(
                                // Add borders
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.lime),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.lime),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 18.0,
                              height: 1.5,
                              //color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Rate your disgust from 2 to 10",
                          style: TextStyle(color: Colors.lime),
                        ),
                        const SizedBox(height: 8),
                        NumbersSelector(
                          onSelected: setNewMoodLevel,
                          colorMappings: colorMapping,
                        ),
                        const SizedBox(height: 8),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.grey),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .zero), // Set zero border radius
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  myController.clear();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.lime[300] ?? Colors.lime),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .zero), // Set zero border radius
                                  ),
                                ),
                                onPressed: () {
                                  disgustButtonPressed(moodLevel, 5);
                                  Navigator.pop(context);
                                  myController.clear();
                                  moodLevel = 2;
                                },
                                child: const Text('Add'),
                              )
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lime,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(20),
        child: FittedBox(
          fit: BoxFit
              .scaleDown, // This ensures that the text scales down to fit within the available space
          child: Text(
            'Feeling Disgust',
            style: style,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class FeelingNeutral extends StatelessWidget {
  final Function(int, int) neutralButtonPressed;
  final TextEditingController myController;

  const FeelingNeutral({
    required this.neutralButtonPressed,
    required this.myController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    Color textFieldFillColor = Colors.grey[100] ?? Colors.grey;

    MaterialStateProperty.all<EdgeInsetsGeometry>(
      const EdgeInsets.symmetric(
          horizontal: 16.0), // Adjust the horizontal padding as needed
    );
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.all(2.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    8.0), // Set the radius of the rounded corners
                color: Colors.white, // Set the color of the DecoratedBox
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Dialog.fullscreen(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            controller: myController,
                            decoration: InputDecoration(
                              hintText: 'Anything On Your Mind',
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              focusColor: textFieldFillColor,
                              fillColor: textFieldFillColor,
                              filled: true,
                              border: const OutlineInputBorder(
                                // Add borders
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 18.0,
                              height: 1.5,
                              //color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(height: 8),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.grey),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .zero), // Set zero border radius
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  myController.clear();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .zero), // Set zero border radius
                                  ),
                                ),
                                onPressed: () {
                                  neutralButtonPressed(2, 0);
                                  Navigator.pop(context);
                                  myController.clear();
                                },
                                child: const Text('Add'),
                              )
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(20),
        child: FittedBox(
          fit: BoxFit
              .scaleDown, // This ensures that the text scales down to fit within the available space
          child: Text(
            'Feeling Neutral',
            style: style,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class NumbersSelector extends StatefulWidget {
  final void Function(int) onSelected;
  final Map<int, Color> colorMappings;


  const NumbersSelector({
    super.key,
    required this.onSelected,
    required this.colorMappings,
  });

  @override
  State<NumbersSelector> createState() => _NumberSelectorState();
}

class _NumberSelectorState extends State<NumbersSelector> {
  Set<int> _selectedNumbers = {2};

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SegmentedButton<int>(
        showSelectedIcon: false,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                int selectedValue = _selectedNumbers.first;
                return widget.colorMappings[selectedValue] ??
                    Colors.grey; // Selected color
              }
              return Colors.white; // Default color
            },
          ),
          padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0);
              }
              return const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 20.0);
            },
          ),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0));
              }
              return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0));
            },
          ),
        ),
        segments: List.generate(
          5,
          (index) => ButtonSegment<int>(
            value: index * 2 + 2,
            label: Padding(
              padding: const EdgeInsets.all(0.1),
              child: Text(
                (index * 2 + 2).toString(),
              ),
            ),
            icon: null,
          ),
        ),
        selected: _selectedNumbers,
        onSelectionChanged: (Set<int> newSelection) {
          setState(() {
            _selectedNumbers = newSelection;
            if (newSelection.isNotEmpty) {
              int lastSelectedItem = newSelection.last;
              widget.onSelected(lastSelectedItem);
            }
          });
        },
        multiSelectionEnabled: false,
      ),
    );
  }
}

class Statistics extends StatelessWidget {
  const Statistics({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 40.0),
          // Adjust the horizontal padding as needed
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(80.0, 40.0), // Adjust the minimum size as needed
        ),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit
              .scaleDown, // This ensures that the text scales down to fit within the available space
          child: Text(
            'Check Logs',
            style: style,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

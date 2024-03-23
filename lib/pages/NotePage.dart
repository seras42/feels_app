import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../DataHandler.dart';


class NotePage extends StatefulWidget {

  final DataHandler dataHandler;
  int currentSelectedPage = 0;

  void resetNote() {
    if (currentSelectedPage != 0) {
      currentSelectedPage = 0;
    }
  }

  NotePage({super.key, required this.dataHandler});

  @override
  State<NotePage> createState() {
    return NotePageState();
  }
}

class NotePageState extends State<NotePage> {
  /// Year/Month/Day/Hour/HashSet
  Map<int, Map<int, HashMap<int, Map<int, HashSet<Note>>>>> notesSorted = {};

  /// Year/Month/List
  Map<int, Map<int, List<MonthContainer>?>?> yearWidget = {};

  var selectedMonth = 0;
  //var currentSelectedPage = widget.currentSelectedPage;
  //var monthTimes = 0;
  int selectedYear = 0;
  String dateMiddle = '';
  String dateNameMiddle = '';

  bool _isLoading = true;

  void pullNotesFromDatabaseAndSort() async {
    final data = await widget.dataHandler.getNotesSortedByDate();
    if (mounted) {
      setState(() {
        notesSorted.clear();
        notesSorted = data;
        _isLoading = false;
        updateYears();
      });
    }
  }

  void informOfmonthSelected() {
    setState(() {
      widget.currentSelectedPage = 1;
    });
  }

  void emptyMonthPage() {

    if (yearWidget[selectedYear] != null) {
      if (yearWidget[selectedYear]![selectedMonth] != null) {
        if (yearWidget[selectedYear]![selectedMonth]!.isEmpty) {
          yearWidget[selectedYear]!.remove(selectedMonth);
          if (kDebugMode) {
            print("found empty month");
          }
        }
      }
      if (yearWidget[selectedYear]!.isEmpty) {
        if (kDebugMode) {
          print("found empty year");
        }
        yearWidget.remove(selectedYear);
      }
    }

    selectMonthYearsPage();
  }

  void informEmptyPage() {
    setState(() {
    if (yearWidget[selectedYear] != null) {
      if (yearWidget[selectedYear]![selectedMonth] != null) {
        if (yearWidget[selectedYear]![selectedMonth]!.isEmpty) {
          yearWidget[selectedYear]!.remove(selectedMonth);
        }
      }
    }
      if (yearWidget[selectedYear] != null) {
        yearWidget[selectedYear]!.remove(selectedMonth);

        if (yearWidget[selectedYear] == null) {
          yearWidget.remove(selectedYear);
        } else {
          if (yearWidget[selectedYear]!.isEmpty) {
            yearWidget.remove(selectedYear);
          }
        }
      }
      notesSorted[selectedYear]!.remove(selectedMonth);
    selectMonthYearsPage();

  });

  }

  void selectMonthYearsPage() {
    setState(() {
      _isLoading = true;
      pullNotesFromDatabaseAndSort();
      widget.currentSelectedPage = 0;
    });
  }

  void setSelectedMonth(int month) {
    selectedMonth = month;
  }

  @override
  void initState() {
    super.initState();
    pullNotesFromDatabaseAndSort();
  }

  String getMonthName(int monthNumber) {
    const List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    if (monthNumber >= 1 && monthNumber <= 12) {
      return monthNames[monthNumber - 1];
    } else {
      return 'Invalid Month Number';
    }
  }

  void updateYears() async {
    setState(() {
      yearWidget.clear();
      for (int year in notesSorted.keys.toList().reversed.toList()) {
        Map<int, List<MonthContainer>> yearContainers =
            generateContainersForYear(
                year, notesSorted[year]!, informOfmonthSelected);
        yearWidget.putIfAbsent(year, () => yearContainers);
        selectedYear = year;
        _isLoading = false;
        dateMiddle = selectedYear.toString();
      }
    });
  }

  Map<int, List<MonthContainer>> generateContainersForYear(
      int year,
      // Year/Month/day/Note
      Map<int, HashMap<int, Map<int, HashSet<Note>>>> yearData,
      VoidCallback pressed) {
    Map<int, List<MonthContainer>> monthContainers = {};

    void addWidgetToMonth(int month, MonthContainer widget) {
      if (!monthContainers.containsKey(month)) {
        monthContainers[month] =
            []; // Create a new list if the month is not in the map
      }
      monthContainers[month]!
          .add(widget); // Add the widget to the list associated with the month
    }

    // Iterate through the months

    for (int month in yearData.keys) {
      DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
      int maxDay = lastDayOfMonth.day;
      //int day in yearData[month]!.keys
      List<Color> list = List.filled(maxDay, Colors.white70);

      for (int day in yearData[month]!.keys) {
        // Increment noteDayCount by the number of notes for the day
        //noteDayCount += yearData[month]![day]!.length;
        //if(yearData[month]![day] != null) {

        //0 neutral, 1 angry, 2 happy, 3 sad, 4 fear, 5 disgust,

          int neutral = 0;
          int angry = 0;
          int happy = 0;
          int sad = 0;
          int fear = 0;
          int disgust = 0;




          for (int hour in yearData[month]![day]!.keys) {
            for (var note in yearData[month]![day]![hour]!) {
              switch(note.moodType){
                case 0:
                  neutral++;
                  break;
                case 1:
                  angry++;
                  break;
                case 2:
                 happy++;
                 break;
                case 3:
                  sad++;
                  break;
                case 4:
                  fear++;
                  break;
                case 5:
                  disgust++;
                  break;
              }

            }
          }
          int highest = angry;



          if (happy > highest) {
            highest = happy;
          }
          if (neutral > highest) {
            highest = neutral;
          }
          if(sad > highest){
            highest = sad;
          }
          if(fear > highest){
            highest = fear;
          }
          if(disgust > highest){
            highest = disgust;
          }

          if (highest == angry) {
            list[day-1] = Colors.red[600] ?? Colors.red;
          } else if (highest == happy) {
            list[day-1] = Colors.green[600] ?? Colors.green;
          } else if (highest == neutral) {
            list[day-1] = Colors.grey[400] ?? Colors.grey;
          } else if (highest == fear){
            list[day-1] = Colors.black87;
          } else if (highest == sad){
            list[day-1] = Colors.blue[700] ?? Colors.blue;
          } else if(highest == disgust){
            list[day-1] = Colors.lime[600] ?? Colors.lime;
          } else {
            list[day-1] = Colors.cyan;
          }


      }

      addWidgetToMonth(month, MonthContainer(
        list: list,
              year: year,
              month: month,
              pressed: pressed,
              monthSelected: informOfmonthSelected,
              setMonth: setSelectedMonth));
    }

    return monthContainers;
  }

  @override
  Widget build(BuildContext context) {

    int currentSelectedPage = widget.currentSelectedPage;

    void goForwardYear() {
      int newYear = selectedYear;
      //monthTimes = 2;
      for (int year in yearWidget.keys) {
        if (year > newYear) {
          newYear = year;
        }
      }
      if (newYear != selectedYear) {
        setState(() {
          selectedYear = newYear;
          dateMiddle = selectedYear.toString();
        });
      }
    }
    void goBackYear() {
      int newYear = selectedYear;
      for (int year in yearWidget.keys) {
        if (year < newYear) {
          newYear = year;
        }
      }
      if (newYear != selectedYear) {
        setState(() {
          selectedYear = newYear;
          dateMiddle = selectedYear.toString();
        });
      }
    }
    void goForwardMonth() {
      int newMonth = selectedMonth;
      for (int month in yearWidget[selectedYear]!.keys) {
        if (month > newMonth) {
          newMonth = month;
          break;
        }
      }
      if (newMonth != selectedMonth) {
        setState(() {
          selectedMonth = newMonth;
        });
      } else {
        if (yearWidget[selectedYear + 1] != null) {
          for (int month in yearWidget[selectedYear + 1]!.keys) {
            int newMonthYear = 1;
            if (month == 1) {
              setState(() {
                selectedYear = selectedYear + 1;
                selectedMonth = 1;
              });
              break;
            } else {
              if (month > newMonthYear) {
                setState(() {
                  selectedYear = selectedYear + 1;
                  selectedMonth = month;
                });
                break;
              }
            }
          }
        }
      }
    }
    void goBackMonth() {
      int newMonth = selectedMonth;
      for (int month in yearWidget[selectedYear]!.keys.toList().reversed) {
        if (month < newMonth) {
          newMonth = month;
          break;
        }
      }
      if (newMonth != selectedMonth) {
        setState(() {
          selectedMonth = newMonth;
        });
      } else {
        if (yearWidget[selectedYear - 1] != null) {
          for (int month
              in yearWidget[selectedYear - 1]!.keys.toList().reversed) {
            int newMonthYear = 12;
            if (month == 12) {
              setState(() {
                selectedYear = selectedYear - 1;
                selectedMonth = 12;
              });
              break;
            } else {
              if (month < newMonthYear) {
                setState(() {
                  selectedYear = selectedYear - 1;
                  selectedMonth = month;
                });
                break;
              }
            }
          }
        }
      }
    }

    Widget page;
    switch (currentSelectedPage) {
      case 0:
        dateMiddle = selectedYear.toString();
        dateNameMiddle = '';
        page = YearPage(yearWidget: yearWidget, selectedYear: selectedYear);
        break;

      case 1:
        dateMiddle = selectedMonth.toString();
        dateNameMiddle = getMonthName(selectedMonth);
        page = WholeMonthNotePage(
          dataHandler: widget.dataHandler,
          monthNote: notesSorted[selectedYear]?[selectedMonth],
          pageEmpty: informEmptyPage,
        );
        break;

      case 2:
        page = const Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $currentSelectedPage');
    }

    return Scaffold(
        backgroundColor: Colors.greenAccent[50] ?? Colors.white,
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : page,
        bottomNavigationBar: BottomNavigationBar(
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.arrow_back),
              label: 'Back',
            ),
            BottomNavigationBarItem(
              icon: Text(dateMiddle),
              label: dateNameMiddle,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.arrow_forward),
              label: 'Forward',
            ),
          ],
          onTap: (index) {
            if (index == 0 && currentSelectedPage == 0) {
              goBackYear();
            } else if (index == 2 && currentSelectedPage == 0) {
              goForwardYear();
            }
            if (index == 0 && currentSelectedPage == 1) {
              goBackMonth();
            } else if (index == 2 && currentSelectedPage == 1) {
              goForwardMonth();
            }

            // Handle taps on the left and right items
            // You can navigate or perform specific actions based on the index
          },
          currentIndex: 1,
        ));
  }
}

class MonthContainer extends StatelessWidget {
  final VoidCallback pressed;
  final VoidCallback monthSelected;
  final Function(int) setMonth;

  final int year;
  final int month;
  final List<Color> list;

  const MonthContainer({
    super.key,
    required this.year,
    required this.month,
    required this.pressed,
    required this.monthSelected,
    required this.setMonth,
    required this.list,
  });

  String getMonthName(int monthNumber) {
    const List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    if (monthNumber >= 1 && monthNumber <= 12) {
      return monthNames[monthNumber - 1];
    } else {
      return 'Invalid Month Number';
    }
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        pressed();
        setMonth(month);
        monthSelected();
      },
      child: Container(
        //height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[200] ?? Colors.white,
            border: Border.all(
              color: Colors.grey[400] ?? Colors.black,
              width: 2.0, // Set the border width as needed
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(2),
          child: Column(
            children: [
              Text(
                "${getMonthName(month)} ${month.toString().padLeft(2, '0')}",
                style: const TextStyle(
                  fontStyle: FontStyle.italic, // Add italicized style
                  letterSpacing: 1.5, // Add letter spacing for a slight offset
                ),
              ),
              //Text(month.toString().padLeft(2, '0'), style: TextStyle(fontSize: 10.0),),
              if (list.isNotEmpty)
                Expanded(
                  child: GridView.count(
                      crossAxisCount: 7,
                      crossAxisSpacing: 1.5,
                      mainAxisSpacing: 1.5,
                      shrinkWrap: true,
                      children: List.generate(
                        //noteDayStats.length,
                        list.length,
                        (index) => SizedBox.expand(
                          child: Container(
                            decoration: BoxDecoration(
                              color:  list[index],
                              border: Border.all(
                                color:  list[index] == Colors.white ? Colors.black45 : Colors.black,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(1.5),
                              //margin: EdgeInsets.all(2.0), // Add margin if needed
                            ),
                            margin: const EdgeInsets.all(0.5),
                          ),
                        ),
                      )),
                )
            ],
          )),
    );

  }
}

/// main year page to choose what month and year notes to see
class YearPage extends StatefulWidget {
  const YearPage({
    Key? key,
    required this.yearWidget,
    required this.selectedYear,
  }) : super(key: key);

  /// Year - Month - ListOfNotesForThatMonth
  final Map<int, Map<int, List<MonthContainer>?>?>? yearWidget;
  final int selectedYear;

  @override
  State<YearPage> createState() => _YearPageState();
}

class _YearPageState extends State<YearPage> {
  void sortListByMonth(List<MonthContainer> list) {
    // Sort the list by month
    list.sort((a, b) => a.month.compareTo(b.month));
  }

  @override
  Widget build(BuildContext context) {

    if (widget.yearWidget != null && widget.yearWidget![widget.selectedYear] != null && widget.yearWidget![widget.selectedYear]!.isNotEmpty) {
      List<MonthContainer> list = [];
      widget.yearWidget![widget.selectedYear]!.forEach((month, listInMap) {
        if (listInMap != null) {
          list.addAll(listInMap);
        }
      });
      sortListByMonth(list);

      return SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                primary: true,
                padding: const EdgeInsets.all(8),
                crossAxisSpacing: 2,
                mainAxisSpacing: 4,
                crossAxisCount: 3,
                children: list,
              ),
            ),
          ],
        ),
      );
    } else {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: const Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Looks like there is no notes yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

  }
}

class _WholeMonthNotePageState extends State<WholeMonthNotePage> {
  ///Day/Hour/HashSet<notes>
  //HashMap<int, Map<int, HashSet<Note>>>? monthNote;
  /// Day/List(Notes)
  //Map<int, List<Note>?> noteMonthSortedByDay = {};

  List<Note> allMonthNotes = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void sortNotesByDate(List<Note> notes) {
    notes.sort((a, b) =>
        DateTime.parse(a.dateTime).compareTo(DateTime.parse(b.dateTime)));
  }

  void deleteNote(Note note, int day) {
    setState(() {
      allMonthNotes.remove(note);


      if (widget.monthNote != null && widget.monthNote![day] != null) {
        // Create a copy of the map to avoid concurrent modification
        //hour
        Map<int, HashSet<Note>> toDelete = {};

        if (widget.monthNote![day] != null &&
            widget.monthNote![day]!.keys.isNotEmpty) {
          widget.monthNote![day]!.forEach((hour, hourMap) {
            if (widget.monthNote![day]![hour] != null) {
              if (widget.monthNote![day]![hour]!.contains(note)) {
                toDelete.putIfAbsent(hour, () => HashSet()).add(note);
              }
            }
          });
        }
        toDelete.forEach((hour, hashSet) {
          for (var note in hashSet) {
            widget.monthNote![day]![hour]!.remove(note);
            if (widget.monthNote![day]![hour]!.isEmpty) {
              widget.monthNote![day]!.remove(hour);
              if (widget.monthNote![day]!.isEmpty) {
                widget.monthNote!.remove(day);
              }
            }
          }
        });
      }
      // Check if noteMonthSorted is not null and day exists in it
      if(allMonthNotes.isEmpty){
        widget.pageEmpty();
      }

      if (widget.monthNote!.isEmpty) {
        widget.pageEmpty();
      }
    });
  }

  void fillSorted() {
    if (widget.monthNote!.isNotEmpty && widget.monthNote!.keys.isNotEmpty) {
      allMonthNotes = [];
      for (int day in widget.monthNote!.keys) {
        if (widget.monthNote![day] != null &&
            widget.monthNote![day]!.isNotEmpty) {
          for (int hour in widget.monthNote![day]!.keys) {

            if (widget.monthNote![day]![hour] != null &&
                widget.monthNote![day]![hour]!.isNotEmpty) {
              HashSet<Note> hourNotes = widget.monthNote![day]![hour]!;
              if (hourNotes.isNotEmpty) {
                allMonthNotes.addAll(hourNotes);
              }
            } else {
              if (kDebugMode) {
                print('widget.monthNote![$day][$hour] is null or empty');
              }
            }
          }
        }
      }
      sortNotesByDate(allMonthNotes);
    }
  }

  @override
  Widget build(BuildContext context) {
    //monthNote = widget.monthNote;
    fillSorted();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: allMonthNotes.length,
                (BuildContext context, int index) {
                     return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: NoteInstance(note: allMonthNotes[index], dataHandler: widget.dataHandler, deletePressed: () => deleteNote(allMonthNotes[index],DateTime.parse(allMonthNotes[index].dateTime).day)),
                      );


                }

              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// page for displaying when you choose a month
class WholeMonthNotePage extends StatefulWidget {
  final DataHandler dataHandler;
  ///Day/Hour/Notes
  final HashMap<int, Map<int, HashSet<Note>>>? monthNote;
  final VoidCallback pageEmpty;

  const WholeMonthNotePage(
      {required this.pageEmpty, required this.monthNote, super.key, required this.dataHandler});

  @override
  State<WholeMonthNotePage> createState() => _WholeMonthNotePageState();
}

class NoteDayList extends StatefulWidget {
  final DataHandler dataHandler;
  const NoteDayList({
    Key? key,
    required this.day,
    required this.notesForDay,
    required this.deleteNote, required this.dataHandler,
  }) : super(key: key);

  final int day;
  final List<Note> notesForDay;
  final Function(Note, int) deleteNote;

  @override
  State<NoteDayList> createState() => _NoteDayListState();
}
class _NoteDayListState extends State<NoteDayList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.notesForDay.length, // +1 for the header
      itemBuilder: (BuildContext context, int index) {
        // This is a note
        Note note = widget.notesForDay[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: NoteInstance(
            dataHandler: widget.dataHandler,
            note: note,
            deletePressed: () => widget.deleteNote(note, widget.day),
          ),
        );
      },
    );
  }
}

class NoteInstance extends StatefulWidget {
  final DataHandler dataHandler;
  final VoidCallback deletePressed;
  final Note note;

  const NoteInstance({
    Key? key,
    required this.note,
    required this.deletePressed, required this.dataHandler,
  }) : super(key: key);

  @override
  State<NoteInstance> createState() => _NoteInstanceState();
}

class _NoteInstanceState extends State<NoteInstance> {
  bool isPressed = false;

  Future<void> deleteNoteInDatabase(Note note) async {
    await widget.dataHandler.deleteNote(note);
    setState((){
    widget.deletePressed();
    });

  }

  String getDayOfWeek(int dayNumber) {
    const List<String> dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    if (dayNumber >= 1 && dayNumber <= 7) {
      return dayNames[dayNumber - 1];
    } else {
      return 'Invalid Day Number';
    }
  }

  String getMoodTypeInName(int moodType){
    const List<String> moodNames = [
      'Neutral',
      'Angry',
      'Happy',
      'Sad',
      'Fearful',
      'Disgusted'
    ];
    if(moodType >= 0 && moodType < 6){
      return moodNames[moodType];
    } else {
      return 'error';
    }
  }

  reset(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted){
        setState(() {

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(widget.note.dateTime);
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minutes = dateTime.minute.toString().padLeft(2, '0');
    String txt = widget.note.textNote;
    String day = dateTime.day.toString().padLeft(2, '0');
    String dayNamed = getDayOfWeek(dateTime.weekday);
    int moodLevel = widget.note.moodLevel;
    int moodType = widget.note.moodType;
    Color? color;
    Color textColor = Colors.black;
    Color infoTextColor = Colors.black87;



    //angry
    if (widget.note.moodType == 1) {
      color = Colors.red[100];
      if(moodLevel > 2){
        int colorRate = ((moodLevel / 2) * 100).toInt();
        if(colorRate >= 500){
          colorRate = 600;
        }
        color = Colors.red[colorRate] ?? Colors.red[100];
      }
      //happy
    }else if(widget.note.moodType == 2) {
      color = Colors.green[100];
      if(moodLevel > 2){
        int colorRate = ((moodLevel / 2) * 100).toInt();
        if(colorRate >= 500){
          colorRate = 600;
        }
        color = Colors.green[colorRate] ?? Colors.green[100];
      }
      //sad
    } else if(widget.note.moodType == 3) {
      color = Colors.blue[100];
      if(moodLevel > 2){
        int colorRate = ((moodLevel / 2) * 100).toInt();
        if(colorRate >= 500){
          colorRate = 600;
        }
        color = Colors.blue[colorRate] ?? Colors.blue[200];
      }

      //fear
    } else if(widget.note.moodType == 4) {
      color = Colors.black38;

      if(moodLevel > 2){
        switch(moodLevel){
          case 4:
            color = Colors.black38;
            break;
          case 6:
            color = Colors.black54;
            break;
          case 8:
            textColor = Colors.white;
            infoTextColor = Colors.white;
            color = Colors.black87;
            break;
          case 10:
            textColor = Colors.white;
            infoTextColor = Colors.white;
            color = Colors.black;
          break;
        }
      }


      //disgust
    } else if(widget.note.moodType == 5) {
      color = Colors.lime[200];
      if(moodLevel > 2){
        int colorRate = ((moodLevel / 2) * 100).toInt();
        if(colorRate >= 500){
          colorRate = 600;
        }
        color = Colors.lime[colorRate] ?? Colors.lime[200];
      }

    } else {
      color = Colors.grey[100];
    }

    return Dismissible(
      
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      //background: Container(color: Colors.red[300]),
      onDismissed: (direction) async {
        await deleteNoteInDatabase(widget.note);
      },


      child: Container(

        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0),
          // Set the border color
          borderRadius: BorderRadius.circular(5.0),
          color: color,
        ),


        padding: const EdgeInsets.all(8),
        // Add padding for better visibility
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(children: [
              RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: '$hour:$minutes - ',
                    style: TextStyle(color: infoTextColor),
                  ),
                  TextSpan(
                    text: '$dayNamed $day ',
                    style: TextStyle(color: infoTextColor, fontSize: 14),
                  ),
                  TextSpan(

                    text: widget.note.moodType == 0 ? '' : '- ${getMoodTypeInName(moodType)} $moodLevel/10',
                    style: TextStyle(color: infoTextColor,fontSize: 14),
                  )
                ],
              ),
                          ),
              const Spacer(),
              SizedBox(
                height: 20.0, // Adjust this value based on your needs
                width: 20.0, // Adjust this value based on your needs
                child: IconButton(
                  color: textColor,
                  padding: const EdgeInsets.all(0.0),
                  icon: const Icon(Icons.edit),
                  iconSize: 17.0, // Adjust this value based on your needs
                  onPressed: () {
                    showDialog(context: context,
                        builder: (BuildContext context) => 


                      EditNoteDialog(color: color, note: widget.note,dayNamed: dayNamed, moodInName: getMoodTypeInName(moodType),textColor: textColor,dataHandler: widget.dataHandler,reset: reset,),
                    // Handle button press
                    );

                    },
                ),
              ),


            ]

              ,),
            const SizedBox(height: 2,),

            Text(
              txt,
              textAlign: TextAlign.center,
              // Align textNote to the center

              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: textColor,
                // You can customize the font size and other styles here
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditNoteDialog extends StatelessWidget {
  EditNoteDialog({
    super.key,
    required this.color, required this.note, required this.dayNamed, required this.moodInName, required this.textColor, required this.dataHandler, required this.reset,
  });

  final Color? color;
  final Color infoTextColor = Colors.black;
  final Color textColor;
  final Note note;
  final String dayNamed;
  final String moodInName;
  final DataHandler dataHandler;
  final VoidCallback reset;





  final TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    DateTime dateTime = DateTime.parse(note.dateTime);
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minutes = dateTime.minute.toString().padLeft(2, '0');

    String day = dateTime.day.toString().padLeft(2, '0');
    int moodLevel = note.moodLevel;

    myController.text = note.textNote;

    return Padding(
    padding: const EdgeInsets.all(2.0),
    child: DecoratedBox(
    
    
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0), // Set the radius of the rounded corners
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
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: '$hour:$minutes - ',
                        style: TextStyle(color: infoTextColor, fontSize: 20),
                      ),
                      TextSpan(
                        text: '$dayNamed $day ',
                        style: TextStyle(color: infoTextColor, fontSize: 20),
                      ),
                      TextSpan(

                        text: note.moodType == 0 ? '' : '- $moodInName $moodLevel/10',
                        style: TextStyle(color: infoTextColor,fontSize: 20),
                      )
                    ],
                  ),
                ),
                
                Expanded(
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    //autofocus: true,
                    textAlign: TextAlign.center,
                    controller: myController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                      focusColor: color,
                      fillColor: color,
                      hoverColor: color,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),

                      border: const OutlineInputBorder(
                        // Add borders
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        //borderSide: BorderSide(color: Colors.black),

                      ),
                    ),
    
                    style: TextStyle(
                      fontSize: 18.0,
                      height: 1.5,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
    
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            const RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Set zero border radius
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
                          MaterialStateProperty.all<Color>(Colors.green),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            const RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Set zero border radius
                          ),
                        ),
                        onPressed: () async {
                         //Note newNote = Note(textNote: myController.text, dateTime: note.dateTime, moodLevel: note.moodLevel, moodType: note.moodType);

                          note.textNote = myController.text;
                          await dataHandler.updateNote(note);
                          myController.clear();
                          reset();

                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                        child: const Text('Edit'),
                      )
                    ]),
              ],
            ),
          ),
        ),
      ),
    ),
                        );
  }
}

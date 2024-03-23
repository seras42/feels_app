import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../DataHandler.dart';

class DataPage extends StatefulWidget {
  final DataHandler dataHandler;

  const DataPage({super.key, required this.dataHandler});
  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  int selectedYear = 0;

  Widget bottomTitleWidgets(double value, TitleMeta meta) {


    const style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }


  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '\$ ${value + 0.5}',
        style: style,
      ),
    );
  }

  Center notEnoughData(){
    return const Center(child: Text("Not enough data to make a graph yet"));
  }

  ///Happy, Sad, Neutral, Angry, Disgust, Fear
  Map<String, bool> checkBoxes = {
    'Happy': true,
    'Sad': true,
    'Neutral': true,
    'Angry': true,
    'Disgust': true,
    'Fear': true,
  };
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<int, HashMap<int, Map<int, HashSet<Note>>>>>(
        future: widget.dataHandler.getNotesSortedByDay(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null && snapshot.data!.isNotEmpty) {
            Map<int, HashMap<int, Map<int, HashSet<Note>>>> notes = snapshot.data!;
            if (selectedYear == 0) {
              notes.forEach((year, value) {
                if (year > selectedYear) {
                  selectedYear = year;
                }
              });
            }
            Map<int, List<FlSpot>> angryNotesMap = {};
            Map<int, List<FlSpot>> happyNotesMap = {};
            Map<int, List<FlSpot>> sadNotesMap = {};
            Map<int, List<FlSpot>> fearNotesMap = {};
            Map<int, List<FlSpot>> disgustNotesMap = {};
            Map<int, List<FlSpot>> neutralNotesMap = {};


            String yearInString = selectedYear.toString();
            int y=0;

            notes.forEach((int year, HashMap<int, Map<int, HashSet<Note>>> monthMap) {
              monthMap.forEach((int month, Map<int, HashSet<Note>> dayMap) {
                int angryMont = 0;
                int happyMonth = 0;
                int sadMonth =0;
                int fearMonth = 0;
                int disgustMonth = 0;
                int neutralMonth = 0;

                // Iterate over the third-level Map
                dayMap.forEach((int day, HashSet<Note> noteHashSet) {
                  // Iterate over the HashSet
                  for (var note in noteHashSet) {
                    if (note != null) {

                    switch(note.moodType) {
                      case 0:
                        neutralMonth++;
                        break;
                      case 1:
                        angryMont++;
                        break;
                      case 2:
                        happyMonth++;
                        break;
                      case 3:
                        sadMonth++;
                        break;
                      case 4:
                        fearMonth++;
                        break;
                      case 5:
                        disgustMonth++;
                        break;
                    }
                    }
                  }
                }
                );

                if(neutralMonth > y){
                  y = neutralMonth;
                }
                if (angryMont > y){
                  y = angryMont;
                }
                if (happyMonth > y){
                  y = happyMonth;
                }
                if (sadMonth > y){
                  y = sadMonth;
                }
                if (fearMonth > y){
                  y = fearMonth;
                }
                if (disgustMonth > y){
                  y = disgustMonth;
                }


                angryNotesMap.putIfAbsent(year, () => []);
                happyNotesMap.putIfAbsent(year, () => []);
                sadNotesMap.putIfAbsent(year, () => []);
                fearNotesMap.putIfAbsent(year, () => []);
                disgustNotesMap.putIfAbsent(year, () => []);
                neutralNotesMap.putIfAbsent(year, () => []);
                angryNotesMap[year]!
                    .add(FlSpot(month.toDouble(), angryMont.toDouble()));
                happyNotesMap[year]!
                    .add(FlSpot(month.toDouble(), happyMonth.toDouble()));
                sadNotesMap[year]!
                    .add(FlSpot(month.toDouble(), sadMonth.toDouble()));
                fearNotesMap[year]!
                    .add(FlSpot(month.toDouble(), fearMonth.toDouble()));
                disgustNotesMap[year]!
                    .add(FlSpot(month.toDouble(), disgustMonth.toDouble()));
                neutralNotesMap[year]!
                    .add(FlSpot(month.toDouble(), neutralMonth.toDouble()));
              });
            });

            int trunk = ((y~/10)*10);
            int toAdd = ((trunk~/2)~/10)*10;

            y = trunk + toAdd;




              return Scaffold(
                bottomNavigationBar: BottomNavigationBar(
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.arrow_back),
                      label: 'Back',
                    ),
                    BottomNavigationBarItem(
                      icon: Text(yearInString),
                      label: '',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.arrow_forward),
                      label: 'Forward',
                    ),
                  ],
                  onTap: (index) {
                    if (index == 0) {
                      if (notes[selectedYear - 1] != null) {
                        setState(() {
                          selectedYear = selectedYear - 1;
                        });
                      }
                    } else if (index == 2) {
                      if (notes[selectedYear + 1] != null) {
                        setState(() {
                          selectedYear = selectedYear + 1;
                        });
                      }
                    }

                    // Handle taps on the left and right items
                    // You can navigate or perform specific actions based on the index
                  },
                  currentIndex: 1,
                ),


                body: (notes[selectedYear] != null && notes[selectedYear]!.isNotEmpty && notes[selectedYear]!.length > 1 ) ?

                Center(

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      AspectRatio(
                          aspectRatio: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 18,
                              top: 10,
                              bottom: 4,
                            ),
                            child: LineChart(

                              LineChartData(
                                gridData: const FlGridData(
                                  show: true,
                                  drawHorizontalLine: true,
                                  drawVerticalLine: true,
                                  //horizontalInterval: 5.0, // You can adjust this based on your data
                                  //verticalInterval: 1.0,   // You can adjust this based on your data
                                ),
                                lineTouchData: const LineTouchData(enabled: true),
                                lineBarsData: [

                                  LineChartBarData(
                                    spots: checkBoxes['Happy']! ? happyNotesMap[selectedYear]?.toList() ?? [] : [],
                                    isCurved: true,
                                    barWidth: 2,
                                    color: Colors.green[800],
                                    belowBarData: BarAreaData(
                                        show: true,
                                        color: Colors.green.withOpacity(0.5)),
                                    dotData: const FlDotData(
                                      show: false,
                                    ),
                                  ) ,
                                  LineChartBarData(
                                    spots: checkBoxes['Angry']! ? angryNotesMap[selectedYear]?.toList() ?? [] : [],
                                    isCurved: true,
                                    barWidth: 2,
                                    color: Colors.red,
                                    belowBarData: BarAreaData(
                                        show: true, color: Colors.red.withOpacity(0.5)),
                                    dotData: const FlDotData(
                                      show: false,
                                    ),
                                  ),
                                  LineChartBarData(
                                    spots: checkBoxes['Sad']! ? sadNotesMap[selectedYear]?.toList() ?? [] : [],
                                    isCurved: true,
                                    barWidth: 2,
                                    color: Colors.blue[900],
                                    belowBarData: BarAreaData(
                                        show: true, color: Colors.blue.withOpacity(0.5)),
                                    dotData: const FlDotData(
                                      show: false,
                                    ),
                                  ),
                                  LineChartBarData(
                                    spots: checkBoxes['Fear']! ? fearNotesMap[selectedYear]?.toList() ?? [] : [],
                                    isCurved: true,
                                    barWidth: 2,
                                    color: Colors.black54,
                                    belowBarData: BarAreaData(
                                        show: true, color: Colors.black.withOpacity(0.5)),
                                    dotData: const FlDotData(
                                      show: false,
                                    ),
                                  ),
                                  LineChartBarData(
                                    spots: checkBoxes['Disgust']! ? disgustNotesMap[selectedYear]?.toList() ?? [] : [],
                                    isCurved: true,
                                    barWidth: 2,
                                    color: Colors.lime[900],
                                    belowBarData: BarAreaData(
                                        show: true, color: Colors.lime.withOpacity(0.5)),
                                    dotData: const FlDotData(
                                      show: false,
                                    ),
                                  ),
                                  LineChartBarData(
                                    spots: checkBoxes['Neutral']! ? neutralNotesMap[selectedYear]?.toList() ?? [] : [],
                                    isCurved: true,
                                    barWidth: 2,
                                    color: Colors.grey[600],
                                    belowBarData: BarAreaData(
                                        show: true, color: Colors.grey.withOpacity(0.5)),
                                    dotData: const FlDotData(
                                      show: false,
                                    ),
                                  ),


                                ],
                                minY: 0,
                                maxY: y.toDouble(),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                      color: const Color(0xff37434d), width: 0.5),
                                ),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      getTitlesWidget: bottomTitleWidgets,
                                    ),
                                  ),
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      //getTitlesWidget: leftTitleWidgets,
                                      // interval: 5,
                                      reservedSize: 36,
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20,),
                      const Text("Select which emotions to show"),
                      const SizedBox(height: 10,),
                      Center(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              const SizedBox(width: 5,),
                              Expanded(
                                child: CheckBoxText(title: 'Angry', value: checkBoxes['Angry']!, onChanged: (bool? newValue) {
                                  setState(() {
                                    checkBoxes['Angry'] = newValue ?? false;
                                  });
                                }, color: Colors.red,),
                              ),
                              const SizedBox(width: 5,),
                              Expanded(
                                child: CheckBoxText(title: 'Happy', value: checkBoxes['Happy']!, onChanged: (bool? newValue) {
                                  setState(() {
                                    checkBoxes['Happy'] = newValue ?? false;
                                  });
                                }, color: Colors.green,),
                              ),
                              const SizedBox(width: 5,),
                              Expanded(
                                child: CheckBoxText(title: 'Sad', value: checkBoxes['Sad']!, onChanged: (bool? newValue) {
                                  setState(() {
                                    checkBoxes['Sad'] = newValue ?? false;
                                  });
                                }, color: Colors.blue[800] ?? Colors.blue,),
                              ),
                              const SizedBox(width: 5,),

                            ],
                          ),

                        ),
                      ),
                      const SizedBox(height: 10,),

                      Center(
                        child: Container(child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 5,),
                            Expanded(
                              child: CheckBoxText(title: 'Neutral', value: checkBoxes['Neutral']!, onChanged: (bool? newValue) {
                                setState(() {
                                  checkBoxes['Neutral'] = newValue ?? false;
                                });
                              }, color: Colors.grey,),
                            ),
                            const SizedBox(width: 5,),
                            Expanded(
                              child: CheckBoxText(title: 'Disgust', value: checkBoxes['Disgust']!, onChanged: (bool? newValue) {
                                setState(() {
                                  checkBoxes['Disgust'] = newValue ?? false;
                                });
                              }, color: Colors.lime,),
                            ),
                            const SizedBox(width: 5,),
                            Expanded(
                              child: CheckBoxText(title: 'Fear', value: checkBoxes['Fear']!, onChanged: (bool? newValue) {
                                setState(() {
                                  checkBoxes['Fear'] = newValue ?? false;
                                });
                              }, color: Colors.black,),
                            ),
                            const SizedBox(width: 5,),
                          ]
                          ,),
                        ),
                      ),

                    ],
                  ),
                ) : notEnoughData(),
              );

          } else if (snapshot.hasError) {
            // Error handling
            return Text('Error: ${snapshot.error}');
          } else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } else if(snapshot.data == null || snapshot.connectionState == ConnectionState.done && snapshot.connectionState != ConnectionState.waiting){

            return notEnoughData();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });


  }
}

class CheckBoxText extends StatefulWidget {
  const CheckBoxText({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged, required this.color,
  }) : super(key: key);

  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color color;

  @override
  _CheckboxText createState() => _CheckboxText();
}

class _CheckboxText extends State<CheckBoxText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(5), // Make border rounder

      ),
      child: Row(
        children: [
          Text(widget.title, style: const TextStyle(),),
          Checkbox(
            value: widget.value,
            onChanged: widget.onChanged,
            checkColor: widget.color,
              activeColor: widget.color,
          ),
        ],
      ),
    );


  }
}
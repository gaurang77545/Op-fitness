import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/exercisechoosescreen.dart';
import 'package:op_fitnessapp/ExerciseScreen/exercisescreen.dart';
import 'package:op_fitnessapp/MeasureScreen/measurescreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/helpers/workouthelper.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/workoutscreen.dart';
import 'package:op_fitnessapp/customwidgets/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:intl/intl.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

import '../customwidgets/iconbuttonsimple.dart';
import '../customwidgets/text.dart';
import '../exercisenamesvalues.dart';

class StartWorkoutScreen extends StatefulWidget {
  List<Map<String, Map<String, dynamic>>> chosenExercises;
  String workoutname;

  StartWorkoutScreen(
      //this.templates,
      this.chosenExercises,
      this.workoutname);
  // List<Map<String, Map<String, dynamic>>> chosenExercises = [
  //   {
  //     'Dumbell': {
  //       'Sets': 5,
  //       'RepWeight': [
  //         {'weight': 25, 'kg': 20}
  //       ]
  //     }
  //   }
  // ];
  // String workoutname = '';
  

  @override
  State<StartWorkoutScreen> createState() => _StartWorkoutScreenState();
}

class _StartWorkoutScreenState extends State<StartWorkoutScreen> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, Map<String, dynamic>>> chosenExercises = [];
  List<Map<String, dynamic>> templates = [];

  //  [
  //   {
  //     'Dumbell': {
  //       'Sets': 1,
  //       'RepWeight': [
  //         {'kg': 25, 'reps': 20}
  //       ]
  //     }
  //   },
  //   {
  //     'Dumbell': {
  //       'Sets': 1,
  //       'RepWeight': [
  //         {'kg': 25, 'reps': 20}
  //       ]
  //     }
  //   },
  //   {
  //     'Dumbell': {
  //       'Sets': 1,
  //       'RepWeight': [
  //         {'kg': 25, 'reps': 20}
  //       ]
  //     }
  //   }
  // ];
  // List<String> combinedtypesofcategory = [];
  String workoutname = '';
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;
  final dbHelper = DatabaseHelper.instance;
  String exercisecombined = '';
  String repweightcombined = '';
  String perfcombined = '';
  String currtime = '';
  int currhour = 0;
  @override
  void initState() {
    

    chosenExercises = widget.chosenExercises;
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    currhour = DateTime.now().hour;
    if (widget.workoutname.isEmpty) {
      if ((currhour >= 0 && currhour <= 4) ||
          (currhour >= 19 && currhour <= 23) ||
          currhour == 0) {
        widget.workoutname = 'Night Workout';
      }
      if (currhour > 4 && currhour <= 11) {
        widget.workoutname = 'Morning Workout';
      }
      if (currhour > 11 && currhour <= 16) {
        widget.workoutname = 'Noon Workout';
      }
      if (currhour > 16 && currhour < 19) {
        widget.workoutname = 'Evening Workout';
      }
    }

    //templates = widget.templates;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.workoutname.isEmpty) {
      if ((currhour >= 0 && currhour <= 4) ||
          (currhour >= 19 && currhour <= 23) ||
          currhour == 0) {
        widget.workoutname = 'Night Workout';
      }
      if (currhour > 4 && currhour <= 11) {
        widget.workoutname = 'Morning Workout';
      }
      if (currhour > 11 && currhour <= 16) {
        widget.workoutname = 'Noon Workout';
      }
      if (currhour > 16 && currhour < 19) {
        widget.workoutname = 'Evening Workout';
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  void format(List<Map<String, dynamic>> templateser) {
    setState(() {
      for (int i = 0; i < templateser.length; i++) {
        exercisecombined += templateser[i].keys.toList()[0];
        for (int j = 0; j < templateser[i].values.toList()[0]['Sets']; j++) {
          repweightcombined += 'kg' +
              templateser[i]
                  .values
                  .toList()[0]['RepWeight'][j]['kg']
                  .toString() +
              'reps' +
              templateser[i]
                  .values
                  .toList()[0]['RepWeight'][j]['reps']
                  .toString();
          perfcombined += 'performed' +
              templateser[i]
                  .values
                  .toList()[0]['RepWeight'][j]['performed']
                  .toString();
        }
        if (i != templateser.length - 1) {
          repweightcombined += '\n';
          exercisecombined += '\n';
          perfcombined += '\n';
        }
      }
    });
  }

  Future<void> _insert() async {
    if (widget.workoutname.isEmpty) {
      if ((currhour >= 0 && currhour <= 4) ||
          (currhour >= 19 && currhour <= 23) ||
          currhour == 0) {
        widget.workoutname = 'Night Workout';
      }
      if (currhour > 4 && currhour <= 11) {
        widget.workoutname = 'Morning Workout';
      }
      if (currhour > 11 && currhour <= 16) {
        widget.workoutname = 'Noon Workout';
      }
      if (currhour > 16 && currhour < 19) {
        widget.workoutname = 'Evening Workout';
      }
    }
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columncombinedexercise: exercisecombined,
      DatabaseHelper.columncombinedweightreps: repweightcombined,
      DatabaseHelper.workoutname: widget.workoutname,
      DatabaseHelper.columndate: DateTime.now().millisecondsSinceEpoch,
      DatabaseHelper.columnworkouttime: int.parse(currtime),
      DatabaseHelper.columnperformed: perfcombined
      //DatabaseHelper.columnExperience:'Flutter Developer'
    };

    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;
    return Scaffold(
      appBar: AppBar(
        title: TextPlain(
          'Workout',
          color: Colors.black,
        ),
        leading: IconButtonSimple(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        actions: [
          TextButton.icon(
            // <-- TextButton
            onPressed: () async {
              if (didperform() == true) {
                addtemplate(templates);
                format(chosenExercises);

                await _insert();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WorkoutScreen(
                              templates,
                              widget.workoutname,
                              chosenExercises,
                            )));
              } else {
                Fluttertoast.showToast(
                    msg: "Please perform some sets to finish workout",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0 * kh * h);
              }
            },
            icon: Icon(
              Icons.save,
              size: 24.0 * kh * h,
            ),
            label: TextPlain('Save'),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(Constants.padding * kh * h),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: h * 0.02,
            ),
            Container(
              height: h * 0.05,
              child: TextFormField(
                initialValue: widget.workoutname,
                decoration: InputDecoration(
                    //labelText: 'Workout note',

                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0 * kh * h),
                    )),
                onChanged: (val) {
                  setState(() {
                    widget.workoutname = val;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 20 * kh * h),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExerciseChooseScreen(
                                templates,
                                chosenExercises,
                                widget.workoutname,
                                1)),
                      );
                    },
                    child: TextPlain('ADD EXERCISE', color: Colors.blue)),
              ],
            ),
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: (context, snapshot) {
                final value = snapshot.data;
                final displayTime =
                    StopWatchTimer.getDisplayTime(value!, hours: _isHours);

                currtime = StopWatchTimer.getDisplayTime(value,
                    hours: false,
                    minute: false,
                    milliSecond: false,
                    second: true);

                return TextPlain(displayTime,
                    fontSize: 20 * kh * h,
                    fontWeight: FontWeight.bold,
                    color: Colors.green);
              },
            ),
            exercisename(widget.workoutname, chosenExercises)
          ]),
        ),
      ),
    );
  }

  void addtemplate(List<Map<String, dynamic>> templates) {
    if (chosenExercises.length != 0) {
      List<exercise> l = [];
      for (int i = 0; i < chosenExercises.length; i++) {
        setState(() {
          l.add(exercise(
            chosenExercises[i].values.toList()[0]['Sets'],
            chosenExercises[i].keys.toList()[0],
          ));
        });
      }
      setState(() {
        templates.add({'name': widget.workoutname, 'list': l});
      });
    }
  }

  bool didperform() {
    int sum = 0;
    for (int i = 0; i < chosenExercises.length; i++) {
      for (int j = 0; j < chosenExercises[i].values.toList()[0]['Sets']; j++) {
        sum += chosenExercises[i].values.toList()[0]['RepWeight'][j]
            ['performed'] as int;
      }
      if (sum > 0) {
        return true;
      }
    }
    return false;
  }

  Widget exercisename(String name, List<Map<String, Map<String, dynamic>>> l) {
    int totsets = 0;
    for (int i = 0; i < l.length; i++) {
      totsets += l[i].values.toList()[0]['Sets'] as int;
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextPlain(name, color: Colors.blue),
          Container(
            height: 450 + totsets * 20.0,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (ctx, itemer) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextPlain(
                      l[itemer].keys.toList()[0],
                      color: Colors.grey.shade400,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextPlain(
                          'SET',
                          color: Colors.grey.shade400,
                        ),
                        TextPlain(
                          'KG',
                          color: Colors.grey.shade400,
                        ),
                        TextPlain(
                          'REPS',
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(
                          width: w * 0.01,
                        )
                      ],
                    ),
                    Form(
                      //key: _formKey,
                      child: Container(
                        height: 50.0 * l[itemer].values.toList()[0]['Sets'],
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (ctx, item) {
                            Color color = Colors.black;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 10.0 * kh * h),
                                        child: TextPlain(
                                          (item + 1).toString(),
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      Container(
                                        width: w * 0.05,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          initialValue: l[itemer]
                                                      .values
                                                      .toList()[0]['RepWeight']
                                                          [item]['kg']
                                                      .toString() ==
                                                  '0'
                                              ? null
                                              : l[itemer]
                                                  .values
                                                  .toList()[0]['RepWeight']
                                                      [item]['kg']
                                                  .toString(),
                                          onChanged: ((value) {
                                            setState(() {
                                              if (value == '') {
                                                l[itemer].values.toList()[0]
                                                        ['RepWeight'][item]
                                                    ['kg'] = 0;
                                              } else {
                                                l[itemer].values.toList()[0]
                                                        ['RepWeight'][item]
                                                    ['kg'] = int.parse(value);
                                              }
                                            });
                                          }),
                                        ),
                                      ),
                                      Container(
                                        width: w * 0.05,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          initialValue: l[itemer]
                                                      .values
                                                      .toList()[0]['RepWeight']
                                                          [item]['reps']
                                                      .toString() ==
                                                  '0'
                                              ? null
                                              : l[itemer]
                                                  .values
                                                  .toList()[0]['RepWeight']
                                                      [item]['reps']
                                                  .toString(),
                                          onChanged: ((value) {
                                            setState(() {
                                              if (value == '') {
                                                l[itemer].values.toList()[0]
                                                        ['RepWeight'][item]
                                                    ['reps'] = 0;
                                              } else {
                                                l[itemer].values.toList()[0]
                                                        ['RepWeight'][item]
                                                    ['reps'] = int.parse(value);
                                              }
                                            });
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButtonSimple(
                                  onPressed: () {
                                    setState(() {
                                      if ((l[itemer].values.toList()[0]
                                                  ['RepWeight'][item]['reps'] ==
                                              0) ||
                                          (l[itemer].values.toList()[0]
                                                  ['RepWeight'][item]['kg']) ==
                                              0) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Set cannot be completed with an empty rep or weight field",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.grey,
                                            textColor: Colors.white,
                                            fontSize: 16.0 * kh * h);
                                      } else {
                                        l[itemer].values.toList()[0]
                                                    ['RepWeight'][item]
                                                ['performed'] =
                                            1 -
                                                l[itemer].values.toList()[0]
                                                        ['RepWeight'][item]
                                                    ['performed'];
                                      }
                                    });
                                  },
                                  icon: Icon(
                                      Icons.check_circle_outline_outlined,
                                      color: l[itemer].values.toList()[0]
                                                      ['RepWeight'][item]
                                                  ['performed'] ==
                                              1
                                          ? Colors.green
                                          : Colors.black),
                                )
                              ],
                            );
                          },
                          itemCount: l[itemer].values.toList()[0]['Sets'],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 15),
                            ),
                            onPressed: () {
                              setState(() {
                                l[itemer].values.toList()[0]['Sets'] += 1;

                                l[itemer]
                                    .values
                                    .toList()[0]['RepWeight']
                                    .add({'kg': 0, 'reps': 0, 'performed': 0});
                              });
                            },
                            child: TextPlain('ADD SET', color: Colors.blue)),
                      ],
                    ),
                  ],
                );
              },
              itemCount: l.length,
            ),
          )
        ],
      ),
    );
  }
}

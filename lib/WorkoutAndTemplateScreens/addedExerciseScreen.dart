import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/exercisechoosescreen.dart';
import 'package:op_fitnessapp/ExerciseScreen/exercisescreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/helpers/templateshelper.dart';
import 'package:op_fitnessapp/MeasureScreen/measurescreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/workoutscreen.dart';
import 'package:op_fitnessapp/customwidgets/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../customwidgets/text.dart';

class AddedExerciseScreen extends StatefulWidget {
  List<Map<String, Map<String, dynamic>>> chosenExercises;
  String workoutname;
 
  List<Map<String, dynamic>> templates = [];
  
  AddedExerciseScreen(
      this.templates,
      this.chosenExercises,
      this.workoutname,
      );
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
 

  @override
  State<AddedExerciseScreen> createState() => _AddedExerciseScreenState();
}

class _AddedExerciseScreenState extends State<AddedExerciseScreen> {
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

  String workoutname = '';
  final dbHelper = DatabaseHelper.instance;
  String exercisecombined = '';
  String repweightcombined = '';
  List<Map<String, Map<String, dynamic>>> templatesdummy = [];
  @override
  void initState() {
    chosenExercises = widget.chosenExercises;
    templates = widget.templates;

    super.initState();
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
        elevation: 0,
        actions: [
          TextButton.icon(
            // <-- TextButton
            onPressed: () async {
              if (setsrepallfilled() == true) {
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
                            // widget.exercisecat,
                            // widget.categoryimages,
                            // widget.combinedtypesofcategory,
                            // widget.exercisenames
                            )));
              } else {
                Fluttertoast.showToast(
                    msg: "Kg and reps field can't be left empty",
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
        padding: EdgeInsets.all(Constants.padding),
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
                      borderRadius: BorderRadius.circular(10.0 * kh * h),
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
                      textStyle: TextStyle(fontSize: 20.0 * kh * h),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExerciseChooseScreen(
                                templates,
                                chosenExercises,
                                widget.workoutname,
                               )),
                      );
                    },
                    child: TextPlain('ADD EXERCISE', color: Colors.blue)),
              ],
            ),
            exercisename(widget.workoutname, chosenExercises)
          ]),
        ),
      ),
    );
  }

  Future<void> addtemplate(List<Map<String, dynamic>> templates) async {
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
        }
        if (i != templateser.length - 1) {
          repweightcombined += '\n';
          exercisecombined += '\n';
        }
      }
    });
  }

  bool setsrepallfilled() {
    int sum = 0;
    for (int i = 0; i < chosenExercises.length; i++) {
      for (int j = 0; j < chosenExercises[i].values.toList()[0]['Sets']; j++) {
        if ((chosenExercises[i].values.toList()[0]['RepWeight'][j]['kg'] ==
                0) ||
            chosenExercises[i].values.toList()[0]['RepWeight'][j]['reps'] ==
                0) {
          return false;
        }
      }
    }
    return true;
  }

  Future<void> _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columncombinedexercise: exercisecombined,
      DatabaseHelper.columncombinedweightreps: repweightcombined,
      DatabaseHelper.workoutname: widget.workoutname
     
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
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
          TextPlain(
            name,
            color: Colors.blue,
          ),
          Container(
            height: 450 + totsets * 20.0,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (ctx, itemer) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextPlain(l[itemer].keys.toList()[0],
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.bold),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextPlain('SET',
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.bold),
                        TextPlain('KG',
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.bold),
                        TextPlain('REPS',
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.bold),
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
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10.0 * kh * h),
                                  child: TextPlain((item + 1).toString(),
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: w * 0.05,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    onChanged: ((value) {
                                      setState(() {
                                        if (value == '') {
                                          l[itemer].values.toList()[0]
                                              ['RepWeight'][item]['kg'] = 0;
                                        } else {
                                          l[itemer].values.toList()[0]
                                                  ['RepWeight'][item]['kg'] =
                                              int.parse(value);
                                        }
                                      });
                                    }),
                                  ),
                                ),
                                Container(
                                  width: w * 0.05,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    onChanged: ((value) {
                                      setState(() {
                                        if (value == '') {
                                          l[itemer].values.toList()[0]
                                              ['RepWeight'][item]['reps'] = 0;
                                        } else {
                                          l[itemer].values.toList()[0]
                                                  ['RepWeight'][item]['reps'] =
                                              int.parse(value);
                                        }
                                      });
                                    }),
                                  ),
                                ),
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
                              textStyle: TextStyle(fontSize: 15 * kh * h),
                            ),
                            onPressed: () {
                              setState(() {
                                l[itemer].values.toList()[0]['Sets'] += 1;

                                l[itemer]
                                    .values
                                    .toList()[0]['RepWeight']
                                    .add({'kg': 0, 'reps': 0});
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

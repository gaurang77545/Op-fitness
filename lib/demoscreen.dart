import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:op_fitnessapp/bodyfatpercentage.dart';
import 'package:op_fitnessapp/calorieintakechart.dart';
import 'package:op_fitnessapp/exercisechoosescreen.dart';
import 'package:op_fitnessapp/exercisescreen.dart';
import 'package:op_fitnessapp/weightchart.dart';
import 'package:op_fitnessapp/measurescreen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DemoScreen extends StatefulWidget {
  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  List<Map<String, dynamic>> templates = [
    {
      'Around the World': {
        'Sets': 3,
        'RepWeight': [
          {'kg': 1, 'reps': 0},
          {'kg': 12, 'reps': 1},
          {'kg': 2, 'reps': 2}
        ]
      }
    },
    {
      'Back Extension': {
        'Sets': 1,
        'RepWeight': [
          {'kg': 3, 'reps': 0}
        ]
      }
    }
  ];

  String exercisecombined = '';
  String repweightcombined = '';
  void format() {
    print(templates.length);
    setState(() {
      for (int i = 0; i < templates.length; i++) {
        // print(i);
        exercisecombined += templates[i].keys.toList()[0];
        for (int j = 0; j < templates[i].values.toList()[0]['Sets']; j++) {
          repweightcombined += 'kg' +
              templates[i].values.toList()[0]['RepWeight'][j]['kg'].toString() +
              'reps' +
              templates[i]
                  .values
                  .toList()[0]['RepWeight'][j]['reps']
                  .toString();
        }
        if (i != templates.length - 1) {
          repweightcombined += '\n';
          exercisecombined += '\n';
        }
        //repweightcombined+=
      }
    });
    //  print(exercisecombined);
    // print(repweightcombined);
    //print(templates[1].values.toList()[0]['Sets']);
    //print(templates[0].values.toList()[0]['RepWeight'][1]['kg']);
  }

  List<Map<String, dynamic>> templatesdummy = [];
  void seperate() {
    var arr = exercisecombined.split('\n');
    var kgreps = repweightcombined;
    var repsarr = repweightcombined.split('\n');
    // for (int i = 0; i < arr.length; i++) {
    //  String reps = kgreps[i];
    //  String name = arr[i];
    print(arr.length);
    List<int> kg = [];
    for (int i = 0; i < repsarr.length; i++) {
      String name = arr[i];
      print(name);
      print(repsarr);
      kgreps = repsarr[i];
      List<String> kglist = [];
      List<String> repslist = [];
      for (int index = kgreps.indexOf('kg');
          index >= 0;
          index = kgreps.indexOf('kg', index + 1)) {
        int repsindex = kgreps.indexOf('reps', index + 1);
        String kg = kgreps.substring(index + 2, repsindex);
        kglist.add(kg);
        // print('kg' + kg);
      }
      for (int index = kgreps.indexOf('reps');
          index >= 0;
          index = kgreps.indexOf('reps', index + 1)) {
        int kgindex = kgreps.indexOf('kg', index + 1) == -1
            ? kgreps.length
            : kgreps.indexOf('kg', index + 1);
        String reps = kgreps.substring(index + 4, kgindex);
        repslist.add(reps);
        // print('reps' + reps);
      }
      List<Map<String, int>> kgrepslist = [];
      // print(kgreps);
      for (int i = 0; i < kglist.length; i++) {
        kgrepslist
            .add({'kg': int.parse(kglist[i]), 'reps': int.parse(repslist[i])});
      }
      print(kgrepslist);
      templatesdummy.add({
        name: {'Sets': kgrepslist.length, 'RepWeight': kgrepslist}
      });
      print('\n');
    }
    print(templatesdummy);
    print(templates);
    if (templatesdummy.contains(templates)) {
      print('HOOOOOOOOOORAYYYYYYY');
    } // }
    //  print(arr);
    // print(kgreps);
  }

  @override
  void initState() {
    format();
    seperate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        //  print(chosenExercises[0].values.toList()[0]['Sets']);
      }),
    );
  }
}

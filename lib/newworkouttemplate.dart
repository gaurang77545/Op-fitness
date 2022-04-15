import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:op_fitnessapp/bodyfatpercentage.dart';
import 'package:op_fitnessapp/calorieintakechart.dart';
import 'package:op_fitnessapp/exercisescreen.dart';
import 'package:op_fitnessapp/weightchart.dart';
import 'package:op_fitnessapp/measurescreen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkoutTemplateScreen extends StatefulWidget {
  const WorkoutTemplateScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutTemplateScreen> createState() => _WorkoutTemplateScreenState();
}

class _WorkoutTemplateScreenState extends State<WorkoutTemplateScreen> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  String workoutname = '';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'New Workout Template',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: h * 0.02,
          ),
          Container(
            height: h * 0.05,
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Workout note',
                  fillColor: Colors.grey.shade300,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderSide: const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  )),
              onChanged: (val) {
                setState(() {
                  workoutname = val;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {},
                  child: const Text('ADD EXERCISE',
                      style: TextStyle(color: Colors.blue))),
            ],
          )
        ]),
      ),
    );
  }
}

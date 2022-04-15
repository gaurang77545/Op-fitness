import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:op_fitnessapp/bodyfatpercentage.dart';
import 'package:op_fitnessapp/calorieintakechart.dart';
import 'package:op_fitnessapp/exercisescreen.dart';
import 'package:op_fitnessapp/weightchart.dart';
import 'package:op_fitnessapp/measurescreen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      )
    );
  }
}

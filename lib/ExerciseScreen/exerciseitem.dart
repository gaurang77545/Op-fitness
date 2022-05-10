import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_fitnessapp/ExerciseScreen/tabscreens/abouttabscreen.dart';
import 'package:op_fitnessapp/ExerciseScreen/tabscreens/chartstabscreen.dart';
import 'package:op_fitnessapp/ExerciseScreen/tabscreens/historytabscreen.dart';
import 'package:op_fitnessapp/ExerciseScreen/tabscreens/recordscreenfolder/recordstabscreen.dart';
import 'package:op_fitnessapp/customwidgets/text.dart';

import 'tabscreens/recordscreenfolder/recordsclass.dart';

class ExerciseItemScreen extends StatefulWidget {
  //Shows details of each individual exercise upon tap
  String name;
  String instructions;

  ExerciseItemScreen(this.name, this.instructions);

  @override
  State<ExerciseItemScreen> createState() => _ExerciseItemScreenState();
}

class _ExerciseItemScreenState extends State<ExerciseItemScreen> {
  @override
  Widget build(BuildContext context) {
    final instance = Get.put(Records());
    instance.setworkoutname(widget.name);
    instance.gettemplates();
    //print(instance.workouthistorylist);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: TextPlain(
              widget.name,
              color: Colors.black,
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                //  instance.dispose();
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.white,
            bottom: TabBar(
              tabs: [
                Tab(
                  child: TextPlain(
                    "About",
                    color: Colors.black,
                  ),
                ),
                Tab(
                  child: TextPlain(
                    "History",
                    color: Colors.black,
                  ),
                ),
                Tab(
                  child: TextPlain(
                    "Charts",
                    color: Colors.black,
                  ),
                ),
                Tab(
                  child: TextPlain(
                    "Records",
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AboutTabScreen(instructions: widget.instructions),
              HistoryTabScreen(widget.name, instance),
              ChartTabScreen(widget.name,instance),
              RecordTabScreen(widget.name,instance)
            ],
          ),
        ),
      ),
    );
  }
}

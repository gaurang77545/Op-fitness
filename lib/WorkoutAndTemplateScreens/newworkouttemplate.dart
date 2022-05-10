import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/addedExerciseScreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/exercisechoosescreen.dart';
import 'package:op_fitnessapp/ExerciseScreen/exercisescreen.dart';
import 'package:op_fitnessapp/MeasureScreen/measurescreen.dart';
import 'package:op_fitnessapp/customwidgets/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../customwidgets/iconbuttonsimple.dart';
import '../customwidgets/text.dart';
import '../exercisenamesvalues.dart';

class WorkoutTemplateScreen extends StatefulWidget {
  List<Map<String, dynamic>> templates = [];
  
  WorkoutTemplateScreen(this.templates);
  @override
  State<WorkoutTemplateScreen> createState() => _WorkoutTemplateScreenState();
}

class _WorkoutTemplateScreenState extends State<WorkoutTemplateScreen> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
 
  String workoutname = '';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
   
   

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
        backgroundColor: Colors.white,
        leading: IconButtonSimple(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Constants.padding * kh * h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: h * 0.05,
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                    labelText: 'Workout Name',
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
                    workoutname = val;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return null;
                  }
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20 * kh * h),
                  ),
                  onPressed: () async {
                    if (_controller.text != '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExerciseChooseScreen(
                                  widget.templates,
                                  [],
                                  workoutname,
                                )),
                      );
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please enter the template name",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: TextPlain('ADD EXERCISE', color: Colors.blue)),
            ],
          )
        ]),
      ),
    );
  }
}

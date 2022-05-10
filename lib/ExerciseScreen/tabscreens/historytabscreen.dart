import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_fitnessapp/ExerciseScreen/tabscreens/recordscreenfolder/recordsclass.dart';
import 'package:op_fitnessapp/MeasureScreen/calorieintakechart/calorieintakechart.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/exercisechoosescreen.dart';
import 'package:op_fitnessapp/ExerciseScreen/exercisescreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/newworkouttemplate.dart';
import 'package:op_fitnessapp/MeasureScreen/weightchart/weightchart.dart';
import 'package:op_fitnessapp/MeasureScreen/measurescreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/helpers/workouthelper.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../customwidgets/constants.dart';
import '../../customwidgets/text.dart';

class HistoryTabScreen extends StatefulWidget {
  String workoutname;
  Records instance;
  // List<Map<String, Map<String, dynamic>>> newtemplates = [];

  // List<Map<String, dynamic>> templates = [
  //   // {Format of stored templates
  //   //   'name': 'Evening Workout',
  //   //
  //   //   'list': [
  //   //     exercise(1, 'Pendlay Row(Barbell'),
  //   //     exercise(2, 'Pistol Squat'),
  //   //     exercise(1, 'Pendlay Row(Barbell'),
  //   //     exercise(2, 'Pistol Squat'),
  //   //   ]
  //   // },
  //   // {
  //   //   'name': 'Evening Workout',
  //   //
  //   //   'list': [
  //   //     exercise(1, 'Pendlay Row(Barbell'),
  //   //     exercise(2, 'Pistol Squat'),
  //   //   ]
  //   // },
  //   // {
  //   //   'name': 'Evening Workout',
  //   //
  //   //   'list': [
  //   //     exercise(1, 'Pendlay Row(Barbell'),
  //   //     exercise(2, 'Pistol Squat'),
  //   //     exercise(1, 'Pendlay Row(Barbell'),
  //   //     exercise(2, 'Pistol Squat'),
  //   //   ]
  //   // },
  // ];

  HistoryTabScreen(this.workoutname, this.instance);
  @override
  State<HistoryTabScreen> createState() => _HistoryTabScreenState();
}

class _HistoryTabScreenState extends State<HistoryTabScreen>
    with AutomaticKeepAliveClientMixin {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  var instance;

  @override
  void initState() {
    instance = widget.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;
    //print(instance.workouthistorylist);
    return Obx(
      () => Scaffold(
        body: instance.loading.toString() == "true"
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: instance.gettemplates,
                child: Padding(
                  padding: EdgeInsets.all(Constants.padding * kh * h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: h * 0.005,
                      ),

                      //template('Evening Workout', '14', l)
                      templatelist(
                        instance.workouthistorylist,
                        instance.historydummy,
                        widget.workoutname,
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget template(
      String title,
      String date,
      String workouttime,
      List<exercise> l,
      List<Map<String, Map<String, dynamic>>> chosenExercises,
      String workoutname,
      int index) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Constants.bordercolor,
                width: Constants.borderwidth * kw * w),
            borderRadius: BorderRadius.all(
              Radius.circular(Constants.circularadiussmall * kh * h),
            )),
        child: Padding(
          padding: EdgeInsets.all(8.0 * kh * h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextPlain(
                  title,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: h * 0.006,
                ),
                TextPlain(
                  date,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(
                  height: h * 0.006,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.timer,
                      size: 12 * kh * h,
                    ),
                    SizedBox(
                      width: w * 0.02,
                    ),
                    TextPlain(workouttime, fontWeight: FontWeight.w700)
                  ],
                ),
                SizedBox(
                  height: h * 0.006,
                ),
                TextPlain(
                  'Sets performed',
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  height: h * 0.006,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: l.length * 15,
                      //padding: const EdgeInsets.all(10),
                      child: VerticalDivider(
                        color: Colors.black,
                        thickness: 3 * kw * w,
                        indent: 0,
                        endIndent: 0,
                        width: 20 * kw * w,
                      ),
                    ),
                    Container(
                      child: Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (ctx, item) {
                            return Row(
                              children: [
                                TextPlain(
                                  '(+ ' +
                                      l[item].weight.toString() +
                                      ' kg)'
                                          ' x ' +
                                      '  ',
                                  fontSize: 12 * kh * h,
                                  fontWeight: FontWeight.w400,
                                ),
                                SizedBox(
                                  width: w * 0.001,
                                ),
                                TextPlain(
                                  l[item].reps.toString(),
                                  fontSize: 12 * kh * h,
                                  fontWeight: FontWeight.w400,
                                )
                              ],
                            );
                          },
                          itemCount: l.length,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget templatelist(
    List<Map<String, dynamic>> l,
    List<Map<String, Map<String, dynamic>>> chosenExercises,
    String workoutname,
  ) {
    return Container(
      child: Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (ctx, item) {
            return Column(
              children: [
                // template(l[item]['name'],
                //     l[item]['list']),
                template(
                    l[item]['name'],
                    instance.formattedate(l[item]['date']),
                    l[item]['time'].toString() + 's',
                    l[item]['list'],
                    chosenExercises,
                    workoutname,
                    item),
                SizedBox(
                  height: h * 0.02,
                )
              ],
            );
          },
          itemCount: l.length,
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive

  bool get wantKeepAlive => true;
}

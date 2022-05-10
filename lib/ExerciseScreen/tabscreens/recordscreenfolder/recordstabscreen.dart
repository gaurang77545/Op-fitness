import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:op_fitnessapp/ExerciseScreen/tabscreens/recordscreenfolder/recordhistoryscreen.dart';
import 'package:op_fitnessapp/ExerciseScreen/tabscreens/recordscreenfolder/recordsclass.dart';
import 'package:op_fitnessapp/customwidgets/constants.dart';
import 'package:op_fitnessapp/customwidgets/text.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/helpers/workouthelper.dart';

class RecordTabScreen extends StatefulWidget {
  String workoutname;
  Records instance;
  RecordTabScreen(this.workoutname, this.instance);

  @override
  State<RecordTabScreen> createState() => _RecordTabScreenState();
}

class _RecordTabScreenState extends State<RecordTabScreen>
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
    instance.gettemplates();
    return Obx(
      () => Scaffold(
          body: instance.loading.toString() == "true"
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: instance.gettemplates,
                  child: Padding(
                    padding: EdgeInsets.all(Constants.padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextPlain(
                          'PERSONAL RECORDS',
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        singledetailrow(
                            'Max reps', instance.maxrepsvalue.value),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        singledetailrow(
                            'Max weight added', instance.maxweightvalue.value),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        Container(
                          width: w,
                          child: TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RecordHistoryScreen(
                                          widget.workoutname,
                                          instance.maxrepsarr,
                                          instance.maxweightarr,
                                          widget.instance)));
                            },
                            child: TextPlain('VIEW RECORDS HISTORY'),
                          ),
                        ),
                        TextPlain(
                          'LIFETIME STATS',
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        singledetailrow('Total reps', instance.totalreps.value),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        singledetailrow('Total Weight Added',
                            instance.totalweightadded.value),
                      ],
                    ),
                  ),
                )),
    );
  }

  Widget singledetailrow(String title, int count) {
    return Padding(
      padding: EdgeInsets.all(Constants.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextPlain(
            title,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          TextPlain(
            count.toString(),
            fontWeight: FontWeight.w400,
            color: Colors.black,
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive

  bool get wantKeepAlive => true;
}

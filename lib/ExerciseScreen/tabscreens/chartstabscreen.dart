import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:op_fitnessapp/ExerciseScreen/tabscreens/recordscreenfolder/recordsclass.dart';
import 'package:op_fitnessapp/ExerciseScreen/tabscreens/recordscreenfolder/recordstabscreen.dart';
import 'package:op_fitnessapp/customwidgets/text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../../customwidgets/constants.dart';

class ChartTabScreen extends StatefulWidget {
  String workoutname;
  ChartTabScreen(this.workoutname);

  @override
  State<ChartTabScreen> createState() => _ChartTabScreenState();
}

class _ChartTabScreenState extends State<ChartTabScreen> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  var instance;
  @override
  void initState() {
    // gettemplates();
    instance = Get.put(Records(widget.workoutname));
    instance.gettemplates();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;
    return Obx(
      () => Scaffold(
        body: instance.loading.toString() == "true"
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
              padding:  EdgeInsets.all(Constants.padding),
              child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextPlain(
                        'Max Reps',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      Container(
                        height: h * 0.35,
                        margin: EdgeInsets.all(5 * kh * h),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: Constants.borderwidth * kw * w,
                                color: Constants.bordercolor)),
                        width: w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10 * kh * h, vertical: 20 * kh * h),
                        child: SfCartesianChart(
                          //creates chart
                          primaryXAxis: CategoryAxis(
                              title: AxisTitle(text: 'Date'),
                              edgeLabelPlacement: EdgeLabelPlacement.shift),
                          primaryYAxis: NumericAxis(
                              title: AxisTitle(text: 'Max Reps'),
                              decimalPlaces: 0,
                              desiredIntervals: 8,
                              maximum: 100,
                              labelFormat: '{value}',
                              edgeLabelPlacement: EdgeLabelPlacement.shift),
                          //title: ChartTitle(text: 'Max Reps()'),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries<maxreps, String>>[
                            LineSeries<maxreps, String>(
                              dataSource: instance.maxrepsarr,
                              xValueMapper: (maxreps item, _) =>
                                  instance.formattedate(item
                                      .date), //formatting date to look like date+month
                              yValueMapper: (maxreps item, _) => item.reps,
                              name: 'Max Reps',
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true),
                            ),
                          ],
                        ),
                      ),
                      TextPlain(
                        'Max Weight',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      Container(
                        height: h * 0.35,
                        margin: EdgeInsets.all(5 * kh * h),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: Constants.borderwidth * kw * w,
                                color: Constants.bordercolor)),
                        width: w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10 * kh * h, vertical: 20 * kh * h),
                        child: SfCartesianChart(
                          //creates chart
                          primaryXAxis: CategoryAxis(
                              title: AxisTitle(text: 'Date'),
                              edgeLabelPlacement: EdgeLabelPlacement.shift),
                          primaryYAxis: NumericAxis(
                              title: AxisTitle(text: 'Max Weight'),
                              decimalPlaces: 0,
                              desiredIntervals: 8,
                              maximum: 100,
                              labelFormat: '{value} kg',
                              edgeLabelPlacement: EdgeLabelPlacement.shift),
                          //title: ChartTitle(text: 'Max Reps()'),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries<maxweight, String>>[
                            LineSeries<maxweight, String>(
                              dataSource: instance.maxweightarr,
                              xValueMapper: (maxweight item, _) =>
                                  instance.formattedate(item
                                      .date), //formatting date to look like date+month
                              yValueMapper: (maxweight item, _) => item.weight,
                              name: 'Max Weight',
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ),
      ),
    );
  }
}

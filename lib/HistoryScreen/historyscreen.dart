import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:op_fitnessapp/MeasureScreen/calorieintakechart/calorieintakechart.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/exercisechoosescreen.dart';
import 'package:op_fitnessapp/ExerciseScreen/exercisescreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/newworkouttemplate.dart';
import 'package:op_fitnessapp/MeasureScreen/weightchart/weightchart.dart';
import 'package:op_fitnessapp/MeasureScreen/measurescreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/helpers/workouthelper.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../customwidgets/constants.dart';
import '../customwidgets/text.dart';

class HistoryScreen extends StatefulWidget {
  String workoutname;
  List<Map<String, Map<String, dynamic>>> newtemplates = [];
  List<Map<String, String>> exercisecat;
  List<Image> categoryimages = [];
  List<String> exercisenames = [];
  List<String> combinedtypesofcategory = [];
  List<Map<String, dynamic>> templates = [
    // {
    //   'name': 'Evening Workout',
    //
    //   'list': [
    //     exercise(1, 'Pendlay Row(Barbell'),
    //     exercise(2, 'Pistol Squat'),
    //     exercise(1, 'Pendlay Row(Barbell'),
    //     exercise(2, 'Pistol Squat'),
    //   ]
    // },
    // {
    //   'name': 'Evening Workout',
    //
    //   'list': [
    //     exercise(1, 'Pendlay Row(Barbell'),
    //     exercise(2, 'Pistol Squat'),
    //   ]
    // },
    // {
    //   'name': 'Evening Workout',
    //
    //   'list': [
    //     exercise(1, 'Pendlay Row(Barbell'),
    //     exercise(2, 'Pistol Squat'),
    //     exercise(1, 'Pendlay Row(Barbell'),
    //     exercise(2, 'Pistol Squat'),
    //   ]
    // },
  ];

  HistoryScreen(
      this.templates,
      this.workoutname,
      this.newtemplates,
      this.exercisecat,
      this.categoryimages,
      this.combinedtypesofcategory,
      this.exercisenames);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with AutomaticKeepAliveClientMixin {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> workouthistorylist = [];
  List<Map<String, Map<String, dynamic>>> historydummy = [];
  String exercisecombined = '';
  String repweightcombined = '';
  String perfcombined = '';
  bool loading = true;
  @override
  void initState() {
    gettemplates();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // addtemplate(widget.templates);
    gettemplates();
    print(widget.templates);
    print(widget.newtemplates);
    super.didChangeDependencies();
  }
  

  Future<void> gettemplates() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows: WORKOUT SCREEN');
    print(allRows);
    repweightcombined = '';
    exercisecombined = '';
    workouthistorylist = [];
    allRows.forEach((row) {
      setState(() {
        repweightcombined =
            row['combinedweightreps'] == null ? '' : row['combinedweightreps'];
        exercisecombined =
            row['combinedexercise'] == null ? '' : row['combinedexercise'];
        perfcombined = row['performed'] == null ? '' : row['performed'];
        if (repweightcombined != '' ||
            exercisecombined != '' ||
            perfcombined != '') {
          seperate();

          if (historydummy.length != 0) {
            List<exercise> l = [];
            //bool workoutperformed = false;
            for (int i = 0; i < historydummy.length; i++) {
              int sets = 0;
              for (int j = 0;
                  j < historydummy[i].values.toList()[0]['Sets'];
                  j++) {
                // print(historydummy[i].values.toList()[0]['RepWeight'][j]
                //     ['performed']);
                if (historydummy[i].values.toList()[0]['RepWeight'][j]
                        ['performed'] ==
                    1) {
                  setState(() {
                    sets++;
                  });
                  // print('REACHED');
                }
              }
              setState(() {
                l.add(exercise(
                  //historydummy[i].values.toList()[0]['Sets'],
                  sets,
                  historydummy[i].keys.toList()[0],
                ));
              });
            }

            historydummy = [];
            setState(() {
              workouthistorylist.add({
                'name': row['workoutname'],
                'time': row['workouttime'].toString(),
                'date': DateTime.fromMillisecondsSinceEpoch(row['date'] * 1000),
                'list': l
              });
            });
          }
        }
      });
    });

    setState(() {
      loading = false;
    });
  }

  String formattedate(DateTime date) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    String num = date.day.toString();
    String month = months[date.month - 1].substring(0, 3);
    String num_month = num + '  ' + month + '    ';
    String time = date.hour.toString() + ":" + date.minute.toString();
    return num_month;
  }

  Future<void> gettemplatesindex(int i) async {
    final allRows = await dbHelper.queryAllRows();

    // print('query all rows:');
    // print(allRows);
    repweightcombined = '';
    exercisecombined = '';
    perfcombined = '';
    var row = allRows[i];
    setState(() {
      repweightcombined =
          row['combinedweightreps'] == null ? '' : row['combinedweightreps'];
      exercisecombined =
          row['combinedexercise'] == null ? '' : row['combinedexercise'];
      perfcombined = row['performed'] == null ? '' : row['performed'];
      if (repweightcombined != '' ||
          exercisecombined != '' ||
          perfcombined != '') {
        seperate();
      }
    });
  }

  void seperate() {
    var arr = exercisecombined.split('\n');
    var kgreps = repweightcombined;
    var repsarr = repweightcombined.split('\n');
    var perf = perfcombined;
    var perfarr = perfcombined.split('\n');
    // print(' PERFarr');
    // print(perfcombined);
    //print(arr.length);
    List<int> kg = [];
    for (int i = 0; i < repsarr.length; i++) {
      String name = arr[i];
      //print(name);
      //print(repsarr);
      kgreps = repsarr[i];
      perf = perfarr[i];
      List<String> kglist = [];
      List<String> repslist = [];
      List<String> perflist = [];
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

      for (int index = perf.indexOf('performed');
          index >= 0;
          index = perf.indexOf('performed', index + 1)) {
        int perfindex = perf.indexOf('performed', index + 1) == -1
            ? perf.length
            : perf.indexOf('performed', index + 1);
        //print(perfindex);
        String performed = perf.substring(index + 9, perfindex);

        perflist.add(performed);
        // print('kg' + kg);
      }
      // print(perflist);
      List<Map<String, int>> kgrepslist = [];
      // print(kgreps);
      // print('PERFLISTTTTT');
      // print(perflist);
      for (int i = 0; i < kglist.length; i++) {
        kgrepslist.add({
          'kg': int.parse(kglist[i]),
          'reps': int.parse(repslist[i]),
          'performed': perflist[i] == null ? 0 : int.parse(perflist[i])
        });
      }
      //print(kgrepslist);
      historydummy.add({
        name: {'Sets': kgrepslist.length, 'RepWeight': kgrepslist}
      });
      setState(() {});
      //print('\n');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;

    return Scaffold(
      appBar: AppBar(
        title: TextPlain(
          'History',
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
            onRefresh: gettemplates,
            
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
                      workouthistorylist,
                      historydummy,
                      widget.workoutname,
                      widget.exercisecat,
                      widget.categoryimages,
                      widget.combinedtypesofcategory,
                      widget.exercisenames,
                    )
                  ],
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
      List<Map<String, String>> exercisecat,
      List<Image> categoryimages,
      List<String> combinedtypesofcategory,
      List<String> exercisenames,
      int index) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Constants.bordercolor,
              width: Constants.borderwidth*kw*w
            ),
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
                  height: h * 0.01,
                ),
                TextPlain(
                  date,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(
                  height: h * 0.01,
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
                  height: h * 0.01,
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
                                  l[item].count.toString() + ' x ' + '  ',
                                  fontSize: 12 * kh * h,
                                  fontWeight: FontWeight.w400,
                                ),
                                SizedBox(
                                  width: w * 0.001,
                                ),
                                TextPlain(
                                  l[item].name,
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
    List<Map<String, String>> exercisecat,
    List<Image> categoryimages,
    List<String> combinedtypesofcategory,
    List<String> exercisenames,
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
                    formattedate(l[item]['date']),
                    l[item]['time'].toString() + 's',
                    l[item]['list'],
                    chosenExercises,
                    workoutname,
                    exercisecat,
                    categoryimages,
                    combinedtypesofcategory,
                    exercisenames,
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

class exercise {
  int count;
  String name;
  exercise(this.count, this.name);
}

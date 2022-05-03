import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/exercisechoosescreen.dart';
import 'package:op_fitnessapp/ExerciseScreen/exercisescreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/newworkouttemplate.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/startworkoutscreen.dart';
import 'package:op_fitnessapp/MeasureScreen/measurescreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/helpers/templateshelper.dart';
import 'package:op_fitnessapp/customwidgets/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../customwidgets/iconbuttonsimple.dart';

import '../customwidgets/text.dart';

class WorkoutScreen extends StatefulWidget {
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

    //   'list': [
    //     exercise(1, 'Pendlay Row(Barbell'),
    //     exercise(2, 'Pistol Squat'),
    //     exercise(1, 'Pendlay Row(Barbell'),
    //     exercise(2, 'Pistol Squat'),
    //   ]
    // },
  ];

  WorkoutScreen(
      this.templates,
      this.workoutname,
      this.newtemplates,
      this.exercisecat,
      this.categoryimages,
      this.combinedtypesofcategory,
      this.exercisenames);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> templateslistall = [];
  List<Map<String, Map<String, dynamic>>> templatesdummy = [];
  String exercisecombined = '';
  String repweightcombined = '';
  @override
  void initState() {
    gettemplates();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // addtemplate(widget.templates);
    print(widget.templates);
    print(widget.newtemplates);
    super.didChangeDependencies();
  }

  Future<void> gettemplates() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    print(allRows);
    repweightcombined = '';
    exercisecombined = '';
    allRows.forEach((row) {
      setState(() {
        repweightcombined =
            row['combinedweightreps'] == null ? '' : row['combinedweightreps'];
        exercisecombined =
            row['combinedexercise'] == null ? '' : row['combinedexercise'];
        if (repweightcombined != '' || exercisecombined != '') {
          seperate();
          if (templatesdummy.length != 0) {
            List<exercise> l = [];
            for (int i = 0; i < templatesdummy.length; i++) {
              setState(() {
                l.add(exercise(
                  templatesdummy[i].values.toList()[0]['Sets'],
                  templatesdummy[i].keys.toList()[0],
                ));
              });
            }
            templatesdummy = [];
            setState(() {
              templateslistall.add({'name': row['workoutname'], 'list': l});
            });
          }
        }
      });
    });
  }

  Future<void> gettemplatesindex(int i) async {
    final allRows = await dbHelper.queryAllRows();

    // print('query all rows:');
    // print(allRows);
    repweightcombined = '';
    exercisecombined = '';
    var row = allRows[i];
    setState(() {
      repweightcombined =
          row['combinedweightreps'] == null ? '' : row['combinedweightreps'];
      exercisecombined =
          row['combinedexercise'] == null ? '' : row['combinedexercise'];
      if (repweightcombined != '' || exercisecombined != '') {
        seperate();
      }
    });
  }

  void seperate() {
    var arr = exercisecombined.split('\n');
    var kgreps = repweightcombined;
    var repsarr = repweightcombined.split('\n');
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

      setState(() {});
      print('\n');
    }
    // print('TEMPLATES DUMMY');
    // print(templatesdummy);
    // }
    //  print(arr);
    // print(kgreps);
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
      ),
      body: Padding(
        padding: EdgeInsets.all(Constants.padding * kh * h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextPlain(
              'QUICK START',
              fontWeight: FontWeight.w400,
              fontSize: 12 * kh * h,
            ),
            SizedBox(
              height: h * 0.005,
            ),
            Container(
              width: w,
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseChooseScreen([], [],
                          widget.workoutname,
                          widget.exercisecat,
                          widget.categoryimages,
                          widget.combinedtypesofcategory,
                          widget.exercisenames,
                          1),
                    ),
                  );
                },
                child: TextPlain('START AN EMPTY WORKOUT'),
              ),
            ),
            SizedBox(
              height: h * 0.005,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextPlain(
                  'MY TEMPLATES',
                  fontWeight: FontWeight.w400,
                  fontSize: 12 * kh * h,
                ),
                IconButtonSimple(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutTemplateScreen(
                            templateslistall,
                            widget.exercisecat,
                            widget.categoryimages,
                            widget.combinedtypesofcategory,
                            widget.exercisenames),
                      ),
                    ).then((value) => gettemplates());
                    gettemplates();
                    //print(templates);
                    //print(widget.templates);
                    //addtemplate(widget.templates);
                    //print(widget.templates);
                  },
                  icon: Icon(Icons.add),
                )
              ],
            ),
            SizedBox(
              height: h * 0.005,
            ),
            //template('Evening Workout', '14', l)
            templatelist(
              templateslistall,
              templatesdummy,
              widget.workoutname,
              widget.exercisecat,
              widget.categoryimages,
              widget.combinedtypesofcategory,
              widget.exercisenames,
            )
          ],
        ),
      ),
    );
  }

  Widget template(
      String title,
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
              width: Constants.borderwidth,
              color: Constants.bordercolor,
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
                                TextPlain(l[item].name,
                                    fontSize: 12 * kh * h,
                                    fontWeight: FontWeight.w400)
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
      onTap: () async {
        await gettemplatesindex(index);
        print('CHOSEN EXERCISES');
        print(chosenExercises);
        for (int i = 0; i < chosenExercises.length; i++) {
          for (int j = 0;
              j < chosenExercises[i].values.toList()[0]['Sets'];
              j++) {
            chosenExercises[i].values.toList()[0]['RepWeight'][j]['performed'] =
                0;
          }
        }
        print(chosenExercises);
        print('TEMPLATE LIST');
        print(templateslistall);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StartWorkoutScreen(
                chosenExercises,
                templateslistall[index]['name'],
                exercisecat,
                categoryimages,
                combinedtypesofcategory,
                exercisenames),
          ),
        ).then((value) => templatesdummy = []);
      },
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
                //
                //     l[item]['list']),
                template(
                    l[item]['name'],
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
}

class exercise {
  int count;
  String name;
  exercise(this.count, this.name);
}

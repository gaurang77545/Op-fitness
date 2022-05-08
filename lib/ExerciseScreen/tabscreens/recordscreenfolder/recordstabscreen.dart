import 'package:flutter/material.dart';
import 'package:op_fitnessapp/ExerciseScreen/tabscreens/recordscreenfolder/recordhistoryscreen.dart';
import 'package:op_fitnessapp/customwidgets/constants.dart';
import 'package:op_fitnessapp/customwidgets/text.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/helpers/workouthelper.dart';

class RecordTabScreen extends StatefulWidget {
  String workoutname;
  List<Map<String, Map<String, dynamic>>> newtemplates = [];

  List<Map<String, dynamic>> templates = [
    // {Format of stored templates
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
  RecordTabScreen(
    this.workoutname,
  );

  @override
  State<RecordTabScreen> createState() => _RecordTabScreenState();
}

class _RecordTabScreenState extends State<RecordTabScreen>
    with AutomaticKeepAliveClientMixin {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> workouthistorylist =
      []; //List of history templates
  List<Map<String, Map<String, dynamic>>> historydummy = [];
  String exercisecombined = '';
  String repweightcombined = '';
  String perfcombined = '';
  bool loading = true;
  List<maxreps> maxrepsarr = [];
  List<maxweight> maxweightarr = [];
  int maxrepsvalue = 0;
  int maxweightvalue = 0;
  int totalreps = 0;
  int totalweightadded = 0;
  @override
  void initState() {
    gettemplates();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // addtemplate(widget.templates);
    gettemplates();

    super.didChangeDependencies();
  }

  Future<void> gettemplates() async {
    final allRows = await dbHelper.queryAllRows();

    repweightcombined = '';
    exercisecombined = '';
    workouthistorylist = [];
    maxrepsarr = [];
    maxweightarr = [];
    totalreps = 0;
    totalweightadded = 0;
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
            //bool workoutperformed = false;
            int maxrepscount = 0;
            int maxweightcount = 0;
            for (int i = 0; i < historydummy.length; i++) {
              int sets = 0;
              // print('LLALAL' + historydummy[i].keys.toList()[0].toString());
              if (historydummy[i].keys.toList()[0].toString() ==
                  widget.workoutname.toString()) {
                for (int j = 0;
                    j < historydummy[i].values.toList()[0]['Sets'];
                    j++) {
                  if (historydummy[i].values.toList()[0]['RepWeight'][j]
                          ['performed'] ==
                      1) {
                    totalreps += historydummy[i].values.toList()[0]['RepWeight']
                        [j]['reps'] as int;
                    totalweightadded += (historydummy[i].values.toList()[0]
                            ['RepWeight'][j]['reps'] *
                        historydummy[i].values.toList()[0]['RepWeight'][j]
                            ['kg']) as int;
                    setState(() {
                      if (historydummy[i].values.toList()[0]['RepWeight'][j]
                              ['reps'] >
                          maxrepscount) {
                        maxrepscount = historydummy[i].values.toList()[0]
                            ['RepWeight'][j]['reps'];
                      }
                      if (historydummy[i].values.toList()[0]['RepWeight'][j]
                              ['kg'] >
                          maxweightcount) {
                        maxweightcount = historydummy[i].values.toList()[0]
                            ['RepWeight'][j]['kg'];
                      }
                    });
                  }
                }
              }
            }
            historydummy = [];
            setState(() {
              if (maxrepscount != 0) {
                maxrepsarr.add(maxreps(
                    formattedate(
                        DateTime.fromMillisecondsSinceEpoch(row['date'])),
                    maxrepscount));
              }
              if (maxweightcount != 0) {
                maxweightarr.add(maxweight(
                    formattedate(
                        DateTime.fromMillisecondsSinceEpoch(row['date'])),
                    maxweightcount));
              }
            });
          }
        }
      });
    });

    setState(() {
      loading = false;
    });
   // print(maxrepsarr);
    maxrepscount();
    maxweightcount();
   // print('TOTAL REPS IS ' + totalreps.toString());
   // print('TOTAL REPS IS ' + totalweightadded.toString());
  }

  void maxrepscount() {
    //Find Max rep out of the array
    int max = 0;
    for (int i = 0; i < maxrepsarr.length; i++) {
      if (maxrepsarr[i].reps > max) {
        max = maxrepsarr[i].reps;
      }
    }
    setState(() {
      maxrepsvalue = max;
    });
  }

  void maxweightcount() {
    //Find max weight out of array
    int max = 0;
    for (int i = 0; i < maxweightarr.length; i++) {
      if (maxweightarr[i].weight > max) {
        max = maxweightarr[i].weight;
      }
    }
    setState(() {
      maxweightvalue = max;
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

  void seperate() {
    //split combined exercise and reps weight to get required templates in List Form
    var arr = exercisecombined.split('\n');
    var kgreps = repweightcombined;
    var repsarr = repweightcombined.split('\n');
    var perf = perfcombined;
    var perfarr = perfcombined.split('\n');

    List<int> kg = [];
    for (int i = 0; i < repsarr.length; i++) {
      String name = arr[i];

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
      }
      for (int index = kgreps.indexOf('reps');
          index >= 0;
          index = kgreps.indexOf('reps', index + 1)) {
        int kgindex = kgreps.indexOf('kg', index + 1) == -1
            ? kgreps.length
            : kgreps.indexOf('kg', index + 1);
        String reps = kgreps.substring(index + 4, kgindex);
        repslist.add(reps);
      }

      for (int index = perf.indexOf('performed');
          index >= 0;
          index = perf.indexOf('performed', index + 1)) {
        int perfindex = perf.indexOf('performed', index + 1) == -1
            ? perf.length
            : perf.indexOf('performed', index + 1);

        String performed = perf.substring(index + 9, perfindex);

        perflist.add(performed);
      }

      List<Map<String, int>> kgrepslist = [];

      for (int i = 0; i < kglist.length; i++) {
        kgrepslist.add({
          'kg': int.parse(kglist[i]),
          'reps': int.parse(repslist[i]),
          'performed': perflist[i] == null ? 0 : int.parse(perflist[i])
        });
      }

      historydummy.add({
        name: {'Sets': kgrepslist.length, 'RepWeight': kgrepslist}
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;
    return Scaffold(
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: gettemplates,
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
                      singledetailrow('Max reps', maxrepsvalue),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      singledetailrow('Max weight added', maxweightvalue),
                      SizedBox(
                        height: h * 0.01,
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
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RecordHistoryScreen(
                                        widget.workoutname,
                                        maxrepsarr,
                                        maxweightarr)));
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
                      singledetailrow('Total reps', totalreps),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      singledetailrow('Total Weight Added', totalweightadded),
                    ],
                  ),
                ),
              ));
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

class maxreps {
  String date;
  int reps;
  maxreps(this.date, this.reps);
}

class maxweight {
  String date;
  int weight;
  maxweight(this.date, this.weight);
}

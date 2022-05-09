import 'package:op_fitnessapp/WorkoutAndTemplateScreens/helpers/workouthelper.dart';
import 'package:get/get.dart';

class Records extends GetxController {
  String workoutname;
  final dbHelper = DatabaseHelper.instance;
  List<maxreps> maxrepsarr = <maxreps>[].obs;
  List<maxweight> maxweightarr = <maxweight>[].obs;
  List<Map<String, dynamic>> workouthistorylist =
      <Map<String, dynamic>>[].obs; //List of history templates
  List<Map<String, Map<String, dynamic>>> historydummy =
      <Map<String, Map<String, dynamic>>>[].obs;
  String exercisecombined = '';
  String repweightcombined = '';
  String perfcombined = '';
  var loading = true.obs;

  var maxrepsvalue = 0.obs;
  var maxweightvalue = 0.obs;
  var totalreps = 0.obs;
  var totalweightadded = 0.obs;
  Records(this.workoutname);
  Future<void> gettemplates() async {
    final allRows = await dbHelper.queryAllRows();

    repweightcombined = '';
    exercisecombined = '';
    workouthistorylist = [];
    maxrepsarr = [];
    maxweightarr = [];
    totalreps.value = 0;
    totalweightadded.value = 0;
    allRows.forEach((row) {
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
          List<exercise> l = [];
          for (int i = 0; i < historydummy.length; i++) {
            int sets = 0;
            // print('LLALAL' + historydummy[i].keys.toList()[0].toString());
            if (historydummy[i].keys.toList()[0].toString() ==
                workoutname.toString()) {
              for (int j = 0;
                  j < historydummy[i].values.toList()[0]['Sets'];
                  j++) {
                if (historydummy[i].values.toList()[0]['RepWeight'][j]
                        ['performed'] ==
                    1) {
                  totalreps.value += historydummy[i].values.toList()[0]
                      ['RepWeight'][j]['reps'] as int;
                  totalweightadded.value += (historydummy[i].values.toList()[0]
                          ['RepWeight'][j]['reps'] *
                      historydummy[i].values.toList()[0]['RepWeight'][j]
                          ['kg']) as int;
                  l.add(exercise(
                      //historydummy[i].values.toList()[0]['Sets'],
                      historydummy[i].values.toList()[0]['RepWeight'][j]
                          ['reps'],
                      historydummy[i].values.toList()[0]['RepWeight'][j]
                          ['kg']));
                  if (historydummy[i].values.toList()[0]['RepWeight'][j]
                          ['reps'] >
                      maxrepscount) {
                    maxrepscount = historydummy[i].values.toList()[0]
                        ['RepWeight'][j]['reps'];
                  }
                  if (historydummy[i].values.toList()[0]['RepWeight'][j]['kg'] >
                      maxweightcount) {
                    maxweightcount = historydummy[i].values.toList()[0]
                        ['RepWeight'][j]['kg'];
                  }
                }
              }
            }
          }
          historydummy = [];
          if (l.isNotEmpty) {
            workouthistorylist.add({
              'name': row['workoutname'],
              'time': row['workouttime'].toString(),
              'date': DateTime.fromMillisecondsSinceEpoch(row['date']),
              'list': l
            });
          }
          if (maxrepscount != 0) {
            maxrepsarr.add(maxreps(
                DateTime.fromMillisecondsSinceEpoch(row['date']),
                maxrepscount));
          }
          if (maxweightcount != 0) {
            maxweightarr.add(maxweight(
                DateTime.fromMillisecondsSinceEpoch(row['date']),
                maxweightcount));
          }
        }
      }
    });

    loading.value = false;

    // print(maxrepsarr);
    maxrepscount();
    maxweightcount();
    // print('TOTAL REPS IS ' + totalreps.toString());
    // print('TOTAL REPS IS ' + totalweightadded.toString());
  }

  List<maxreps> get maxrepsarray {
    return maxrepsarr;
  }

  List<maxweight> get maxweightarray {
    return maxweightarr;
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

  void maxrepscount() {
    //Find Max rep out of the array
    int max = 0;
    for (int i = 0; i < maxrepsarr.length; i++) {
      if (maxrepsarr[i].reps > max) {
        max = maxrepsarr[i].reps;
      }
    }

    maxrepsvalue.value = max;
  }

  void maxweightcount() {
    //Find max weight out of array
    int max = 0;
    for (int i = 0; i < maxweightarr.length; i++) {
      if (maxweightarr[i].weight > max) {
        max = maxweightarr[i].weight;
      }
    }

    maxweightvalue.value = max;
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
    }
  }
}

class maxreps {
  DateTime date;
  int reps;
  maxreps(this.date, this.reps);
}

class maxweight {
  DateTime date;
  int weight;
  maxweight(this.date, this.weight);
}

class exercise {
  int reps;
  int weight;
  exercise(this.reps, this.weight);
}

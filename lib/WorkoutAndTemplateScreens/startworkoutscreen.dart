import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/exercisechoosescreen.dart';
import 'package:op_fitnessapp/ExerciseScreen/exercisescreen.dart';
import 'package:op_fitnessapp/MeasureScreen/measurescreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/helpers/workouthelper.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/workoutscreen.dart';
import 'package:op_fitnessapp/customwidgets/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../customwidgets/iconbuttonsimple.dart';
import '../customwidgets/text.dart';

class StartWorkoutScreen extends StatefulWidget {
  List<Map<String, Map<String, dynamic>>> chosenExercises;
  String workoutname;
  List<Map<String, String>> exercisecat;
  //List<Map<String, dynamic>> templates = [];
  List<Image> categoryimages = [];
  List<String> exercisenames = [];
  List<String> combinedtypesofcategory = [];
  StartWorkoutScreen(
      //this.templates,
      this.chosenExercises,
      this.workoutname,
      this.exercisecat,
      this.categoryimages,
      this.combinedtypesofcategory,
      this.exercisenames);
  // List<Map<String, Map<String, dynamic>>> chosenExercises = [
  //   {
  //     'Dumbell': {
  //       'Sets': 5,
  //       'RepWeight': [
  //         {'weight': 25, 'kg': 20}
  //       ]
  //     }
  //   }
  // ];
  // String workoutname = '';
  // StartWorkoutScreen(
  //     {required this.chosenExercises, required this.workoutname});

  @override
  State<StartWorkoutScreen> createState() => _StartWorkoutScreenState();
}

class _StartWorkoutScreenState extends State<StartWorkoutScreen> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  List<String> exercisenames = [
    'Ab Wheel ',
    'Aerobics',
    'Arnold Press (Dumbbell)',
    'Around the World. ',
    'Back Extension',
    'Back Extension (Machine) ',
    'Ball Slams',
    'Battle Ropes',
    'Bench Dip',
    'Bench Press (Barbell) ',
    'Bench Press (Cable)',
    'Bench Press (Dumbbell)',
    'Bench Press (Smith Machine)',
    'Bench Press Close Grip (Barbell)',
    'Bench Press - Wide Grip (Barbell)',
    'Bent Over One Arm Row ()',
    'Bent Over Row (Band)',
    'Bent Over Row (Barbell)',
    'Bent Over Row (Dumbbell) ',
    'Bent Over Row - Underhand (Barbell)',
    'Bicep Curl (Barbell).',
    'Bicep Curl (Cable)',
    'Bicep Curl (Dumbbell)',
    'Bicep Curl (Machine)',
    'Bicycle Crunch',
    'Box Jump',
    'Box Squat (Barbell)',
    'Bulgarian Split Squat',
    'Burpee',
    'Cable Crossover',
    'Cable Crunch',
    'Cable Kickback',
    'Cable Pull Through.',
    'Cable Twist.',
    'Calf Press on Leg Press',
    'Calf Press on Seated Leg Press',
    'Chest Dip',
    'Chest Dip (Assisted)',
    'Chest Fly',
    'Chest Fly (Band)',
    'Chest Fly (Dumbbell) ',
    'Chest Press (Band)',
    'Chest Press (Machine)',
    'Chin Up',
    'Chin Up (Assisted)',
    'Clean (Barbell) ',
    'Clean and Jerk (Barbell)',
    'Climbing',
    'Concentration Curl (Dumbbell)',
    'Cross Body Crunch',
    'Crunch ',
    'Crunch (Machine) ',
    'Crunch (Stability Ball)',
    'Cycling ',
    'Cycling (Indoor)',
    'Deadlift (Band)',
    'Deadlift (Barbell) ',
    'Deadlift (Dumbbell) ',
    'Deadlift (Smith Machine)',
    'Deadlift High Pull (Barbell)',
    'Decline Bench Press (Barbell)',
    'Decline Bench Press (Dumbbell) ',
    'Decline Bench Press (Smith Machine)',
    'Decline Crunch',
    'Deficit Deadlift (Barbell)',
    'Elliptical Machine',
    'Face Pull (Cable).',
    'Flat Knee Raise',
    'Flat Leg Raise',
    'Floor Press (Barbell)',
    'Front Raise (Band)',
    'Front Raise (Barbell) ',
    'Front Raise (Cable)',
    'Front Raise (Dumbbell) ',
    'Front Raise (Plate)',
    'Front Squat (Barbell)',
    'Glute Ham Raise',
    'Glute Kickback (Machine) ',
    'Goblet Squat (Kettlebell)',
    'Good Morning (Barbell)',
    'Hack Squat',
    'Hack Squat (Barbell)',
    'Hammer Curl (Band) ',
    'Hammer Curl (Cable)',
    'Hammer Curl (Dumbbell)',
    'Handstand Push Up ',
    'Hang Clean (Barbell).',
    'Hang Snatch (Barbell) ',
    'Hanging Knee Raise',
    'Hanging Leg Raise.',
    'High Knee Skips',
    'Hiking',
    'Hip Abductor (Machine)',
    'Hip Adductor (Machine)',
    'Hip Thrust (Barbell)',
    'Hip Thrust (Bodyweight)',
    'Incline Bench Press (Barbell) ',
    'Incline Bench Press (Cable)',
    'Incline Bench Press (Dumbbell) ',
    'Incline Bench Press (Smith Machine)',
    'Incline Chest Fly (Dumbbell)',
    'Incline Chest Press (Machine)',
    'Incline Curl (Dumbbell).',
    'Incline Row (Dumbbell)',
    'Inverted Row (Bodyweight)',
    'Iso-Lateral Chest Press (Machine)',
    'Iso-Lateral Row (Machine)',
    'Jackknife Sit Up ',
    'Jump Rope ',
    'Jump Shrug (Barbell)',
    'Jump Squat',
    'Jumping Jack',
    'Kettlebell Swing',
    'Kettlebell Turkish Get Up',
    'Kipping Pull Up ',
    "Knee Raise (Captain's Chair)",
    'Kneeling Pulldown (Band)',
    'Knees to Elbows',
    'Lat Pulldown (Cable)',
    'Lat Pulldown (Machine)',
    'Lat Pulldown (Single Arm) ',
    'Lat Pulldown - Underhand (Band).',
    'Lat Pulldown - Underhand (Cable)',
    'Lat Pulldown - Wide Grip (Cable)',
    'Lateral Box Jump',
    'Lateral Raise (Band)',
    'Lateral Raise (Cable)',
    'Lateral Raise (Dumbbell)',
    'Lateral Raise (Machine)',
    'Leg Extension (Machine) ',
    'Leg Press',
    'Lunge (Barbell)',
    'Lunge (Bodyweight) ',
    'Lunge (Dumbbell)',
    'Lying Leg Curl (Machine)',
    'Mountain Climber',
    'Muscle Up ',
    'Oblique Crunch',
    'Overhead Press (Barbell)',
    'Overhead Press (Cable) ',
    'Overhead Press (Dumbbell)',
    'Overhead Press (Smith Machine)',
    'Overhead Squat (Barbell)',
    'Pec Deck (Machine)',
    'Pendlay Row (Barbell)',
    'Pistol Squat',
    'Plank.',
    'Power Clean',
    'Power Snatch (Barbell)',
    'Preacher Curl (Barbell)',
    'Preacher Curl (Dumbbell)',
    'Preacher Curl (Machine)',
    'Press Under (Barbell)',
    'Pull Up',
    'Pull Up (Assisted) ',
    'Pull Up (Band)',
    'Pullover (Dumbbell)',
    'Pullover (Machine)',
    'Push Press',
    'Push Up',
    'Push Up (Band) ',
    'Push Up (Knees)',
    'Rack Pull (Barbell) ',
    'Reverse Crunch',
    'Reverse Curl (Band)',
    'Reverse Curl (Barbell)',
    'Reverse Curl (Dumbbell) ',
    'Reverse Fly (Cable)',
    'Reverse Fly (Dumbbell)',
    'Reverse Fly (Machine)',
    'Reverse Grip Concentration Curl\n(Dumbbell)',
    'Reverse Plank',
    'Romanian Deadlift (Barbell) ',
    'Romanian Deadlift (Dumbbell)',
    'Rowing (Machine)',
    'Running',
    'Running (Treadmill)',
    'Russian Twist',
    'Seated Calf Raise (Machine)',
    'Seated Calf Raise (Plate Loaded)',
    'Seated Leg Curl (Machine)',
    'Seated Leg Press (Machine)',
    'Seated Overhead Press (Barbell)',
    'Seated Overhead Press (Dumbbell)',
    'Seated Palms Up Wrist Curl\n (Dumbbell)',
    'Seated Row (Cable)',
    'Seated Row (Machine) ',
    'Seated Wide-Grip Row (Cable)',
    'Shoulder Press (Machine)',
    'Shoulder Press (Plate Loaded)',
    'Shrug (Barbell)',
    'Shrug (Dumbbell) ',
    'Shrug (Machine)',
    'Shrug (Smith Machine)',
    'Side Bend (Band) ',
    'Side Bend (Cable)',
    'Side Bend (Dumbbell)',
    'Side Plank',
    'Single Leg Bridge ',
    'Sit Up',
    'Skating ',
    'Skiing',
    'Skullcrusher (Barbell)',
    'Skullcrusher (Dumbbell)',
    'Snatch (Barbell)',
    'Snatch Pull (Barbell)',
    'Snowboarding',
    'Split Jerk (Barbell) ',
    'Squat (Band)',
    'Squat (Barbell) ',
    'Squat (Bodyweight)',
    'Squat (Dumbbell)',
    'Squat (Machine)',
    'Squat (Smith Machine) ',
    'Squat Row (Band)',
    'Standing Calf Raise (Barbell) ',
    'Standing Calf Raise (Bodyweight)',
    'Standing Calf Raise (Dumbbell)',
    'Standing Calf Raise (Machine)',
    'Standing Calf Raise (Smith Machine)',
    'Step-up',
    'Stiff Leg Deadlift (Barbell)',
    'Stiff Leg Deadlift (Dumbbell)',
    'Straight Leg Deadlift (Band)',
    'Stretching',
    'Strict Military Press (Barbell)',
    'Sumo Deadlift (Barbell)',
    'Sumo Deadlift High Pull (Barbell)',
    'Superman ',
    'Swimming',
    'T Bar Row',
    'Thruster (Barbell)',
    'Thruster (Kettlebell)',
    'Toes To Bar ',
    'Torso Rotation (Machine)',
    'Trap Bar Deadlift',
    'Triceps Dip',
    'Triceps Dip (Assisted)',
    'Triceps Extension.',
    'Triceps Extension (Barbell)',
    'Triceps Extension (Cable) ',
    'Triceps Extension (Dumbbell) ',
    'Triceps Extension (Machine)',
    'Triceps Pushdown \n(Cable - Straight Bar)',
    'Upright Row (Barbell)',
    'Upright Row (Cable)',
    'Upright Row (Dumbbell) ',
    'V Up ',
    'Walking ',
    'Wide Pull Up ',
    'Wrist Roller ',
    'Yoga ',
    'Zercher Squat (Barbell)'
  ];
  List<String> exercisecategories = [
    'Core',
    'Cardio',
    'Shoulders',
    'Chest',
    'Back',
    'Back',
    'Full body',
    'Cardio',
    'Arms',
    'Chest',
    'Chest',
    'Chest',
    'Chest',
    'Arms',
    'Chest',
    'Back',
    'Back',
    'Back',
    'Back',
    'Back',
    'Arms',
    'Arms',
    'Arms',
    'Arms',
    'Core',
    'Legs',
    'Legs',
    'Legs',
    'Full body',
    'Chest',
    'Core',
    'Arms',
    'Legs',
    'Core',
    'Legs',
    'Legs',
    'Chest',
    'Chest',
    'Chest',
    'Chest',
    'Chest',
    'Chest',
    'Chest',
    'Back',
    'Back',
    'Olympic',
    'Olympic',
    'Cardio',
    'Arms',
    'Core',
    'Core',
    'Core',
    'Core',
    'Cardio',
    'Cardio',
    'Legs',
    'Back',
    'Legs',
    'Legs',
    'Olympic',
    'Chest',
    'Chest',
    'Chest',
    'Core',
    'Legs',
    'Cardio',
    'Shoulders',
    'Core',
    'Core',
    'Chest',
    'Shoulders',
    'Shoulders',
    'Shoulders',
    'Shoulders',
    'Shoulders',
    'Legs',
    'Legs',
    'Legs',
    'Legs',
    'Back',
    'Legs',
    'Legs',
    'Arms',
    'Arms',
    'Arms',
    'Legs',
    'Olympic',
    'Olympic',
    'Core',
    'Core',
    'Legs',
    'Cardio',
    'Legs',
    'Legs',
    'Legs',
    'Legs',
    'Chest',
    'Chest',
    'Chest',
    'Chest',
    'Chest',
    'Chest',
    'Arms',
    'Back',
    'Back',
    'Chest',
    'Back',
    'Core',
    'Cardio',
    'Olympic',
    'Legs',
    'Full body',
    'Full body',
    'Full body',
    'Back',
    'Core',
    'Back',
    'Core',
    'Back',
    'Back',
    'Back',
    'Back',
    'Back',
    'Back',
    'Legs',
    'Shoulders',
    'Shoulders',
    'Shoulders',
    'Shoulders',
    'Legs',
    'Legs',
    'Legs',
    'Legs',
    'Legs',
    'Legs',
    'Legs',
    'Full body',
    'Core',
    'Shoulders',
    'Shoulders',
    'Shoulders',
    'Shoulders',
    'Olympic',
    'Chest',
    'Back',
    'Legs',
    'Core',
    'Olympic',
    'Olympic',
    'Arms',
    'Arms',
    'Arms',
    'Olympic',
    'Back',
    'Back',
    'Back',
    'Chest',
    'Chest',
    'Shoulders',
    'Chest',
    'Chest',
    'Chest',
    'Back',
    'Core',
    'Arms',
    'Arms',
    'Arms',
    'Shoulders',
    'Shoulders',
    'Shoulders',
    'Arms',
    'Core',
    'Back',
    'Legs',
    'Cardio',
    'Cardio',
    'Cardio',
    'Core',
    'Legs',
    'Legs',
    'Legs',
    'Legs',
    'Shoulders',
    'Shoulders',
    'Arms',
    'Back',
    'Back',
    'Back',
    'Shoulders',
    'Shoulders',
    'Shoulders',
    'Shoulders',
    'Back',
    'Back',
    'Core',
    'Core',
    'Core',
    'Core',
    'Legs',
    'Core',
    'Cardio',
    'Cardio',
    'Arms',
    'Arms',
    'Olympic',
    'Olympic',
    'Cardio',
    'Olympic',
    'Legs',
    'Legs',
    'Legs',
    'Legs',
    'Legs',
    'Legs',
    'Full body',
    'Legs',
    'Legs',
    'Legs',
    'Legs',
    'Legs',
    'Legs',
    'Back',
    'Legs',
    'Legs',
    'Other',
    'Shoulders',
    'Back',
    'Full body',
    'Core',
    'Cardio',
    'Back',
    'Full body',
    'Full body',
    'Core',
    'Core',
    'Legs',
    'Arms',
    'Arms',
    'Arms',
    'Arms',
    'Arms',
    'Arms',
    'Arms',
    'Arms',
    'Back',
    'Arms',
    'Shoulders',
    'Core',
    'Cardio',
    'Back',
    'Arms',
    'Cardio',
    'Legs'
  ];
  List<Map<String, String>> exercisecat = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, Map<String, dynamic>>> chosenExercises = [];
  List<Map<String, dynamic>> templates = [];

  //  [
  //   {
  //     'Dumbell': {
  //       'Sets': 1,
  //       'RepWeight': [
  //         {'kg': 25, 'reps': 20}
  //       ]
  //     }
  //   },
  //   {
  //     'Dumbell': {
  //       'Sets': 1,
  //       'RepWeight': [
  //         {'kg': 25, 'reps': 20}
  //       ]
  //     }
  //   },
  //   {
  //     'Dumbell': {
  //       'Sets': 1,
  //       'RepWeight': [
  //         {'kg': 25, 'reps': 20}
  //       ]
  //     }
  //   }
  // ];
  List<String> combinedtypesofcategory = [
    'All',
    'Core',
    'Cardio',
    'Shoulders',
    'Chest',
    'Back',
    'Full body',
    'Arms',
    'Legs',
    'Olympic',
    'Other'
  ];
  String workoutname = '';
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;
  final dbHelper = DatabaseHelper.instance;
  String exercisecombined = '';
  String repweightcombined = '';
  String perfcombined = '';
  String currtime = '';
  int currhour = 0;
  @override
  void initState() {
    chosenExercises = widget.chosenExercises;
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    currhour = DateTime.now().hour;
    if ((currhour >= 0 && currhour <= 4) ||
        (currhour >= 19 && currhour <= 23) ||
        currhour == 0) {
      widget.workoutname = 'Night Workout';
    }
    if (currhour > 4 && currhour <= 11) {
      widget.workoutname = 'Morning Workout';
    }
    if (currhour > 11 && currhour <= 16) {
      widget.workoutname = 'Noon Workout';
    }
    if (currhour > 16 && currhour < 19) {
      widget.workoutname = 'Evening Workout';
    }
    //templates = widget.templates;
    super.initState();
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  void format(List<Map<String, dynamic>> templateser) {
    //print(templateser.length);
    setState(() {
      for (int i = 0; i < templateser.length; i++) {
        // print(i);
        exercisecombined += templateser[i].keys.toList()[0];
        for (int j = 0; j < templateser[i].values.toList()[0]['Sets']; j++) {
          repweightcombined += 'kg' +
              templateser[i]
                  .values
                  .toList()[0]['RepWeight'][j]['kg']
                  .toString() +
              'reps' +
              templateser[i]
                  .values
                  .toList()[0]['RepWeight'][j]['reps']
                  .toString();
          perfcombined += 'performed' +
              templateser[i]
                  .values
                  .toList()[0]['RepWeight'][j]['performed']
                  .toString();
        }
        if (i != templateser.length - 1) {
          repweightcombined += '\n';
          exercisecombined += '\n';
          perfcombined += '\n';
        }
        //repweightcombined+=
      }
    });
    print(exercisecombined);
    print(repweightcombined);
    print(perfcombined);
    //print(templates[1].values.toList()[0]['Sets']);
    //print(templates[0].values.toList()[0]['RepWeight'][1]['kg']);
  }

  Future<void> _insert() async {
    print('WORKOUT NAME IS' + widget.workoutname);
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columncombinedexercise: exercisecombined,
      DatabaseHelper.columncombinedweightreps: repweightcombined,
      DatabaseHelper.workoutname: widget.workoutname,
      DatabaseHelper.columndate:
          int.parse(Timestamp.fromDate(DateTime.now()).seconds.toString()),
      DatabaseHelper.columnworkouttime: int.parse(currtime),
      DatabaseHelper.columnperformed: perfcombined
      //DatabaseHelper.columnExperience:'Flutter Developer'
    };
    print(row);
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
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
        leading: IconButtonSimple(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        actions: [
          TextButton.icon(
            // <-- TextButton
            onPressed: () async {
              if (didperform() == true) {
                addtemplate(templates);
                format(chosenExercises);

                await _insert();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WorkoutScreen(
                            templates,
                            widget.workoutname,
                            chosenExercises,
                            widget.exercisecat,
                            widget.categoryimages,
                            widget.combinedtypesofcategory,
                            widget.exercisenames)));
              } else {
                Fluttertoast.showToast(
                    msg: "Please perform some sets to finish workout",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0 * kh * h);
              }
            },
            icon: Icon(
              Icons.save,
              size: 24.0 * kh * h,
            ),
            label: TextPlain('Save'),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(Constants.padding * kh * h),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: h * 0.02,
            ),
            Container(
              height: h * 0.05,
              child: TextFormField(
                initialValue: widget.workoutname,
                decoration: InputDecoration(
                    //labelText: 'Workout note',

                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0 * kh * h),
                    )),
                onChanged: (val) {
                  setState(() {
                    widget.workoutname = val;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: 20 * kh * h),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExerciseChooseScreen(
                                templates,
                                chosenExercises,
                                widget.workoutname,
                                widget.exercisecat,
                                widget.categoryimages,
                                widget.combinedtypesofcategory,
                                widget.exercisenames,
                                1)),
                      );
                    },
                    child: TextPlain('ADD EXERCISE', color: Colors.blue)),
              ],
            ),
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: (context, snapshot) {
                final value = snapshot.data;
                final displayTime =
                    StopWatchTimer.getDisplayTime(value!, hours: _isHours);

                currtime = StopWatchTimer.getDisplayTime(value,
                    hours: false,
                    minute: false,
                    milliSecond: false,
                    second: true);
                // print(currtime);

                return TextPlain(displayTime,
                    fontSize: 20 * kh * h,
                    fontWeight: FontWeight.bold,
                    color: Colors.green);
              },
            ),
            exercisename(widget.workoutname, chosenExercises)
          ]),
        ),
      ),
    );
  }

  void addtemplate(List<Map<String, dynamic>> templates) {
    if (chosenExercises.length != 0) {
      List<exercise> l = [];
      for (int i = 0; i < chosenExercises.length; i++) {
        setState(() {
          l.add(exercise(
            chosenExercises[i].values.toList()[0]['Sets'],
            chosenExercises[i].keys.toList()[0],
          ));
        });
      }
      setState(() {
        templates.add({'name': widget.workoutname, 'list': l});
      });
    }
  }

  bool didperform() {
    int sum = 0;
    for (int i = 0; i < chosenExercises.length; i++) {
      for (int j = 0; j < chosenExercises[i].values.toList()[0]['Sets']; j++) {
        sum += chosenExercises[i].values.toList()[0]['RepWeight'][j]
            ['performed'] as int;
      }
      if (sum > 0) {
        return true;
      }
    }
    return false;
  }

  Widget exercisename(String name, List<Map<String, Map<String, dynamic>>> l) {
    int totsets = 0;
    for (int i = 0; i < l.length; i++) {
      totsets += l[i].values.toList()[0]['Sets'] as int;
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextPlain(name, color: Colors.blue),
          Container(
            height: 450 + totsets * 20.0,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (ctx, itemer) {
                print('Outside Loop' + itemer.toString());
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextPlain(
                      l[itemer].keys.toList()[0],
                      color: Colors.grey.shade400,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextPlain(
                          'SET',
                          color: Colors.grey.shade400,
                        ),
                        TextPlain(
                          'KG',
                          color: Colors.grey.shade400,
                        ),
                        TextPlain(
                          'REPS',
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(
                          width: w * 0.01,
                        )
                      ],
                    ),
                    Form(
                      //key: _formKey,
                      child: Container(
                        height: 50.0 * l[itemer].values.toList()[0]['Sets'],
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (ctx, item) {
                            print('Inside Loop+' + item.toString());
                            Color color = Colors.black;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 10.0 * kh * h),
                                        child: TextPlain(
                                          (item + 1).toString(),
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      Container(
                                        width: w * 0.05,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          initialValue: l[itemer]
                                                      .values
                                                      .toList()[0]['RepWeight']
                                                          [item]['kg']
                                                      .toString() ==
                                                  '0'
                                              ? null
                                              : l[itemer]
                                                  .values
                                                  .toList()[0]['RepWeight']
                                                      [item]['kg']
                                                  .toString(),
                                          onChanged: ((value) {
                                            setState(() {
                                              if (value == '') {
                                                l[itemer].values.toList()[0]
                                                        ['RepWeight'][item]
                                                    ['kg'] = 0;
                                              } else {
                                                l[itemer].values.toList()[0]
                                                        ['RepWeight'][item]
                                                    ['kg'] = int.parse(value);
                                              }
                                            });
                                            print(l);
                                          }),
                                        ),
                                      ),
                                      Container(
                                        width: w * 0.05,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          initialValue: l[itemer]
                                                      .values
                                                      .toList()[0]['RepWeight']
                                                          [item]['reps']
                                                      .toString() ==
                                                  '0'
                                              ? null
                                              : l[itemer]
                                                  .values
                                                  .toList()[0]['RepWeight']
                                                      [item]['reps']
                                                  .toString(),
                                          onChanged: ((value) {
                                            setState(() {
                                              if (value == '') {
                                                l[itemer].values.toList()[0]
                                                        ['RepWeight'][item]
                                                    ['reps'] = 0;
                                              } else {
                                                l[itemer].values.toList()[0]
                                                        ['RepWeight'][item]
                                                    ['reps'] = int.parse(value);
                                              }
                                            });
                                            print(l);
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButtonSimple(
                                  onPressed: () {
                                    setState(() {
                                      if ((l[itemer].values.toList()[0]
                                                  ['RepWeight'][item]['reps'] ==
                                              0) ||
                                          (l[itemer].values.toList()[0]
                                                  ['RepWeight'][item]['kg']) ==
                                              0) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Set cannot be completed with an empty rep or weight field",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.grey,
                                            textColor: Colors.white,
                                            fontSize: 16.0 * kh * h);
                                      } else {
                                        l[itemer].values.toList()[0]
                                                    ['RepWeight'][item]
                                                ['performed'] =
                                            1 -
                                                l[itemer].values.toList()[0]
                                                        ['RepWeight'][item]
                                                    ['performed'];
                                      }

                                      print(chosenExercises);
                                    });
                                  },
                                  icon: Icon(
                                      Icons.check_circle_outline_outlined,
                                      color: l[itemer].values.toList()[0]
                                                      ['RepWeight'][item]
                                                  ['performed'] ==
                                              1
                                          ? Colors.green
                                          : Colors.black),
                                )
                              ],
                            );
                          },
                          itemCount: l[itemer].values.toList()[0]['Sets'],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 15),
                            ),
                            onPressed: () {
                              setState(() {
                                l[itemer].values.toList()[0]['Sets'] += 1;
                                print(l[itemer].values.toList()[0]['RepWeight']
                                    [0]);
                                l[itemer]
                                    .values
                                    .toList()[0]['RepWeight']
                                    .add({'kg': 0, 'reps': 0, 'performed': 0});
                              });
                              print(l);
                            },
                            child: TextPlain('ADD SET', color: Colors.blue)),
                      ],
                    ),
                  ],
                );
              },
              itemCount: l.length,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:op_fitnessapp/bodyfatpercentage.dart';
import 'package:op_fitnessapp/calorieintakechart.dart';
import 'package:op_fitnessapp/exercisescreen.dart';
import 'package:op_fitnessapp/newworkouttemplate.dart';
import 'package:op_fitnessapp/weightchart.dart';
import 'package:op_fitnessapp/measurescreen.dart';
import 'package:op_fitnessapp/workoutscreen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
  List<Image> categoryimages = [];
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 2);

  void mapstuff() {
    for (int i = 0; i < exercisenames.length; i++) {
      String category = exercisecategories[i];
      if (category == combinedtypesofcategory[1]) {
        categoryimages.add(Image.asset(
          'icons/core.webp',
          color: Colors.lightBlue[200],
        ));
      } else if (category == combinedtypesofcategory[2]) {
        categoryimages.add(Image.asset(
          'icons/cardio.webp',
          color: Colors.deepOrange[200],
        ));
      } else if (category == combinedtypesofcategory[3]) {
        categoryimages
            .add(Image.asset('icons/shoulder.webp', color: Colors.grey[400]));
      } else if (category == combinedtypesofcategory[4]) {
        categoryimages.add(Image.asset(
          'icons/chest.webp',
          color: Colors.brown[200],
        ));
      } else if (category == combinedtypesofcategory[5]) {
        categoryimages.add(Image.asset(
          'icons/back.webp',
          color: Colors.red[200],
        ));
      } else if (category == combinedtypesofcategory[6]) {
        categoryimages.add(Image.asset(
          'icons/fullbody.webp',
          color: Colors.red.shade200,
        ));
      } else if (category == combinedtypesofcategory[7]) {
        categoryimages.add(Image.asset(
          'icons/arms.webp',
          color: Colors.amber.shade600,
        ));
      } else if (category == combinedtypesofcategory[8]) {
        categoryimages.add(Image.asset(
          'icons/legs.webp',
          color: Colors.teal[200],
        ));
      } else if (category == combinedtypesofcategory[9]) {
        categoryimages.add(Image.asset(
          'icons/olympic.webp',
          color: Colors.lime[200],
        ));
      } else {
        categoryimages.add(Image.asset(
          'icons/other.webp',
          color: Colors.lightBlue[200],
        ));
      }
      exercisecat
          .add({'name': exercisenames[i], 'type': exercisecategories[i]});
    }
    // print(categoryimages);
    // print(exercisecat);
    //print(exercisecat.length);
  }

  @override
  void initState() {
    mapstuff();
    super.initState();
  }

  List<Widget> _buildScreens() {
    return [
      Center(
        child: CircleAvatar(
          backgroundColor: Colors.grey[200],
          radius: 35,
          child: CircleAvatar(
            radius: 30.0,
            child: Image.asset(
              'icons/arms.webp',
              color: Colors.lightBlue[200],
            ),
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      CalorieIntakeChart(),
      WorkoutTemplateScreen(),
      ExerciseScreen(
          exercisecat, categoryimages, combinedtypesofcategory, exercisenames),
      MeasureScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: FaIcon(FontAwesomeIcons.user),
        title: ("Profile"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: FaIcon(FontAwesomeIcons.clock),
        title: ("History"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: FaIcon(FontAwesomeIcons.plus),
        title: ("Workout"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: FaIcon(FontAwesomeIcons.dumbbell),
        title: ("Exercises"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: FaIcon(FontAwesomeIcons.ruler),
        title: ("Measure"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;
    return Scaffold(
        body: PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    ));
  }
}

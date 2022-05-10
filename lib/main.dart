import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:op_fitnessapp/ExerciseScreen/exerciseitem.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/addedExerciseScreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/exercisechoosescreen.dart';
import 'package:op_fitnessapp/ExerciseScreen/exercisescreen.dart';
import 'package:op_fitnessapp/HistoryScreen/historyscreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/newworkouttemplate.dart';
import 'package:op_fitnessapp/ProfileScreen/profilescreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/startworkoutscreen.dart';
import 'package:op_fitnessapp/MeasureScreen/measurescreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/workoutscreen.dart';
import 'package:op_fitnessapp/exercisenamesvalues.dart';
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
  double kh = 1 /
      759.2727272727273; //height coeffecient by which we multiply to make screen size configurable to diff screen sizes
  double kw = 1 / 392.72727272727275;
  List<String> exercisenames = [];
  List<String> exercisecategories = [];
  List<Map<String, String>> exercisecat = [];
  List<String> combinedtypesofcategory = [];
  List<Image> categoryimages = []; //List of images for different categories
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 2); //Tab controller

  @override
  void initState() {
    ExerciseValues.mapstuff();
    exercisenames = ExerciseValues.exercisenames;
    exercisecategories = ExerciseValues.exercisecategories;
    exercisecat = ExerciseValues.exercisecat;
    combinedtypesofcategory = ExerciseValues.combinedtypesofcategory;
    super.initState();
  }

  List<Widget> _buildScreens() {
    return [
      ProfileScreen(),
      HistoryScreen(
        [],
        '',
        [],
      ),
      WorkoutScreen(
        [],
        '',
        [],
      ),
      ExerciseScreen(),
      MeasureScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    //Tab bar
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
        borderRadius: BorderRadius.circular(10.0 * kh * h),
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

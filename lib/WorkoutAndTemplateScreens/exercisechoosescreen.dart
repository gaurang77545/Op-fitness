import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/addedExerciseScreen.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/newworkouttemplate.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/startworkoutscreen.dart';
import 'package:op_fitnessapp/customwidgets/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:search_bar_animated/search_bar_animated.dart';

import '../customwidgets/circleavatarsimple.dart';
import '../customwidgets/iconbuttonsimple.dart';
import '../customwidgets/text.dart';
import '../exercisenamesvalues.dart';

class ExerciseChooseScreen extends StatefulWidget {
  int navig = 0;
  String workoutname = '';

  List<Map<String, dynamic>> templates = [];
  List<Map<String, Map<String, dynamic>>> chosenExercises = [];

  ExerciseChooseScreen(this.templates, this.chosenExercises, this.workoutname,
      [this.navig = 0]);

  @override
  State<ExerciseChooseScreen> createState() => _ExerciseChooseScreenState();
}

class _ExerciseChooseScreenState extends State<ExerciseChooseScreen> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  List<Map<String, String>> displayexercisecat = [];
  List<Map<String, Map<String, dynamic>>> chosenExercises = [];
  List<Image> categoryimages = [];
  List<String> exercisenames = [];
  List<String> combinedtypesofcategory = [];
  List<Map<String, String>> exercisecat = [];
  List<Image> displaycategoryimages = [];
  List<String> exercisecategories = [];
  List<bool> selected = [];
  String? selectedValue;
  Widget customSearchBar = TextPlain(
    'Add Exercise',
    color: Colors.black,
  );
  String value = '';
  @override
  void initState() {
    // TODO: implement initState
    ExerciseValues.mapstuff();
    exercisenames = ExerciseValues.exercisenames;
    exercisecategories = ExerciseValues.exercisecategories;
    exercisecat = ExerciseValues.exercisecat;
    combinedtypesofcategory = ExerciseValues.combinedtypesofcategory;
    categoryimages = ExerciseValues.categoryimages;
    chosenExercises = widget.chosenExercises;
    displayexercisecat = List.from(exercisecat);
    displaycategoryimages = List.from(categoryimages);
    selected = List.generate(exercisenames.length, (index) => false);
    super.initState();
  }

  void find(String str) {
    String i = '';
    int counter = 0;
    displaycategoryimages = [];
    displayexercisecat = [];
    for (i in exercisenames) {
      if (i.contains(str)) {
        displaycategoryimages.add(categoryimages[counter]);
        displayexercisecat.add(exercisecat[counter]);
      }
      counter++;
    }
  }

  void chosen(String str) {
    String i = '';
    int counter = 0;
    displaycategoryimages = [];
    displayexercisecat = [];
    for (i in exercisenames) {
      if (i == str) {
        displaycategoryimages.add(categoryimages[counter]);
        displayexercisecat.add(exercisecat[counter]);
        break;
      }
      counter++;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;
    TextEditingController textController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        backgroundColor: Colors.white,
        leading: IconButtonSimple(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          SizedBox(
            width: w * 0.01,
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Row(
                children: [
                  Icon(
                    Icons.filter_alt_rounded,
                    size: 25 * kh * h,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 4 * kw * w,
                  ),
                ],
              ),
              items: combinedtypesofcategory
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: TextPlain(
                          item,
                          fontSize: 14 * kh * h,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value as String;
                  filterscreen(selectedValue!);
                });
              },
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.blue,
              ),
              iconSize: 14 * kh * h,
              iconEnabledColor: Colors.yellow,
              iconDisabledColor: Colors.grey,
              buttonHeight: 50 * kh * h,
              buttonWidth: 50 * kw * w,
              //buttonPadding: const EdgeInsets.only(left: 14, right: 14),
              buttonDecoration: BoxDecoration(
                color: Colors.white,
              ),
              buttonElevation: 2,
              itemHeight: 40 * kh * h,
              itemPadding:
                  EdgeInsets.only(left: 14 * kw * w, right: 14 * kw * w),
              dropdownMaxHeight: 200 * kh * h,
              dropdownWidth: 200 * kw * w,
              dropdownPadding: null,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14 * kh * h),
                //color: Colors.redAccent,
              ),
              dropdownElevation: 8,
              scrollbarRadius: Radius.circular(40 * kh * h),
              scrollbarThickness: 6 * kw * w,
              scrollbarAlwaysShow: true,
              offset: const Offset(-20, 0),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(Constants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSearchBar(
              shadow: const [
                BoxShadow(
                    color: Colors.black38, blurRadius: 6, offset: Offset(0, 6))
              ],
              backgroundColor: Colors.blue[100],
              failMessage: 'No Items found',

              //hideSearchBoxWhenItemSelected: true,
              buttonColor: Colors.blue,
              width: w * 0.55,
              submitButtonColor: Colors.blue,
              textStyle: const TextStyle(color: Colors.blue),
              buttonIcon: const Icon(
                Icons.search,
              ),
              duration: const Duration(milliseconds: 500),
              submitIcon: const Icon(Icons.close),
              hintText: '',
              animationAlignment: AnimationAlignment.left,
              onSubmit: () {
                setState(() {
                  value = textController.text;
                });
                find(value);
              },
              searchList: exercisenames,
              searchQueryBuilder: (query, list) => list.where((item) {
                return item!
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase());
              }).toList(),
              textController: textController,
              overlaySearchListItemBuilder: (dynamic item) => Container(
                padding: EdgeInsets.all(8 * kh * h),
                child: TextPlain(
                  item,
                  fontSize: 15 * kh * h,
                  color: Colors.black,
                ),
              ),
              onItemSelected: (dynamic item) {
                setState(() {
                  textController.value = textController.value.copyWith(
                    text: item.toString(),
                  );
                  value = textController.text;
                });
                chosen(value);
              },
              overlaySearchListHeight: h * 0.5,
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (_, item) {
                  return ExerciseItems(
                      displayexercisecat[item]['name']!,
                      displayexercisecat[item]['type']!,
                      displaycategoryimages[item],
                      item);
                },
                itemCount: displayexercisecat.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: chosenExercises.length == 0
          ? null
          : FloatingActionButton(
              onPressed: () {
                if (widget.navig == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StartWorkoutScreen(
                              chosenExercises,
                              widget.workoutname,
                            )),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddedExerciseScreen(
                              widget.templates,
                              chosenExercises,
                              widget.workoutname,
                            )),
                  );
                }
              },
              child: Icon(Icons.keyboard_arrow_right_outlined)),
    );
  }

  Widget ExerciseItems(String name, String type, Image image, int index) {
    return InkWell(
      child: Container(
        color: selected[index] ? Colors.blue : null,
        child: Column(
          children: [
            SizedBox(
              height: h * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatarSimple(
                  backgroundColor: Colors.grey[200],
                  radius: 35 * kh * h,
                  child: CircleAvatarSimple(
                    radius: 30.0 * kh * h,
                    child: image,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(
                  width: w * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextPlain(name,
                        fontWeight: FontWeight.bold, letterSpacing: 1 * kw * w),
                    SizedBox(
                      height: h * 0.01,
                    ),
                    TextPlain(type, letterSpacing: 1 * kw * w),
                  ],
                )
              ],
            ),
            SizedBox(
              height: h * 0.01,
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          selected[index] = !selected[index];
        });
        if (selected[index] == true) {
          setState(() {
            if (widget.navig == 1) {
              chosenExercises.add({
                name: {
                  'Sets': 1,
                  'RepWeight': [
                    {'kg': 0, 'reps': 0, 'performed': 0}
                  ]
                }
              });
            } else {
              chosenExercises.add({
                name: {
                  'Sets': 1,
                  'RepWeight': [
                    {'kg': 0, 'reps': 0}
                  ]
                }
              });
            }
          });
        }
        if (selected[index] == false) {
          setState(() {
            chosenExercises
                .removeWhere((element) => element.keys.first == name);
          });
        }
      },
    );
  }

  void filterscreen(String val) {
    displaycategoryimages = [];
    displayexercisecat = [];
    if (val == 'All') {
      displayexercisecat = List.from(exercisecat);
      displaycategoryimages = List.from(categoryimages);
      return;
    }

    Map<String, String> i;
    int counter = 0;

    for (i in exercisecat) {
      if (i['type'] == val) {
        displaycategoryimages.add(categoryimages[counter]);
        displayexercisecat.add(exercisecat[counter]);
      }
      counter += 1;
    }
  }
}

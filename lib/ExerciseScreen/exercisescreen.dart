import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:op_fitnessapp/ExerciseScreen/exerciseitem.dart';
import 'package:op_fitnessapp/customwidgets/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:search_bar_animated/search_bar_animated.dart';

import '../customwidgets/circleavatarsimple.dart';
import '../customwidgets/text.dart';
import '../exercisenamesvalues.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  List<Map<String, String>> exercisecat = [];
  List<Image> categoryimages = [];
  List<String> exercisenames = [];
  List<String> combinedtypesofcategory = [];
  List<Map<String, String>> displayexercisecat = [];
  List<Image> displaycategoryimages = [];
  List<String> exercisecategories = [];
  String? selectedValue;
  Widget customSearchBar = TextPlain(
    'Exercise',
    color: Colors.black,
  );
  String value = '';
  void find(String str) {
    //finding the exercises in the list.Search bar functionality
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
    //when we click on the recomendation of search bar this will open up
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
              icon: const Icon(
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
              shadow: [
                BoxShadow(
                    color: Colors.black38,
                    blurRadius: 6 * kh * h,
                    offset: Offset(0, 6))
              ],
              backgroundColor: Colors.blue[100],
              failMessage: 'No Items found',

              //hideSearchBoxWhenItemSelected: true,
              buttonColor: Colors.blue,
              width: w * 0.55,
              submitButtonColor: Colors.blue,
              textStyle: const TextStyle(color: Colors.blue),
              buttonIcon: Icon(
                Icons.search,
              ),
              //  duration: const Duration(milliseconds: 500),
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
              // height: h*0.72,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (_, item) {
                  return ExerciseItems(
                      displayexercisecat[item]
                          ['name']!, //We are displaying the searched items only
                      displayexercisecat[item]['type']!,
                      displaycategoryimages[item]);
                },
                itemCount: displayexercisecat.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    ExerciseValues.mapstuff();
    exercisenames = ExerciseValues.exercisenames;
    exercisecategories = ExerciseValues.exercisecategories;
    exercisecat = ExerciseValues.exercisecat;
    combinedtypesofcategory = ExerciseValues.combinedtypesofcategory;
    categoryimages = ExerciseValues.categoryimages;
    displayexercisecat = List.from(exercisecat);
    displaycategoryimages = List.from(categoryimages);
    super.initState();
  }

  Widget ExerciseItems(String name, String type, Image image) {
    //Display each list item
    return InkWell(
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
                radius: 35,
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
                  TextPlain(
                    name,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1 * kw * w,
                  ),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  TextPlain(
                    type,
                    letterSpacing: 1 * kw * w,
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: h * 0.01,
          ),
        ],
      ),
      onTap: () {
        print(name);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExerciseItemScreen(
                    name,
                    'INSTRUCTIONS HERE',
                  )),
        );
      },
    );
  }

  void filterscreen(String val) {
    //filter screen for search bar functionality
    displaycategoryimages = [];
    displayexercisecat = [];
    if (val == 'All') {
      //if all means all exercises have to be shown
      displayexercisecat = List.from(exercisecat);
      displaycategoryimages = List.from(categoryimages);
      return;
    }

    Map<String, String> i;
    int counter = 0;

    for (i in exercisecat) {
      if (i['type'] == val) {
        //here i['type'] contains category of exercises and that is being compared with category(val) as well
        displaycategoryimages.add(categoryimages[counter]);
        displayexercisecat.add(exercisecat[counter]);
      }
      counter += 1;
    }
  }
}

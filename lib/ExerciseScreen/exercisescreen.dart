import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:search_bar_animated/search_bar_animated.dart';

class ExerciseScreen extends StatefulWidget {
  List<Map<String, String>> exercisecat;
  List<Image> categoryimages = [];
  List<String> exercisenames = [];
  List<String> combinedtypesofcategory = [];
  ExerciseScreen(this.exercisecat, this.categoryimages,
      this.combinedtypesofcategory, this.exercisenames);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  List<Map<String, String>> displayexercisecat = [];
  List<Image> displaycategoryimages = [];
  String? selectedValue;
  Widget customSearchBar = const Text('Exercise',style: TextStyle(color: Colors.black),);
  String value = '';
  void find(String str) {
    String i = '';
    int counter = 0;
    displaycategoryimages = [];
    displayexercisecat = [];
    for (i in widget.exercisenames) {
      if (i.contains(str)) {
        displaycategoryimages.add(widget.categoryimages[counter]);
        displayexercisecat.add(widget.exercisecat[counter]);
      }
      counter++;
    }
  }

  void chosen(String str) {
    String i = '';
    int counter = 0;
    displaycategoryimages = [];
    displayexercisecat = [];
    for (i in widget.exercisenames) {
      if (i == str) {
        displaycategoryimages.add(widget.categoryimages[counter]);
        displayexercisecat.add(widget.exercisecat[counter]);
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
          AnimatedSearchBar(
            shadow:  [
              BoxShadow(
                  color: Colors.black38, blurRadius: 6*kh*h, offset: Offset(0, 6))
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
            searchList: widget.exercisenames,
            searchQueryBuilder: (query, list) => list.where((item) {
              return item!
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase());
            }).toList(),
            textController: textController,
            overlaySearchListItemBuilder: (dynamic item) => Container(
              padding:  EdgeInsets.all(8*kh*h),
              child: Text(
                item,
                style:  TextStyle(fontSize: 15*kh*h, color: Colors.black),
              ),
            ),
            onItemSelected: (dynamic item) {
              setState(() {
                textController.value = textController.value.copyWith(
                  text: item.toString(),
                );
                value = textController.text;

                print(textController.value);
              });
              chosen(value);
            },
            overlaySearchListHeight: h * 0.5,
          ),
          SizedBox(
            width: w * 0.01,
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Row(
                children:  [
                  Icon(
                    Icons.filter_alt_rounded,
                    size: 25*kh*h,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 4*kw*w,
                  ),
                ],
              ),
              items: widget.combinedtypesofcategory
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style:  TextStyle(
                            fontSize: 14*kh*h,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
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
              iconSize: 14*kh*h,
              iconEnabledColor: Colors.yellow,
              iconDisabledColor: Colors.grey,
              buttonHeight: 50*kh*h,
              buttonWidth: 50*kw*w,
              //buttonPadding: const EdgeInsets.only(left: 14, right: 14),
              buttonDecoration: BoxDecoration(
                color: Colors.white,
              ),
              buttonElevation: 2,
              itemHeight: 40*kh*h,
              itemPadding:  EdgeInsets.only(left: 14*kw*w, right: 14*kw*w),
              dropdownMaxHeight: 200*kh*h,
              dropdownWidth: 200*kw*w,
              dropdownPadding: null,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14*kh*h),
                //color: Colors.redAccent,
              ),
              dropdownElevation: 8,
              scrollbarRadius:  Radius.circular(40*kh*h),
              scrollbarThickness: 6*kw*w,
              scrollbarAlwaysShow: true,
              offset: const Offset(-20, 0),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (_, item) {
          return ExerciseItems(displayexercisecat[item]['name']!,
              displayexercisecat[item]['type']!, displaycategoryimages[item]);
        },
        itemCount: displayexercisecat.length,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    displayexercisecat = List.from(widget.exercisecat);
    displaycategoryimages = List.from(widget.categoryimages);
    super.initState();
  }

  Widget ExerciseItems(String name, String type, Image image) {
    return Column(
      children: [
        SizedBox(
          height: h * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 35,
              child: CircleAvatar(
                radius: 30.0*kh*h,
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
                Text(
                  name,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                SizedBox(
                  height: h * 0.01,
                ),
                Text(
                  type,
                  style: TextStyle(letterSpacing: 1*kw*w),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: h * 0.01,
        ),
      ],
    );
  }

  void filterscreen(String val) {
    displaycategoryimages = [];
    displayexercisecat = [];
    if (val == 'All') {
      displayexercisecat = List.from(widget.exercisecat);
      displaycategoryimages = List.from(widget.categoryimages);
      return;
    }

    Map<String, String> i;
    int counter = 0;

    for (i in widget.exercisecat) {
      if (i['type'] == val) {
        displaycategoryimages.add(widget.categoryimages[counter]);
        displayexercisecat.add(widget.exercisecat[counter]);
      }
      counter += 1;
    }
  }
}

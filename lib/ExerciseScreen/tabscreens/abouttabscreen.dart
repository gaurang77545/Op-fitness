import 'package:flutter/material.dart';
import 'package:op_fitnessapp/customwidgets/constants.dart';
import 'package:op_fitnessapp/customwidgets/text.dart';

class AboutTabScreen extends StatefulWidget {
  String instructions;
  AboutTabScreen({ this.instructions = ''});

  @override
  State<AboutTabScreen> createState() => _AboutTabScreenState();
}

class _AboutTabScreenState extends State<AboutTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.all(Constants.padding),
        child: Column(
          children: [
            TextPlain(
              'Instructions',
              fontWeight: FontWeight.bold,
            ),
            TextPlain(widget.instructions)
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:op_fitnessapp/customwidgets/text.dart';

class ChartTabScreen extends StatefulWidget {
   ChartTabScreen() ;

  @override
  State<ChartTabScreen> createState() => _ChartTabScreenState();
}

class _ChartTabScreenState extends State<ChartTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextPlain(
            'Instructions',
            fontWeight: FontWeight.bold,
          ),
          
        ],
      ),
    );
  }
}

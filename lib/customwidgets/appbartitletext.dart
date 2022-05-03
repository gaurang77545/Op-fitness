import 'package:flutter/material.dart';

class AppBarTitle extends StatefulWidget {
  String title;
  AppBarTitle({required this.title});

  @override
  State<AppBarTitle> createState() => _AppBarTitleState();
}

class _AppBarTitleState extends State<AppBarTitle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.title,
      style: TextStyle(
        color: Colors.black,
      ),
    );
  }
}

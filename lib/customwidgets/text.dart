import 'package:flutter/material.dart';

class TextPlain extends StatefulWidget {
  String title;
  FontWeight? fontweight;
  double? fontsize;
  double? letterspacing;
  TextPlain(this.title, {this.fontweight, this.fontsize, this.letterspacing});

  @override
  State<TextPlain> createState() => _TextPlainState();
}

class _TextPlainState extends State<TextPlain> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.title,
      style: TextStyle(
          color: Colors.black,
          fontWeight: widget.fontweight,
          letterSpacing: widget.letterspacing),
    );
  }
}

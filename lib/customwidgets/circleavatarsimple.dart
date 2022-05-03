import 'package:flutter/material.dart';

class CircleAvatarSimple extends StatefulWidget {
  String title;
  Widget? w;
  double radius;
  Color backgroundcolor;
  CircleAvatarSimple(this.title, this.w, this.radius, this.backgroundcolor);

  @override
  State<CircleAvatarSimple> createState() => _CircleAvatarSimpleState();
}

class _CircleAvatarSimpleState extends State<CircleAvatarSimple> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.radius,
      child: widget.w,
      backgroundColor: widget.backgroundcolor,
    );
  }
}

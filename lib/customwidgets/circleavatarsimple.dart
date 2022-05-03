import 'package:flutter/material.dart';

class CircleAvatarSimple extends StatefulWidget {
  Widget? child;
  double? radius;
  Color? backgroundColor;
  CircleAvatarSimple({this.child, this.radius, this.backgroundColor});

  @override
  State<CircleAvatarSimple> createState() => _CircleAvatarSimpleState();
}

class _CircleAvatarSimpleState extends State<CircleAvatarSimple> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.radius,
      child: widget.child,
      backgroundColor: widget.backgroundColor,
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';

class IconSimple extends StatefulWidget {
  IconData icon;
  double size;
  IconSimple(this.icon,this.size);

  @override
  State<IconSimple> createState() => _IconButtonSimpleState();
}

class _IconButtonSimpleState extends State<IconSimple> {
  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.icon,
      size: widget.size,
    );
  }
}

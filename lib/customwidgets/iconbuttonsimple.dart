import 'dart:ui';

import 'package:flutter/material.dart';

class IconButtonSimple extends StatefulWidget {
  Icon icon;
  Function() func;
  IconButtonSimple(this.icon, this.func);

  @override
  State<IconButtonSimple> createState() => _IconButtonSimpleState();
}

class _IconButtonSimpleState extends State<IconButtonSimple> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon:widget.icon,
      onPressed: widget.func,
    );
  }
}

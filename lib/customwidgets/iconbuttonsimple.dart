import 'dart:ui';

import 'package:flutter/material.dart';

class IconButtonSimple extends StatefulWidget {
  Icon icon;
  final VoidCallback? onPressed;
  IconButtonSimple({required this.icon, this.onPressed});

  @override
  State<IconButtonSimple> createState() => _IconButtonSimpleState();
}

class _IconButtonSimpleState extends State<IconButtonSimple> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: widget.icon,
      onPressed: widget.onPressed,
    );
  }
}

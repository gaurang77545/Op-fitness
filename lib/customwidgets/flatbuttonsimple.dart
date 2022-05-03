import 'package:flutter/material.dart';

class FlatButtonSimple extends StatefulWidget {
  Widget child;
  final VoidCallback? onPressed;
  FlatButtonSimple({required this.child, this.onPressed});

  @override
  State<FlatButtonSimple> createState() => _FlatButtonSimpleState();
}

class _FlatButtonSimpleState extends State<FlatButtonSimple> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }
}

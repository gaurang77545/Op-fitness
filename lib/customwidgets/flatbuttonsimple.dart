import 'package:flutter/material.dart';

class FlatButtonSimple extends StatefulWidget {
  String title;
  Function() func;
  FlatButtonSimple(this.title, this.func);

  @override
  State<FlatButtonSimple> createState() => _FlatButtonSimpleState();
}

class _FlatButtonSimpleState extends State<FlatButtonSimple> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.func,
      child: Text(widget.title),
    );
  }
}

import 'package:flutter/material.dart';

bool all_univ = true;

class switchOnOf extends StatefulWidget {
  String title;
  bool opinion;
  switchOnOf(this.title, this.opinion);

  @override
  State<switchOnOf> createState() => _switchOnOfState();
}

class _switchOnOfState extends State<switchOnOf> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        widget.title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      activeColor: Colors.blue,
      value: widget.opinion,
      onChanged: (bool value) async {
        setState(() {
          widget.opinion = !widget.opinion;
          all_univ = widget.opinion;
        });
      },
      secondary: widget.opinion
          ? Icon(Icons.lightbulb, color: Colors.blue)
          : Icon(Icons.lightbulb_outline, color: Colors.blue),
    );
  }
}

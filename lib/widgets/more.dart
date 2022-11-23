import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class MoreOptions extends StatefulWidget {
  IconData? icons;
  final onPressed;
  MoreOptions({super.key, this.icons, this.onPressed});

  @override
  State<MoreOptions> createState() => _MoreOptionsState();
}

class _MoreOptionsState extends State<MoreOptions> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white), shape: BoxShape.circle),
        child: Icon(
          widget.icons,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DirPopup extends StatelessWidget {
  final String path;
  final Function popTap;

  DirPopup({
    Key key,
    @required this.path,
    @required this.popTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: popTap,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Text(
            "Rename",
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            "Delete",
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            "Default Dir",
          ),
        ),
      ],
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.black,
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      offset: Offset(0, 30),
    );
  }
}

import 'package:flutter/material.dart';

class FilePopup extends StatelessWidget {
  final String path;
  final Function popTap;

  FilePopup({
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
            "Rinomina",
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            "Elimina",
          ),
        ),
//        PopupMenuItem(
//          value: 2,
//          child: Text(
//            "Info",
//          ),
//        ),
      ],
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).textTheme.headline6.color,
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      offset: Offset(0, 30),
    );
  }
}

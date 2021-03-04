import 'dart:io';
import 'package:wanted/widgets/dir_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:path/path.dart';

class DirectoryItem extends StatelessWidget {
  final FileSystemEntity file;
  final Function tap;
  final Function popTap;


  DirectoryItem({
    Key key,
    @required this.file,
    @required this.tap,
    @required this.popTap

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: tap,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.50),
      leading: Container(
        height: 40,
        width: 40,
        child: Center(
          child: ClipOval(
            child: Container(
              color: Colors.red,
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Feather.folder,
                    color: Colors.white,
                    size: 20,
                  )),
            ),
          ),
        ),
      ),
      title: Text(
        "${basename(file.path)}",
        style: TextStyle(
          fontSize: 16,
        ),
        maxLines: 2,
      ),
      trailing:
      popTap == null ? null : DirPopup(path: file.path, popTap: popTap),
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:filex/utils/utils.dart';
import 'package:filex/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as pathlib;
import 'package:provider/provider.dart';

import '../../../providers/category_provider.dart';
import '../../../providers/category_provider.dart';
import '../../../providers/category_provider.dart';

class DefDirDialog extends StatefulWidget {
  final String path;
  DefDirDialog({this.path});

  @override
  _DefDirDialogState createState() => _DefDirDialogState();
}

class _DefDirDialogState extends State<DefDirDialog> {

  String path;

  @override
  void initState() {
    super.initState();
    path = widget.path;
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlert(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 15),
            Text(
              "Impostare come directory di dafault?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 25),
            Container(
              child: Text(path)
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 40,
                  width: 130,
                  child: OutlineButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                    child: Text(
                      "Annulla",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    color: Colors.white,
                  ),
                ),
                Container(
                  height: 40,
                  width: 130,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      "Confermo",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      log(path);
                      Provider
                          .of<CategoryProvider>(context, listen: false)
                          .setDefaultDir(path);
                      Navigator.pop(context);
                    },
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:wanted/utils/utils.dart';
import 'package:wanted/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as pathlib;

class RenameFileDialog extends StatefulWidget {
  final String path;
  final String type;
  RenameFileDialog({this.path, this.type});

  @override
  _RenameFileDialogState createState() => _RenameFileDialogState();
}

class _RenameFileDialogState extends State<RenameFileDialog> {
  final TextEditingController name = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = pathlib.basename(widget.path);
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
              "Rinomina",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 25),
            TextField(
              controller: name,
              keyboardType: TextInputType.text,
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
                      "Rinomina",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (name.text.isNotEmpty) {
                        if (widget.type == "file") {
                          if (!File(widget.path.replaceAll(
                                      pathlib.basename(widget.path), "") +
                                  "${name.text}")
                              .existsSync()) {
                            await File(widget.path)
                                .rename(widget.path.replaceAll(
                                        pathlib.basename(widget.path), "") +
                                    "${name.text}")
                                .catchError((e) {
                              print(e.toString());
                              if (e.toString().contains("Permission denied")) {
                                Dialogs.showToast(
                                    "Permesso di scrittura negato, attivarlo dalle impostazioni dell'App!");
                              }
                            });
                          } else {
                            Dialogs.showToast(
                                "Nome già in uso!");
                          }
                        } else {
                          if (Directory(widget.path.replaceAll(
                                      pathlib.basename(widget.path), "") +
                                  "${name.text}")
                              .existsSync()) {
                            Dialogs.showToast(
                                "Nome cartella già in uso!");
                          } else {
                            await Directory(widget.path)
                                .rename(widget.path.replaceAll(
                                        pathlib.basename(widget.path), "") +
                                    "${name.text}")
                                .catchError((e) {
                              print(e.toString());
                              if (e.toString().contains("Permission denied")) {
                                Dialogs.showToast(
                                    "Permesso di scrittura negato, attivarlo dalle impostazioni dell'App!");
                              }
                            });
                          }
                        }
                        Navigator.pop(context);
                      }
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

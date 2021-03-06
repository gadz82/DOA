import 'dart:io';

import 'package:wanted/utils/utils.dart';
import 'package:wanted/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AddFileDialog extends StatelessWidget {
  final String path;

  AddFileDialog({this.path});

  final TextEditingController name = TextEditingController();

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
              "Aggiungi una cartella",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                      "Crea",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (name.text.isNotEmpty) {
                        if (!Directory(path + "/${name.text}").existsSync()) {
                          await Directory(path + "/${name.text}")
                              .create()
                              .catchError((e) {
                            print(e.toString());
                            if (e.toString().contains("Permission denied")) {
                              Dialogs.showToast(
                                  "Permesso di scrittura negato, attivarlo dalle impostazioni dell'App!");
                            }
                          });
                        } else {
                          Dialogs.showToast(
                              "Nome cartella già in uso");
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

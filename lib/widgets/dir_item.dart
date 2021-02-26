import 'dart:io';

import 'package:provider/provider.dart';
import 'package:wanted/providers/category_provider.dart';
import 'package:wanted/widgets/dir_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:path/path.dart';

class DirectoryItem extends StatelessWidget {
  final FileSystemEntity file;
  final Function tap;
  final Function popTap;
  final itemHeight;
  final itemWidth;

  DirectoryItem({
    Key key,
    @required this.file,
    @required this.tap,
    @required this.popTap,
    @required this.itemWidth,
    @required this.itemHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () => this.tap(),
        padding: EdgeInsets.all(1),
        child: Container(
          child: Wrap(
              children: [
                Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: <Widget>[
                          Container(
                            height: itemHeight,
                            width: itemWidth,
                            color: Theme.of(context).backgroundColor,
                            child: Center(
                                child: Icon(
                                  Feather.folder,
                                  size: 60,
                                )
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 2000,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                gradient: LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      Theme.of(context).accentColor,
                                      Theme.of(context).accentColor,
                                    ],
                                    stops: [
                                      0.0,
                                      1.0
                                    ])),
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(basename(file.path), overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color:Colors.white), textAlign: TextAlign.left)
                            ),
                          )

                        ],
                      ),
                      if(Provider.of<CategoryProvider>(context).adminMode)
                        Container(
                            height: 30,
                            width: 50,
                            color: Theme.of(context).backgroundColor,
                            child: DirPopup(path: this.file.path, popTap: popTap)
                        )
                    ]
                ),

              ]
          )
      )
    );
  }
}

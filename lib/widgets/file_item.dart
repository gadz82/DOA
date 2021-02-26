import 'package:mime_type/mime_type.dart';
import 'dart:io';

import 'package:wanted/utils/utils.dart';
import 'package:wanted/widgets/file_detail.dart';
import 'package:wanted/widgets/file_icon.dart';
import 'package:wanted/widgets/file_popup.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';

class FileItem extends StatelessWidget {
  final FileSystemEntity file;
  final Function popTap;
  final itemHeight;
  final itemWidth;

  FileItem({
    Key key,
    @required this.file,
    this.popTap,
    @required this.itemWidth,
    @required this.itemHeight
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: (){
          String mimeType = mime(basename(file.path).toLowerCase());
          String type = mimeType == null ? "" : mimeType.split("/")[0];
          if(type == "image"){
            Navigate.pushPage(
              context,
              FileDetail(file: this.file),
            );
          } else {
            return OpenFile.open(file.path);
          }
        },
        padding: EdgeInsets.all(1),
        child: Container(
            child: Wrap(
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: <Widget>[
                      Container(
                        height: this.itemHeight,
                        width: this.itemWidth,
                        color: Theme.of(context).backgroundColor,
                        child: Center(
                            child: FileIcon(
                              file: file,
                              itemHeight: this.itemHeight,
                              itemWidth: this.itemWidth
                            )
                        ),
                      ),
                      Container(
                        height: itemHeight/4,
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
                            padding: EdgeInsets.symmetric(vertical: (itemHeight/4)/5, horizontal: 1),
                            child: Text(basename(file.path),overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color:Colors.white), textAlign: TextAlign.left)
                        ),
                      )

                    ],
                  )
                ]
            )
        )
    );
    return ListTile(
      onTap: () => OpenFile.open(file.path),
      contentPadding: EdgeInsets.all(0),
      leading: FileIcon(
        file: file,
      ),
      title: Text(
        "${basename(file.path)}",
        style: TextStyle(
          fontSize: 14,
        ),
        maxLines: 2,
      ),
      subtitle: Text(
        "${FileUtils.formatBytes(file == null ? 678476 : File(file.path).lengthSync(), 2)},"
        " ${file == null ? "Test" : FileUtils.formatTime(File(file.path).lastModifiedSync().toIso8601String())}",
      ),
      trailing: popTap == null
          ? null
          : FilePopup(
              path: file.path,
              popTap: popTap,
            ),
    );
  }
}

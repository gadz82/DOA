import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';

class FileIcon extends StatelessWidget {

  FileSystemEntity file;
  var itemHeight;
  var itemWidth;
  
  FileIcon({
    Key key,
    @required this.itemHeight,
    @required this.itemWidth,
    @required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    File f = File(file.path);
    String _extension = extension(f.path).toLowerCase();
    String mimeType = mime(basename(file.path).toLowerCase());
    String type = mimeType == null ? "" : mimeType.split("/")[0];
    if (_extension == ".apk") {
      return Icon(Icons.android, color: Colors.green, size:60);
    } else if (_extension == ".crdownload") {
      return Icon(Feather.download, color: Colors.lightBlue, size:60);
    } else if (_extension == ".zip" || _extension.contains("tar")) {
      return Icon(Feather.archive, size:60);
    } else if (_extension == ".epub" ||
        _extension == ".pdf" ||
        _extension == ".mobi") {
      return Icon(Feather.file_text, color: Colors.orangeAccent, size:60);
    } else {
      switch (type) {
        case "image":
          FileImage img = FileImage(File(file.path));
          return AspectRatio(
            aspectRatio: this.itemWidth / this.itemHeight,
            child: new Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.center,
                    image: ResizeImage(img ,
                        width: this.itemWidth.round()
                    ),
                  )
              ),
            )
          );

          break;
        case "video":
          return Icon(Feather.video, size:60);
          break;
        case "audio":
          return Icon(Feather.music, color: Colors.blue, size: 60);
          break;
        case "text":
          return Icon(Feather.file_text, color: Colors.orangeAccent, size: 60);
          break;
        default:
          return Icon(Feather.file, size: 60);
          break;
      }
    }
  }
}

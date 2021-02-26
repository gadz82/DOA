import 'dart:io';
import 'package:wanted/widgets/video_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';

class FileIcon extends StatelessWidget {
  final FileSystemEntity file;
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

          return AspectRatio(
            aspectRatio: this.itemWidth / this.itemHeight,
            child: new Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    fit: BoxFit.fitWidth,
                    alignment: FractionalOffset.center,
                    image: ResizeImage(FileImage(File(file.path)), width: this.itemWidth.round()),
                  )
              ),
            )
          );

          break;
        case "video":
          return Container(
            height: this.itemHeight,
            width: this.itemWidth,
            child: VideoThumbnail(
              itemHeight : this.itemHeight,
              itemWidth: this.itemWidth,
              path: file.path,
            ),
          );
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

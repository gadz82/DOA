import 'package:mime_type/mime_type.dart';
import 'dart:io';
import 'package:wanted/widgets/file_detail_gallery.dart';
import 'package:wanted/widgets/file_icon.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';

class FileItem extends StatelessWidget {
  final FileSystemEntity file;
  final List<FileSystemEntity> files;
  final int index;
  final Function popTap;
  final itemHeight;
  final itemWidth;

  FileItem({
    Key key,
    @required this.file,
    @required this.files,
    @required this.index,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GalleryPhotoViewWrapper(
                  galleryItems: this.files,
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  initialIndex: index,
                  scrollDirection: Axis.horizontal,
                ),
              ),
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
                        height: 30,
                        width: 2000,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Theme.of(context).accentColor.withOpacity(0.40),
                                  Theme.of(context).accentColor.withOpacity(0.30),
                                ],
                                stops: [
                                  0.0,
                                  1.0
                                ])),
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(basename(file.path).replaceAll(extension(file.path), ''),overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color:Theme.of(context).appBarTheme.textTheme.headline6.color), textAlign: TextAlign.left)
                        ),
                      )

                    ],
                  )
                ]
            )
        )
    );

  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path/path.dart';

class FileDetail extends StatelessWidget {

  final FileSystemEntity file;

  FileDetail({
    Key key,
    @required this.file
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FileImage fImage = FileImage(File(this.file.path));
    return AppBarLayout(
      title: basename(this.file.path),
      showGoBack: true,
      child: HeroPhotoViewRouteWrapper(imageProvider: fImage, minScale: PhotoViewComputedScale.contained * 1),
    );
  }
}

class HeroPhotoViewRouteWrapper extends StatelessWidget {

  final ImageProvider imageProvider;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  const HeroPhotoViewRouteWrapper({
    this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        backgroundDecoration: backgroundDecoration,
        minScale: minScale,
        maxScale: maxScale,
        heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
      ),
    );
  }
}

class AppBarLayout extends StatelessWidget {
  const AppBarLayout({
    Key key,
    @required this.title,
    this.showGoBack,
    this.child,
  }) : super(key: key);

  final String title;
  final bool showGoBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppBar(
              title: title,
              showGoBack: showGoBack,
            ),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({this.title, this.showGoBack = false}) : super();

  final String title;
  final bool showGoBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            boxShadow: <BoxShadow>[
              const BoxShadow(
                  color: Colors.black12, spreadRadius: 10.0, blurRadius: 20.0)
            ]),
        child: Row(
          children: <Widget>[
            Container(
              child: showGoBack
                  ? IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
              )
                  : Container(
                height: 50.0,
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: Theme.of(context).appBarTheme.textTheme.headline6.fontSize, fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
    );
  }
}
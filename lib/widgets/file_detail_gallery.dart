import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    @required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<FileSystemEntity> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;
  String fileName;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    fileName = basename(widget.galleryItems[widget.initialIndex].path);
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
      fileName = basename(widget.galleryItems[index].path)??"";
    });
  }

  @override
  Widget build(BuildContext context) {

    return AppBarLayout(
      title: this.fileName??"",
      showGoBack: true,
      child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: _buildItem,
        itemCount: widget.galleryItems.length,
        loadingBuilder: widget.loadingBuilder,
        backgroundDecoration: BoxDecoration(color: Theme.of(context).backgroundColor),
        pageController: widget.pageController,
        onPageChanged: onPageChanged,
        scrollDirection: widget.scrollDirection,
      )
    );

  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {

    FileImage fImage = FileImage(File(widget.galleryItems[index].path));

    return PhotoViewGalleryPageOptions(
      imageProvider: fImage,
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * 1,
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: widget.galleryItems[index].path),
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                child: child,
              )]
            ),
            AppBar(
              title: title,
              showGoBack: showGoBack,
            )
          ],
        ),
      ),
    );
  }
}

class AppBar extends StatefulWidget {
  const AppBar({this.title, this.showGoBack = false}) : super();

  final String title;
  final bool showGoBack;

  @override
  _AppBarState createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor.withOpacity(0.40),
            boxShadow: <BoxShadow>[
              const BoxShadow(
                  color: Colors.black12, spreadRadius: 10.0, blurRadius: 20.0)
            ]),
        child: Row(
          children: <Widget>[
            Container(
              child: widget.showGoBack
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
                widget.title,
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
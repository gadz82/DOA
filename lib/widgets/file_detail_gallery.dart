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
        backgroundDecoration: widget.backgroundDecoration,
        pageController: widget.pageController,
        onPageChanged: onPageChanged,
        scrollDirection: widget.scrollDirection,
      )
    );

    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Image ${currentIndex + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
              ),
            )
          ],
        ),
      ),
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
            color: Theme.of(context).accentColor,
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


class _AppBar extends StatelessWidget {
  const _AppBar({this.title, this.showGoBack = false}) : super();

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
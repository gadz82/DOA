import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnail extends StatefulWidget {
  String path;
  var itemWidth;
  var itemHeight;

  VideoThumbnail({
    Key key,
    @required this.itemWidth,
    @required this.itemHeight,
    @required this.path,
  }) : super(key: key);

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> with AutomaticKeepAliveClientMixin {
  String thumb = "";
  bool loading = true;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() {
          loading = false;
        }); //when your thumbnail will show.
      });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return loading
        ? Image.asset(
            "assets/images/video-placeholder.png",
            height: widget.itemHeight,
            width: widget.itemWidth,
            fit: BoxFit.cover,
          )
        : VideoPlayer(_controller);
  }

  @override
  bool get wantKeepAlive => true;
}

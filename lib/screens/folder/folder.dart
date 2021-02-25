import 'dart:developer';
import 'dart:io';

import 'package:wanted/providers/providers.dart';
import 'package:wanted/screens/folder/widgets/set_default_dialog.dart';
import 'package:wanted/screens/folder/widgets/widgets.dart';
import 'package:wanted/utils/utils.dart';
import 'package:wanted/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:path/path.dart' as pathlib;
import 'package:provider/provider.dart';

class Folder extends StatefulWidget {
  final String title;
  final String path;

  Folder({
    Key key,
    @required this.title,
    @required this.path,
  }) : super(key: key);

  @override
  _FolderState createState() => _FolderState();
}

class _FolderState extends State<Folder> with WidgetsBindingObserver {
  String path;
  List<String> paths = List();

  List<FileSystemEntity> files = List();
  bool showHidden = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getFiles();
    }
  }

  String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' :'tablet';
  }

  getFiles() async {
    try {
      var provider = Provider.of<CategoryProvider>(context, listen: false);
      Directory dir = Directory(path);
      List<FileSystemEntity> dirFiles = dir.listSync();
      files.clear();
      showHidden = provider.showHidden;
      setState(() {});
      for (FileSystemEntity file in dirFiles) {
        if (!showHidden) {
          if (!pathlib.basename(file.path).startsWith(".")) {
            files.add(file);
            setState(() {});
          }
        } else {
          files.add(file);
          setState(() {});
        }
      }

      files = FileUtils.sortList(files, provider.sort);
    } catch (e) {
      if (e.toString().contains("Permission denied")) {
        Dialogs.showToast("Permission Denied! cannot access this Directory!");
        navigateBack();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    path = widget.path;
    getFiles();
    paths.add(widget.path);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  navigateBack() {
    paths.removeLast();
    path = paths.last;
    setState(() {});
    getFiles();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    final double itemHeight = this.getDeviceType() == 'phone' ?
    (currentOrientation == Orientation.portrait ? (size.height - kToolbarHeight - size.width) / 1.8 : (size.height - kToolbarHeight) / 1.93):
    (currentOrientation == Orientation.portrait ? (size.height - kToolbarHeight - (size.width / 1.3)) / 2 : (size.height - kToolbarHeight) / 4);
    final double itemWidth = this.getDeviceType() == 'phone' ?
    (currentOrientation == Orientation.portrait ? size.width / 2 : size.width / 3):
    (currentOrientation == Orientation.portrait ? size.width / 3 : size.width / 4);

    return WillPopScope(
      onWillPop: () async {
        if (paths.length == 1) {
          return true;
        } else {
          paths.removeLast();
          setState(() {
            path = paths.last;
          });
          getFiles();
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: paths.length > 1 ? IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {

              navigateBack();

            },
          ) : null,
          elevation: 4,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Text("${widget.title}"),
              PathBar(
                paths: paths,
                icon: widget.path.toString().contains("emulated")
                    ? Feather.smartphone
                    : Icons.sd_card,
                onChanged: (index) {
                  print(paths[index]);
                  path = paths[index];
                  paths.removeRange(index + 1, paths.length);
                  setState(() {});
                  getFiles();
                },
              )
              /*Text(
                "$path",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),*/
            ],
          ),

          actions: <Widget>[
            IconButton(
              onPressed: () async {
                await showModalBottomSheet(
                  context: context,
                  builder: (context) => SortSheet(),
                );
                getFiles();
              },
              tooltip: "Ordina per",
              icon: Icon(Icons.sort),
            ),
          ],
        ),
        body: Visibility(
          replacement: Center(child: Text("There's nothing here")),
          visible: files.isNotEmpty,
          child: GridView.builder(
            padding: EdgeInsets.all(5.00),
            itemCount: files.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (currentOrientation == Orientation.portrait) ? 2 : 3,
              childAspectRatio: (itemWidth / itemHeight)
            ),
            itemBuilder: (BuildContext context, int index) {
              FileSystemEntity file = files[index];
              if (file.toString().split(":")[0] == "Directory") {
                return DirectoryItem(
                  popTap: (v) async {
                    if (v == 0) {
                      renameDialog(context, file.path, "dir");
                    } else if (v == 1) {
                      deleteFile(true, file);
                    }else if (v == 2) {
                      setDafault(context, file.absolute.path);
                    }
                  },
                  file: file,
                  tap: () {
                    paths.add(file.path);
                    path = file.path;
                    setState(() {});
                    getFiles();
                  },
                  itemHeight: itemHeight,
                  itemWidth: itemWidth
                );
              }
              return FileItem(
                file: file,
                itemHeight: itemHeight,
                itemWidth: itemWidth,
                popTap: (v) async {
                  if (v == 0) {
                    renameDialog(context, file.path, "file");
                  } else if (v == 1) {
                    deleteFile(false, file);
                  } else if (v == 2) {
                    /// TODO: Implement Share file feature
                    print("Share");
                  }
                },
              );
            }
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => addDialog(context, path),
          child: Icon(Feather.plus),
          tooltip: "Add Folder",
        ),
      ),
    );
  }

  deleteFile(bool directory, var file) async {
    try {
      if (directory) {
        await Directory(file.path).delete(recursive: true);
      } else {
        await File(file.path).delete(recursive: true);
      }
      Dialogs.showToast('Delete Successful');
    } catch (e) {
      print(e.toString());
      if (e.toString().contains('Permission denied')) {
        Dialogs.showToast('Cannot write to this Storage device!');
      }
    }
    getFiles();
  }

  addDialog(BuildContext context, String path) async {
    await showDialog(
      context: context,
      builder: (context) => AddFileDialog(path: path),
    );
    getFiles();
  }

  renameDialog(BuildContext context, String path, String type) async {
    await showDialog(
      context: context,
      builder: (context) => RenameFileDialog(path: path, type: type),
    );
    getFiles();
  }

  setDafault(BuildContext context, String path) async {
    await showDialog(
      context: context,
      builder: (context) => DefDirDialog(path: path),
    );
    getFiles();
  }
}

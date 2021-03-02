import 'dart:io';

import 'package:wanted/providers/providers.dart';
import 'package:wanted/screens/folder/folder.dart';
import 'package:wanted/utils/utils.dart';
import 'package:wanted/widgets/dir_item.dart';
import 'package:wanted/widgets/file_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends SearchDelegate {
  final ThemeData themeData;

  Search({
    Key key,
    @required this.themeData,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = themeData;
    assert(theme != null);
    return theme.copyWith(
      primaryTextTheme: theme.primaryTextTheme,
      textTheme: theme.textTheme.copyWith(
        headline1: theme.textTheme.headline1.copyWith(
          color: theme.primaryTextTheme.headline6.color,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: theme.primaryTextTheme.headline6.color,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    String getDeviceType() {
      final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
      return data.size.shortestSide < 600 ? 'phone' :'tablet';
    }
    Size size = MediaQuery.of(context).size;
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    final double itemHeight = getDeviceType() == 'phone' ?
    (currentOrientation == Orientation.portrait ? (size.height - kToolbarHeight - size.width) / 1.8 : (size.height - kToolbarHeight) / 1.93):
    (currentOrientation == Orientation.portrait ? (size.height - size.width) / 2 : size.height / 3);
    final double itemWidth = getDeviceType() == 'phone' ?
    (currentOrientation == Orientation.portrait ? size.width / 2 : size.width / 3):
    (currentOrientation == Orientation.portrait ? size.width / 3 : size.width / 3);
    return FutureBuilder<List<FileSystemEntity>>(
      future: FileUtils.searchFiles(
          query,
          Provider.of<CategoryProvider>(context, listen: false).showHidden,
          Provider.of<CategoryProvider>(context, listen: false).adminMode,
          Provider.of<CategoryProvider>(context, listen: false).getDefaultDir()
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot == null
            ? SizedBox()
            : snapshot.hasData
            ? snapshot.data.isEmpty
            ? Center(
          child: Text("Nessuna cartella o file con questo nome"),
        )
            :
        GridView.builder(
            padding: EdgeInsets.all(5.00),
            itemCount: snapshot.data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (currentOrientation == Orientation.portrait) ? 2 : 3,
                childAspectRatio: (itemWidth / itemHeight)
            ),
            itemBuilder: (BuildContext context, int index) {
              FileSystemEntity file = snapshot.data[index];

              return FileItem(
                file: file,
                files: snapshot.data,
                index: index,
                itemHeight: itemHeight,
                itemWidth: itemWidth,
                popTap: () => null,
              );
            }
        )
        : SizedBox();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    String getDeviceType() {
      final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
      return data.size.shortestSide < 600 ? 'phone' :'tablet';
    }
    Size size = MediaQuery.of(context).size;
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    final double itemHeight = getDeviceType() == 'phone' ?
    (currentOrientation == Orientation.portrait ? (size.height - kToolbarHeight - size.width) / 1.8 : (size.height - kToolbarHeight) / 1.93):
    (currentOrientation == Orientation.portrait ? (size.height - size.width) / 2 : size.height / 3);
    final double itemWidth = getDeviceType() == 'phone' ?
    (currentOrientation == Orientation.portrait ? size.width / 2 : size.width / 3):
    (currentOrientation == Orientation.portrait ? size.width / 3 : size.width / 3);
    return FutureBuilder<List<FileSystemEntity>>(
      future: FileUtils.searchFiles(query,
          Provider.of<CategoryProvider>(context, listen: false).showHidden,
          Provider.of<CategoryProvider>(context, listen: false).adminMode,
          Provider.of<CategoryProvider>(context, listen: false).getDefaultDir()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot == null
            ? SizedBox()
            : snapshot.hasData
                ? snapshot.data.isEmpty
                    ? Center(
                        child: Text("Nessuna cartella o file con questo nome"),
                      )
                    :
                    GridView.builder(
                        padding: EdgeInsets.all(5.00),
                        itemCount: snapshot.data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (currentOrientation == Orientation.portrait) ? 2 : 3,
                            childAspectRatio: (itemWidth / itemHeight)
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          FileSystemEntity file = snapshot.data[index];

                          return FileItem(
                            file: file,
                            files: snapshot.data,
                            index: index,
                            itemHeight: itemHeight,
                            itemWidth: itemWidth,
                            popTap: () => null,
                          );
                        }
                    )
                : SizedBox();
      },
    );
  }
}

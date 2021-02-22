import 'dart:developer';
import 'dart:io';

import 'package:filex/providers/providers.dart';
import 'package:filex/screens/apps_screen.dart';
import 'package:path/path.dart' as pathlib;
import 'package:filex/screens/downloads.dart';
import 'package:filex/screens/images.dart';
import 'package:filex/screens/search.dart';
import 'package:filex/screens/whatsapp_status.dart';
import 'package:filex/utils/utils.dart';
import 'package:filex/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';
import '../folder/folder.dart';

class Browse extends StatelessWidget {
  refresh(BuildContext context) async {
    await Provider.of<CoreProvider>(context, listen: false).checkSpace();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "${AppStrings.appName}",
          style: TextStyle(fontSize: 25.0),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: "Search",
            onPressed: () {
              showSearch(
                context: context,
                delegate: Search(themeData: Theme.of(context)),
              );
            },
            icon: Icon(Feather.search),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => refresh(context),
        child: FutureBuilder(
          future: CategoryProvider().getAdminMode(), // a previously-obtained Future<String> or null
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData && snapshot.data) {
                return ListView(
                  padding: EdgeInsets.only(left: 20.0),
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    _SectionTitle('Storage Devices'),
                    _StorageSection(),

                  ],
                );
            } else {
              return FutureBuilder(
                  future: CategoryProvider().getDefaultDir(), // a previously-obtained Future<String> or null
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData && snapshot.data != '') {
                      return Folder(title: pathlib.basename(  snapshot.data), path: snapshot.data);
                    } else {
                      return Text('nada');
                    }
                  }
              );

              return Folder(title: pathlib.basename(CategoryProvider().defDir), path: CategoryProvider().defDir);
            }
          }
        )

      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12.0,
      ),
    );
  }
}

class _StorageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CoreProvider>(
      builder: (BuildContext context, coreProvider, Widget child) {
        if (coreProvider.loading) {
          return Container(height: 100, child: CustomLoader());
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: coreProvider.availableStorage.length,
          itemBuilder: (BuildContext context, int index) {
            FileSystemEntity item = coreProvider.availableStorage[index];

            String path = item.path.split("Android")[0];
            double percent = 0;

            if (index == 0) {
              percent = calculatePercent(
                  coreProvider.usedSpace, coreProvider.totalSpace);
            } else {
              percent = calculatePercent(
                  coreProvider.usedSDSpace, coreProvider.totalSDSpace);
            }
            return StorageItem(
              percent: percent,
              path: path,
              title: index == 0 ? "Device" : "SD Card",
              icon: index == 0 ? Feather.smartphone : Icons.sd_storage,
              color: index == 0 ? Colors.lightBlue : Colors.orange,
              usedSpace: index == 0
                  ? coreProvider.usedSpace
                  : coreProvider.usedSDSpace,
              totalSpace: index == 0
                  ? coreProvider.totalSpace
                  : coreProvider.totalSDSpace,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return CustomDivider();
          },
        );
      },
    );
  }

  calculatePercent(int usedSpace, int totalSpace) {
    return double.parse((usedSpace / totalSpace * 100).toStringAsFixed(0)) /
        100;
  }
}

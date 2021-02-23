import 'dart:io';

import 'package:wanted/providers/providers.dart';
import 'package:wanted/screens/ios_error.dart';
import 'package:wanted/screens/splash.dart';
import 'package:wanted/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: AppStrings.appName,
          theme: appProvider.theme,
          darkTheme: ThemeConfig.darkTheme,
          home: Platform.isIOS ? IosError() : Splash(),
        );
      },
    );
  }
}

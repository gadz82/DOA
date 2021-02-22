import 'dart:developer';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:filex/providers/providers.dart';
import 'package:filex/screens/about.dart';
import 'package:filex/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  bool isLogged = false;

  String password;

  final pwdController = TextEditingController();

  @override
  void dispose() {
    pwdController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    check();
  }

  int sdkVersion = 0;

  check() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      sdkVersion = androidInfo.version.sdkInt;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if(Provider.of<CategoryProvider>(context).adminMode){
      this.setState(() {
        this.isLogged = true;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          if(!this.isLogged) Column(
            children: <Widget>[
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                controller: pwdController,
                onChanged: (text) {
                  if(text == 'tato'){
                    setState(() {
                      this.isLogged = true;
                    });
                  }
                },
              ),

            ],
          ),
          if(this.isLogged) SwitchListTile.adaptive(
            contentPadding: EdgeInsets.all(0),
            secondary: Icon(
              Feather.eye_off,
            ),
            title: Text(
              "See hidden files",
            ),
            value: Provider
                .of<CategoryProvider>(context)
                .showHidden,
            onChanged: (value) {
              Provider.of<CategoryProvider>(context, listen: false)
                  .setHidden(value);
            },
            activeColor: Theme
                .of(context)
                .accentColor,
          ),
          if(this.isLogged) Container(
            height: 1,
            color: Theme
                .of(context)
                .dividerColor,
          ),
          if(this.isLogged) SwitchListTile.adaptive(
            contentPadding: EdgeInsets.all(0),
            secondary: Icon(
              Feather.user,
            ),
            title: Text(
              "Admin Mode",
            ),
            value: Provider
                .of<CategoryProvider>(context)
                .adminMode,
            onChanged: (value) {
              Provider.of<CategoryProvider>(context, listen: false)
                  .setAdminMode(value);
            },
            activeColor: Theme
                .of(context)
                .accentColor,
          ),
          if(this.isLogged) Container(
            height: 1,
            color: Theme
                .of(context)
                .dividerColor,
          ),
          if(this.isLogged) ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Icon(Feather.folder),
            title: Text(Provider
                .of<CategoryProvider>(context)
                .defDir),
          ),
          if(this.isLogged) Container(
            height: 1,
            color: Theme
                .of(context)
                .dividerColor,
          ),
          if(this.isLogged) MediaQuery
              .of(context)
              .platformBrightness !=
              ThemeConfig.darkTheme.brightness
              ? SwitchListTile.adaptive(
            contentPadding: EdgeInsets.all(0),
            secondary: Icon(
              Feather.moon,
            ),
            title: Text("Dark mode"),
            value: Provider
                .of<AppProvider>(context)
                .theme ==
                ThemeConfig.lightTheme
                ? false
                : true,
            onChanged: (v) {
              if (v) {
                Provider.of<AppProvider>(context, listen: false)
                    .setTheme(ThemeConfig.darkTheme, "dark");
              } else {
                Provider.of<AppProvider>(context, listen: false)
                    .setTheme(ThemeConfig.lightTheme, "light");
              }
            },
            activeColor: Theme
                .of(context)
                .accentColor,
          )
              : SizedBox(),
          if(this.isLogged) MediaQuery
              .of(context)
              .platformBrightness !=
              ThemeConfig.darkTheme.brightness
              ? Container(
            height: 1,
            color: Theme
                .of(context)
                .dividerColor,
          )
              : SizedBox(),
          if(this.isLogged) ListTile(
            contentPadding: EdgeInsets.all(0),
            onTap: () => showLicensePage(context: context),
            leading: Icon(Feather.file_text),
            title: Text("Open source licences"),
          ),
          if(this.isLogged) Container(
            height: 1,
            color: Theme
                .of(context)
                .dividerColor,
          ),
          if(this.isLogged) ListTile(
            contentPadding: EdgeInsets.all(0),
            onTap: () => Navigate.pushPage(context, About()),
            leading: Icon(Feather.info),
            title: Text("About"),
          ),
          if(this.isLogged) Container(
            height: 1,
            color: Theme
                .of(context)
                .dividerColor,
          ),
        ],
      ),
    );
  }
}

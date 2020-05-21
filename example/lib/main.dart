import 'dart:io';

import 'package:flutter/material.dart';
import 'package:version_check/version_check.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'version_check demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'version_check Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String version = '';
  String storeVersion = '';
  String packageName = '';
  @override
  void initState() {
    super.initState();
    checkVersion();
  }

  Future checkVersion() async {
    final versionCheck = VersionCheck(
        packageName: Platform.isIOS
            ? 'com.tachyonfactory.iconFinder'
            : 'com.tachyonfactory.icon_finder');
    await versionCheck.checkVersion();
    setState(() {
      version = versionCheck.packageVersion;
      packageName = versionCheck.packageName;
      storeVersion = versionCheck.storeVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'packageVersion = $version',
            ),
            Text(
              'storeVersion = $storeVersion',
            ),
            Text(
              'packageName = $packageName',
            ),
          ],
        ),
      ),
    );
  }
}

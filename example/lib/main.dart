import 'dart:async';
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
      home: MyHomePage(title: 'version_check demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  String? version = '';
  String? storeVersion = '';
  String? storeUrl = '';
  String? packageName = '';

  final versionCheck = VersionCheck(
    packageName: Platform.isIOS ? 'id.smartpoultrysaas.app' : 'id.telkomiotsaas.app',
    packageVersion: '2.0.6',
    showUpdateDialog: customShowUpdateDialog,
    country: 'id',
  );

  Future<void> checkVersion() async {
    await versionCheck.checkVersion(context);
    setState(() {
      version = versionCheck.packageVersion;
      packageName = versionCheck.packageName;
      storeVersion = versionCheck.storeVersion;
      storeUrl = versionCheck.storeUrl;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkVersion();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      checkVersion();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'packageVersion = $version',
            ),
            Text(
              'storeVersion = $storeVersion',
            ),
            Text(
              'storeUrl = $storeUrl',
            ),
            Text(
              'packageName = $packageName',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.store),
        onPressed: () async {
          await versionCheck.launchStore();
        },
      ),
    );
  }
}

void customShowUpdateDialog(BuildContext context, VersionCheck versionCheck) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('NEW Update Available'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(
              'Do you REALLY want to update to ${versionCheck.storeVersion}?',
            ),
            Text('(current version ${versionCheck.packageVersion})'),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Update'),
          onPressed: () async {
            await versionCheck.launchStore();
            unawaited(Future.delayed(const Duration(milliseconds: 300)));
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

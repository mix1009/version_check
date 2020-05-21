library version_check;

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'dart:math' as math;

import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

// typedef Future<StoreVersionAndUrl> getStoreVersionAndUrl(String);

class StoreVersionAndUrl {
  final String storeVersion;
  final String storeUrl;

  StoreVersionAndUrl(this.storeVersion, this.storeUrl);
}

class VersionCheck {
  String packageName;
  String packageVersion;
  String storeVersion;
  String storeUrl;

  /// VersionCheck constructor
  ///
  /// optional packageName : uses package_info if not provided
  /// optional packageVersion : uses package_info if not provided
  VersionCheck({
    this.packageName,
    this.packageVersion,
  });

  /// check version from iOS/Android/Mac store and
  /// provide update dialog if update is available.
  Future checkVersion(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    packageName ??= packageInfo.packageName;
    packageVersion ??= packageInfo.version;

    switch (Platform.operatingSystem) {
      case 'android':
        final storeVersionAndUrl =
            await _getAndroidStoreVersionAndUrl(packageName);
        storeVersion = storeVersionAndUrl.storeVersion;
        storeUrl = storeVersionAndUrl.storeUrl;
        break;
      case 'ios':
        final storeVersionAndUrl = await _getIOSStoreVersionAndUrl(packageName);
        storeVersion = storeVersionAndUrl.storeVersion;
        storeUrl = storeVersionAndUrl.storeUrl;
        break;
      case 'macos':
        final storeVersionAndUrl = await _getMacStoreVersionAndUrl(packageName);
        storeVersion = storeVersionAndUrl.storeVersion;
        storeUrl = storeVersionAndUrl.storeUrl;
        break;
      default:
        throw "Platform ${Platform.operatingSystem} not supported.";
    }

    if (hasUpdate) {
      showUpdateDialog(context);
    }
  }

  void showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Update Available'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Do you want to update to $storeVersion?'),
              Text('(current version $packageVersion)'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Update'),
            onPressed: () async {
              await launchStore();
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  get hasUpdate {
    if (packageVersion == null) return false;
    if (storeVersion == null) return false;
    return _shouldUpdate(packageVersion, storeVersion);
  }

  Future launchStore() async {
    final url = storeUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

Future<StoreVersionAndUrl> _getIOSStoreVersionAndUrl(String bundleId) async {
  final resp =
      await http.get('https://itunes.apple.com/lookup?bundleId=$bundleId');

  if (resp.statusCode == 200) {
    final j = json.decode(resp.body);
    final version = j['results'][0]['version'];
    final url = j['results'][0]['trackViewUrl'];
    return StoreVersionAndUrl(version, url);
  }

  return null;
}

Future<StoreVersionAndUrl> _getAndroidStoreVersionAndUrl(
    String packageName) async {
  final resp = await http.get(
      'https://play.google.com/store/apps/details?id=$packageName&hl=en',
      headers: {
        'referer': 'http://www.google.com',
        'user-agent':
            "Mozilla/5.0 (Windows; U; WindowsNT 5.1; en-US; rv1.8.1.6) Gecko/20070725 Firefox/2.0.0.6",
      });

  if (resp.statusCode == 200) {
    final doc = parse(resp.body);
    final url = 'https://play.google.com/store/apps/details?id=$packageName';

    try {
      final elements = doc.querySelectorAll('.hAyfc .BgcNfc');

      final cv =
          elements.firstWhere((element) => element.text == 'Current Version');
      final version = cv.nextElementSibling.text;
      return StoreVersionAndUrl(version, url);
    } catch (_) {}
    try {
      final elements = doc.querySelectorAll('div');

      final cv =
          elements.firstWhere((element) => element.text == 'Current Version');
      final version = cv.nextElementSibling.text;
      return StoreVersionAndUrl(version, url);
    } catch (_) {}
  }

  return null;
}

Future<StoreVersionAndUrl> _getMacStoreVersionAndUrl(String bundleId) async {
  final resp =
      await http.get('https://itunes.apple.com/lookup?bundleId=$bundleId');

  if (resp.statusCode == 200) {
    final j = json.decode(resp.body);
    // print(j);
    final version = j['results'][0]['version'];
    final url = j['results'][0]['trackViewUrl'];
    return StoreVersionAndUrl(version, url);
  }

  return null;
}

bool _shouldUpdate(String packageVersion, String storeVersion) {
  if (packageVersion == storeVersion) return false;

  final arr1 = packageVersion.split('.');
  final arr2 = storeVersion.split('.');

  for (int i = 0; i < math.min(arr1.length, arr2.length); i++) {
    int v1 = int.tryParse(arr1[i]);
    int v2 = int.tryParse(arr2[i]);

    if (v1 == null || v2 == null) {
      if (arr2[i].compareTo(arr1[i]) > 0) {
        return true;
      }
    } else if (v2 > v1) {
      return true;
    }
  }

  return false;
}

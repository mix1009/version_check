library version_check;

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

import 'package:package_info/package_info.dart';

class VersionCheck {
  String packageVersion;
  String packageBuildNumber;
  String packageName;
  String storeVersion;

  VersionCheck({this.packageName});

  Future checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    packageName ??= packageInfo.packageName;
    packageVersion = packageInfo.version;
    packageBuildNumber = packageInfo.buildNumber;

    switch (Platform.operatingSystem) {
      case 'android':
        storeVersion = await getAndroidStoreVersion(packageName);
        break;
      case 'ios':
        storeVersion = await getIOSStoreVersion(packageName);
        break;
      case 'macos':
        storeVersion = await getMacStoreVersion(packageName);
        break;
      default:
        throw "Platform ${Platform.operatingSystem} not supported.";
    }
  }
}

Future<String> getIOSStoreVersion(String bundleId) async {
  final resp =
      await http.get('https://itunes.apple.com/lookup?bundleId=$bundleId');

  if (resp.statusCode == 200) {
    final j = json.decode(resp.body);
    final version = j['results'][0]['version'];
    return version;
  }

  return null;
}

Future<String> getAndroidStoreVersion(String packageName) async {
  final resp = await http.get(
      'https://play.google.com/store/apps/details?id=$packageName&hl=en',
      headers: {
        'Referer': 'http://www.google.com',
        'User-Agent':
            "Mozilla/5.0 (Windows; U; WindowsNT 5.1; en-US; rv1.8.1.6) Gecko/20070725 Firefox/2.0.0.6",
      });

  if (resp.statusCode == 200) {
    final doc = parse(resp.body);

    try {
      final elements = doc.querySelectorAll('.hAyfc .BgcNfc');

      final cv =
          elements.firstWhere((element) => element.text == 'Current Version');
      return cv.nextElementSibling.text;
    } catch (_) {}
    try {
      final elements = doc.querySelectorAll('div');

      final cv =
          elements.firstWhere((element) => element.text == 'Current Version');
      return cv.nextElementSibling.text;
    } catch (_) {}
  }

  return null;
}

Future<String> getMacStoreVersion(String bundleId) async {
  final resp =
      await http.get('https://itunes.apple.com/lookup?bundleId=$bundleId');

  if (resp.statusCode == 200) {
    final j = json.decode(resp.body);
    // print(j);
    final version = j['results'][0]['version'];
    return version;
  }

  return null;
}

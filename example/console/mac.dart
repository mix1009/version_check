import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  String version = await getMacStoreVersion('com.apple.logic10');
  print(version);
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

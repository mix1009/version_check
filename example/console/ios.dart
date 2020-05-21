import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  String version = await getIOSStoreVersion('com.tachyonfactory.iconFinder');
  print(version);
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

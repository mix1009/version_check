import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  String? version = await getIOSStoreVersion('com.tachyonfactory.iconFinder');
  print(version);
}

Future<String?> getIOSStoreVersion(String bundleId) async {
  final uri = Uri.https('itunes.apple.com', '/lookup', {'bundleId': bundleId, 'country': 'us'});
  final resp = await http.get(uri);

  if (resp.statusCode == 200) {
    final j = json.decode(resp.body);
    //for (final key in j['results'][0].keys) {
      //print('$key => ${j["results"][0][key]}');
    //}
    final version = j['results'][0]['version'];
    return version;
  }

  return null;
}

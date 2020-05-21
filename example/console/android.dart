import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

void main() async {
  String version =
      await getAndroidStoreVersion('com.tachyonfactory.icon_finder');
  print(version);
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

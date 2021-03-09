import 'dart:math' as math;

void main() {
  // dart --enable-asserts version_compare.dart
  assert(shouldUpdate('1.0.0', '1.1.0') == true);
  assert(shouldUpdate('1.1.0', '1.1.0') == false);
  assert(shouldUpdate('1.1.1', '1.1.0') == false);
  assert(shouldUpdate('1.1.1a', '1.1.1b') == true);
}

bool shouldUpdate(String packageVersion, String storeVersion) {
  if (packageVersion == storeVersion) return false;

  final arr1 = packageVersion.split('.');
  final arr2 = storeVersion.split('.');

  for (int i = 0; i < math.min(arr1.length, arr2.length); i++) {
    int? v1 = int.tryParse(arr1[i]);
    int? v2 = int.tryParse(arr2[i]);

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

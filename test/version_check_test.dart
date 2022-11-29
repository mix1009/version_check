import 'package:flutter_test/flutter_test.dart';
import 'package:version_check/version_check.dart';

void main() {
  test('check shouldUpdate', () {
    // VersionCheck.shouldUpdate(packageVersion, storeVersion)
    expect(VersionCheck.shouldUpdate('1.0.0', '1.0.0'), false);
    expect(VersionCheck.shouldUpdate('1.0.0', '1.0.1'), true);
    expect(VersionCheck.shouldUpdate('1.2.10', '1.10.2'), true);
    expect(VersionCheck.shouldUpdate('3.1.2', '4.0.0'), true);
    expect(VersionCheck.shouldUpdate('3.1.0', '3.0.68'), false);

    expect(VersionCheck.shouldUpdate('3.1.10', '3.1.10a'), true);
    expect(VersionCheck.shouldUpdate('3.1.10b', '3.1.10a'), false);
    expect(VersionCheck.shouldUpdate('3.1.1', '3.1.1.a'), true);

    expect(VersionCheck.shouldUpdate('1.0.0', '1.0.0.0'), true);
    expect(VersionCheck.shouldUpdate('1.0.0', '1.0.0a'), true);

    expect(VersionCheck.shouldUpdate('1.2', '1.10'), true);
    expect(VersionCheck.shouldUpdate('0.0.0.99', '0.0.0.100'), true);
  });
}

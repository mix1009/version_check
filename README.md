# version_check

Check iOS/Android/Mac store app version and provide update alert if neccessary.

## Usage

```
import 'package:version_check/version_check.dart';

  final versionCheck = VersionCheck();

  @override
  void initState() {
    super.initState();
    checkVersion();
  }

  Future checkVersion() async {
    await versionCheck.checkVersion(context);
  }
```
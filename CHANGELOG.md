## [0.8.0] - 2026/05/05
* Upgrade all dependencies to latest versions (package_info_plus 10.x, http 1.6, html 0.15.6, url_launcher 6.3, flutter_lints 6.0)
* Fix Android Play Store version parsing (redesignedVersion regex now correctly extracts version instead of returning category names like "Tools")
* Update SDK constraints: Dart >=3.10.0, Flutter >=3.38.1
* Modernize Android build: Gradle 8.13, AGP 8.12.1, Kotlin 2.2.0
* Bump iOS deployment target to 13.0
* Dart lint fixes (const constructors, super parameters)

## [0.7.1] - 2024/01/01
* upgrade packages

## [0.4.0] - 2023/05/25
* upgrade packages for flutter 3.10 (PR by monfadev)

## [0.3.0] - 2022/11/29
* fix version compare logic (bug report by DevNico) 

## [0.2.2] - 2022/08/24

* add country parameter when requesting ios/mac version info (default='us').
* optional country argument added to VersionCheck constructor.

## [0.2.1] - 2022/06/03

* fix getting play store version due to web page change. (It will only work when version is formatted as '1.2.3') 

## [0.2.0+1] - 2022/08/05

* Migrated from the deprecated package_info plugin to package_info_plus. (contributed by https://github.com/lscbot)

## [0.2.0] - 2021/03/09

* null safety

## [0.1.1] - 2020/05/21

* getStoreVersionAndUrl can be passed to constructor to override fetching version and url info.
* showUpdateDialog can be passed to constructor to override update dialog.

## [0.1.0] - 2020/05/21

* Initial release.

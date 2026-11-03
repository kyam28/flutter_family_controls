## 0.0.7

* Android: Built-in Kotlin に移行（`kotlin-android` プラグインの適用をやめ、
  `kotlin { compilerOptions }` に変更）。AGP 9 + Flutter 3.47 で出る
  「plugins that apply Kotlin Gradle Plugin (KGP)」警告を解消
* 最小バージョンを Flutter 3.44 / Dart 3.12 に引き上げ

## 0.0.6

* iOS: Swift Package Manager 対応を追加（CocoaPods も引き続き利用可）。
  Swift ソースを `ios/flutter_family_controls/Sources/flutter_family_controls/`
  に移動し、`Package.swift` を追加。最小 iOS を 15.0 に統一
* iOS: `PrivacyInfo.xcprivacy` を SwiftPM / CocoaPods の両方でアプリに同梱するよう修正

## 0.0.5

* Add `requestAuthorizationDetailed()` returning a
  `FamilyControlsAuthorizationResult` so apps can explain failures
  (`unavailable` = Screen Time is turned off, `authorizationCanceled`,
  `restricted`, ...)
* Add `getAuthorizationStatus()` returning
  `FamilyControlsAuthorizationStatus` (notDetermined / denied / approved)
* Work around the undocumented 50-app shield limit: iOS shields *nothing*
  when `shield.applications` gets more than 50 tokens, so
  `enableRestrictions()` now shields the first 50 instead. Add
  `maxShieldedApplications`, `getSelectedApplicationCount()` and
  `getSelectedCategoryCount()` so apps can warn users

## 0.0.4

* Add no-op Android implementation — all methods report "unsupported",
  so the plugin can be included on Android without platform guards
* Shorten pubspec description to follow pub.dev conventions
* Add `SelectedAppIconsView` widget — a native platform view that shows the
  selected apps/categories as a horizontally scrollable row of icons
  (rendered via SwiftUI `Label(token)`, auto-updates after picker saves)

## 0.0.3

* Lower minimum iOS deployment target to 13.0 (Screen Time features require iOS 16+ at runtime via @available checks)

## 0.0.2

* Add customizable labels for FamilyActivityPicker (title, cancelLabel, saveLabel)
* Fix podspec homepage URL and author email

## 0.0.1

* Initial release
* FamilyControls authorization
* FamilyActivityPicker for app selection
* ManagedSettings shield for enabling/disabling app restrictions

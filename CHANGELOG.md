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

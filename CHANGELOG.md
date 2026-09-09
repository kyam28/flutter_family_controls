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

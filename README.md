# flutter_family_controls

A Flutter plugin for iOS **Screen Time API** (FamilyControls / ManagedSettings).

This plugin allows Flutter apps to:
- Request Screen Time authorization
- Show the native `FamilyActivityPicker` to let users select apps
- Enable/disable app restrictions (shield) using `ManagedSettings`

## Requirements

- **iOS 16.0+** (real device only, not supported on Simulator)
- The `Family Controls` capability must be added to your Xcode project

> **Android**: the Screen Time API is iOS-only. The plugin can still be
> included on Android — every method safely reports "unsupported"
> (`isSupported()` returns `false`), so no platform guards are needed.

## Setup

### 1. Add the capability in Xcode

Open your iOS project in Xcode, go to **Signing & Capabilities**, and add **Family Controls**.

### 2. Add the dependency

```yaml
dependencies:
  flutter_family_controls: ^0.0.1
```

### 3. Set minimum iOS version

In your `ios/Podfile`, ensure the platform is set to at least iOS 16:

```ruby
platform :ios, '16.0'
```

## Usage

```dart
import 'package:flutter_family_controls/flutter_family_controls.dart';

// Check if Screen Time API is available
final supported = await FlutterFamilyControls.isSupported();

// Request authorization
final authorized = await FlutterFamilyControls.requestAuthorization();

// ...or get the reason when it fails
final outcome = await FlutterFamilyControls.requestAuthorizationDetailed();
if (outcome == FamilyControlsAuthorizationResult.unavailable) {
  // Screen Time is turned off in Settings — tell the user to enable it
}

// Show app picker (with default English labels)
final hasApps = await FlutterFamilyControls.showAppPicker();

// Show app picker with custom labels (e.g. Japanese)
final hasApps2 = await FlutterFamilyControls.showAppPicker(
  title: '制限するアプリを選択',
  cancelLabel: 'キャンセル',
  saveLabel: '保存',
);

// Enable restrictions (block selected apps)
await FlutterFamilyControls.enableRestrictions();

// Disable restrictions (unblock)
await FlutterFamilyControls.disableRestrictions();
```


### Showing the selected apps' icons

Apple keeps the selection opaque — your app can never read the selected
apps' names or icons as data. The only sanctioned way to display them is
SwiftUI's `Label(token)`, which this plugin embeds as a platform view:

```dart
// Horizontally scrollable row of the selected app/category icons.
// Updates automatically after the picker saves.
const SelectedAppIconsView(
  height: 48,
  iconSize: 40,
  spacing: 8,
)
```

Renders nothing on non-iOS platforms, and falls back to an empty view on
the Simulator or iOS < 16.

## API

| Method | Description |
|---|---|
| `isSupported()` | Returns `true` if Screen Time API is available (iOS 16+, real device) |
| `requestAuthorization()` | Requests FamilyControls authorization |
| `requestAuthorizationDetailed()` | Same, but returns a `FamilyControlsAuthorizationResult` (`approved`, `unavailable` = Screen Time off, `authorizationCanceled`, `restricted`, ...) |
| `isAuthorized()` | Checks if already authorized |
| `getAuthorizationStatus()` | Returns `FamilyControlsAuthorizationStatus` (`notDetermined` / `denied` / `approved`) |
| `showAppPicker({title, cancelLabel, saveLabel})` | Shows native FamilyActivityPicker with customizable labels. Returns whether apps are selected |
| `hasSelectedApps()` | Whether any apps/categories are currently selected |
| `getSelectedAppCount()` | Number of selected apps + categories |
| `getSelectedApplicationCount()` / `getSelectedCategoryCount()` | Split counts. iOS can shield at most `maxShieldedApplications` (50) individual apps — beyond that the system shields nothing, so warn the user (categories don't count) |
| `enableRestrictions()` | Blocks the selected apps using ManagedSettings shield |
| `disableRestrictions()` | Removes all app restrictions |
| `SelectedAppIconsView` (widget) | Native horizontal row of the selected app icons |

## How it works

This plugin uses three Apple frameworks:
- **FamilyControls** - Authorization and `FamilyActivityPicker`
- **ManagedSettings** - `ManagedSettingsStore` to shield (block) apps
- The selected apps are persisted via `UserDefaults`

## License

MIT

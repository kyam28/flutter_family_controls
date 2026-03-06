# flutter_family_controls

A Flutter plugin for iOS **Screen Time API** (FamilyControls / ManagedSettings).

This plugin allows Flutter apps to:
- Request Screen Time authorization
- Show the native `FamilyActivityPicker` to let users select apps
- Enable/disable app restrictions (shield) using `ManagedSettings`

## Requirements

- **iOS 16.0+** (real device only, not supported on Simulator)
- The `Family Controls` capability must be added to your Xcode project

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

## API

| Method | Description |
|---|---|
| `isSupported()` | Returns `true` if Screen Time API is available (iOS 16+, real device) |
| `requestAuthorization()` | Requests FamilyControls authorization |
| `isAuthorized()` | Checks if already authorized |
| `showAppPicker({title, cancelLabel, saveLabel})` | Shows native FamilyActivityPicker with customizable labels. Returns whether apps are selected |
| `hasSelectedApps()` | Whether any apps/categories are currently selected |
| `getSelectedAppCount()` | Number of selected apps + categories |
| `enableRestrictions()` | Blocks the selected apps using ManagedSettings shield |
| `disableRestrictions()` | Removes all app restrictions |

## How it works

This plugin uses three Apple frameworks:
- **FamilyControls** - Authorization and `FamilyActivityPicker`
- **ManagedSettings** - `ManagedSettingsStore` to shield (block) apps
- The selected apps are persisted via `UserDefaults`

## License

MIT

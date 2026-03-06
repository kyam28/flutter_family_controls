import 'dart:io';
import 'package:flutter/services.dart';

class FlutterFamilyControls {
  static const _channel = MethodChannel('flutter_family_controls');

  /// Whether Screen Time API is supported (iOS 16+ on real device only)
  static Future<bool> isSupported() async {
    if (!Platform.isIOS) return false;
    try {
      return await _channel.invokeMethod<bool>('isSupported') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Request Screen Time authorization
  static Future<bool> requestAuthorization() async {
    try {
      return await _channel.invokeMethod<bool>('requestAuthorization') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Check if already authorized
  static Future<bool> isAuthorized() async {
    try {
      return await _channel.invokeMethod<bool>('isAuthorized') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Show the FamilyActivityPicker to select apps to restrict.
  /// Returns whether any apps are selected after dismissal.
  ///
  /// You can customize the UI strings:
  /// - [title] - Navigation bar title (default: "Select Apps")
  /// - [cancelLabel] - Cancel button text (default: "Cancel")
  /// - [saveLabel] - Save button text (default: "Save")
  static Future<bool> showAppPicker({
    String? title,
    String? cancelLabel,
    String? saveLabel,
  }) async {
    try {
      return await _channel.invokeMethod<bool>('showAppPicker', {
        if (title != null) 'title': title,
        if (cancelLabel != null) 'cancelLabel': cancelLabel,
        if (saveLabel != null) 'saveLabel': saveLabel,
      }) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Whether any apps/categories are currently selected
  static Future<bool> hasSelectedApps() async {
    try {
      return await _channel.invokeMethod<bool>('hasSelectedApps') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Get the count of selected apps + categories
  static Future<int> getSelectedAppCount() async {
    try {
      return await _channel.invokeMethod<int>('getSelectedAppCount') ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// Enable restrictions (block selected apps)
  static Future<bool> enableRestrictions() async {
    try {
      return await _channel.invokeMethod<bool>('enableRestrictions') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Disable restrictions (unblock all apps)
  static Future<bool> disableRestrictions() async {
    try {
      return await _channel.invokeMethod<bool>('disableRestrictions') ?? false;
    } catch (_) {
      return false;
    }
  }
}

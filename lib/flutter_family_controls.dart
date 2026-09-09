import 'dart:io';
import 'package:flutter/services.dart';

export 'src/selected_app_icons_view.dart';

/// Outcome of [FlutterFamilyControls.requestAuthorizationDetailed].
///
/// Everything except [approved] maps to a `FamilyControlsError` case thrown
/// by `AuthorizationCenter.requestAuthorization(for: .individual)`.
enum FamilyControlsAuthorizationResult {
  /// Authorization was granted.
  approved,

  /// The user dismissed the system prompt or canceled Face ID / passcode.
  authorizationCanceled,

  /// The system could not set up Family Controls. In practice this is what
  /// iOS returns when **Screen Time is turned off** in Settings.
  unavailable,

  /// Screen Time is restricted on this device (e.g. by a parent / MDM).
  restricted,

  /// The signed-in Apple Account cannot be authorized (account type).
  invalidAccountType,

  /// A device passcode / biometric is required but not set up.
  authenticationMethodUnavailable,

  /// Another app or profile already holds a conflicting authorization.
  authorizationConflict,

  /// A network error occurred while authorizing.
  networkError,

  /// An invalid argument was passed to the system API.
  invalidArgument,

  /// Not available on this platform (Android / Simulator / iOS < 16).
  unsupported,

  /// Any other failure.
  unknown;

  static FamilyControlsAuthorizationResult _fromName(String? name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return FamilyControlsAuthorizationResult.unknown;
  }
}

/// Current Screen Time authorization status of the app.
enum FamilyControlsAuthorizationStatus {
  /// The user has not been asked yet.
  notDetermined,

  /// The user declined (or revoked) authorization.
  denied,

  /// The app is authorized.
  approved;

  static FamilyControlsAuthorizationStatus _fromName(String? name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return FamilyControlsAuthorizationStatus.notDetermined;
  }
}

class FlutterFamilyControls {
  static const _channel = MethodChannel('flutter_family_controls');

  /// Maximum number of individual applications iOS can shield at once.
  ///
  /// `ManagedSettingsStore.shield.applications` silently shields **nothing**
  /// when given more tokens than this (undocumented system limit). The plugin
  /// shields the first [maxShieldedApplications] in that case, but apps should
  /// warn users to stay under the limit (selecting categories does not count).
  static const int maxShieldedApplications = 50;

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

  /// Request Screen Time authorization and report *why* it failed.
  ///
  /// Use this instead of [requestAuthorization] when you want to tell the user
  /// something actionable, e.g. [FamilyControlsAuthorizationResult.unavailable]
  /// means Screen Time is turned off in the device Settings.
  static Future<FamilyControlsAuthorizationResult>
      requestAuthorizationDetailed() async {
    if (!Platform.isIOS) return FamilyControlsAuthorizationResult.unsupported;
    try {
      final name =
          await _channel.invokeMethod<String>('requestAuthorizationDetailed');
      return FamilyControlsAuthorizationResult._fromName(name);
    } on PlatformException catch (e) {
      if (e.code == 'UNSUPPORTED') {
        return FamilyControlsAuthorizationResult.unsupported;
      }
      return FamilyControlsAuthorizationResult.unknown;
    } catch (_) {
      return FamilyControlsAuthorizationResult.unknown;
    }
  }

  /// Current authorization status (notDetermined / denied / approved).
  static Future<FamilyControlsAuthorizationStatus>
      getAuthorizationStatus() async {
    if (!Platform.isIOS) return FamilyControlsAuthorizationStatus.notDetermined;
    try {
      final name = await _channel.invokeMethod<String>('getAuthorizationStatus');
      return FamilyControlsAuthorizationStatus._fromName(name);
    } catch (_) {
      return FamilyControlsAuthorizationStatus.notDetermined;
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
          }) ??
          false;
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

  /// Number of individually selected applications (excluding categories).
  /// Compare against [maxShieldedApplications].
  static Future<int> getSelectedApplicationCount() async {
    try {
      return await _channel.invokeMethod<int>('getSelectedApplicationCount') ??
          0;
    } catch (_) {
      return 0;
    }
  }

  /// Number of selected categories.
  static Future<int> getSelectedCategoryCount() async {
    try {
      return await _channel.invokeMethod<int>('getSelectedCategoryCount') ?? 0;
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

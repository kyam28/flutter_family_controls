package com.kyam28.flutter_family_controls

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * No-op Android implementation.
 *
 * The Screen Time API (FamilyControls / ManagedSettings) is iOS-only, so
 * every method reports "unsupported" instead of throwing. This lets apps
 * call the plugin unconditionally on both platforms.
 */
class FlutterFamilyControlsPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "flutter_family_controls")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isSupported",
            "requestAuthorization",
            "isAuthorized",
            "showAppPicker",
            "hasSelectedApps",
            "enableRestrictions",
            "disableRestrictions" -> result.success(false)
            "getSelectedAppCount",
            "getSelectedApplicationCount",
            "getSelectedCategoryCount" -> result.success(0)
            "requestAuthorizationDetailed" -> result.success("unsupported")
            "getAuthorizationStatus" -> result.success("notDetermined")
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

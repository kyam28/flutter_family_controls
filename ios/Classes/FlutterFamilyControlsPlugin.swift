import Flutter
import UIKit

#if !targetEnvironment(simulator)
import SwiftUI
#endif

public class FlutterFamilyControlsPlugin: NSObject, FlutterPlugin {
    #if !targetEnvironment(simulator)
    private var dismissObserver: NSObjectProtocol?
    #endif

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "flutter_family_controls",
            binaryMessenger: registrar.messenger()
        )
        let instance = FlutterFamilyControlsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        #if targetEnvironment(simulator)
        if call.method == "isSupported" {
            result(false)
        } else {
            result(FlutterError(
                code: "UNSUPPORTED",
                message: "Screen Time API is not supported on Simulator",
                details: nil
            ))
        }
        #else
        if #available(iOS 16.0, *) {
            handleMethodCall(call, result: result)
        } else {
            if call.method == "isSupported" {
                result(false)
            } else {
                result(FlutterError(
                    code: "UNSUPPORTED",
                    message: "Screen Time API requires iOS 16+",
                    details: nil
                ))
            }
        }
        #endif
    }

    #if !targetEnvironment(simulator)
    @available(iOS 16.0, *)
    private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let manager = ScreenTimeManager.shared

        switch call.method {
        case "isSupported":
            result(true)

        case "requestAuthorization":
            Task {
                let success = await manager.requestAuthorization()
                DispatchQueue.main.async {
                    result(success)
                }
            }

        case "isAuthorized":
            result(manager.checkAuthorization())

        case "showAppPicker":
            let args = call.arguments as? [String: Any]
            let title = args?["title"] as? String
            let cancelLabel = args?["cancelLabel"] as? String
            let saveLabel = args?["saveLabel"] as? String
            DispatchQueue.main.async {
                self.showFamilyActivityPicker(
                    title: title,
                    cancelLabel: cancelLabel,
                    saveLabel: saveLabel,
                    result: result
                )
            }

        case "hasSelectedApps":
            result(manager.hasSelectedApps())

        case "getSelectedAppCount":
            result(manager.getSelectedAppCount())

        case "enableRestrictions":
            manager.enableRestrictions()
            result(true)

        case "disableRestrictions":
            manager.disableRestrictions()
            result(true)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    @available(iOS 16.0, *)
    private func showFamilyActivityPicker(
        title: String?,
        cancelLabel: String?,
        saveLabel: String?,
        result: @escaping FlutterResult
    ) {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            result(FlutterError(code: "NO_VC", message: "No root view controller", details: nil))
            return
        }

        // Find the topmost presented view controller
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }

        // Clean up previous observer
        if let observer = dismissObserver {
            NotificationCenter.default.removeObserver(observer)
        }

        // Listen for picker dismissal (both save and cancel)
        dismissObserver = NotificationCenter.default.addObserver(
            forName: .familyActivityPickerDismissed,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            if let observer = self?.dismissObserver {
                NotificationCenter.default.removeObserver(observer)
                self?.dismissObserver = nil
            }
            let manager = ScreenTimeManager.shared
            result(manager.hasSelectedApps())
        }

        let pickerView = FamilyActivityPickerView(
            title: title ?? "Select Apps",
            cancelLabel: cancelLabel ?? "Cancel",
            saveLabel: saveLabel ?? "Save"
        )
        let hostingController = UIHostingController(rootView: pickerView)
        hostingController.modalPresentationStyle = .pageSheet

        topVC.present(hostingController, animated: true)
    }
    #endif
}

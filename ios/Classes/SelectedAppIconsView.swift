import Flutter
import UIKit

#if !targetEnvironment(simulator)
import SwiftUI
import FamilyControls
#endif

/// Platform view that renders the currently selected apps/categories as a
/// horizontally scrollable row of icons.
///
/// ApplicationToken is opaque by design, so icons can only be rendered
/// natively via SwiftUI's `Label(token)` inside the authorized app —
/// they can never be exported to Dart as image data.
public class SelectedAppIconsViewFactory: NSObject, FlutterPlatformViewFactory {
    public static let viewType = "flutter_family_controls/selected_app_icons"

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        SelectedAppIconsPlatformView(frame: frame, args: args as? [String: Any])
    }
}

class SelectedAppIconsPlatformView: NSObject, FlutterPlatformView {
    private let containerView: UIView
    // Keep the hosting controller alive for the lifetime of the platform view
    private var hostingController: UIViewController?

    init(frame: CGRect, args: [String: Any]?) {
        #if !targetEnvironment(simulator)
        if #available(iOS 16.0, *) {
            let iconSize = (args?["iconSize"] as? NSNumber)?.doubleValue ?? 40
            let spacing = (args?["spacing"] as? NSNumber)?.doubleValue ?? 8
            let host = UIHostingController(
                rootView: SelectedAppIconsView(iconSize: iconSize, spacing: spacing)
            )
            host.view.backgroundColor = .clear
            hostingController = host
            containerView = host.view
        } else {
            containerView = UIView(frame: frame)
        }
        #else
        containerView = UIView(frame: frame)
        #endif
        super.init()
    }

    func view() -> UIView { containerView }
}

#if !targetEnvironment(simulator)
@available(iOS 16.0, *)
struct SelectedAppIconsView: View {
    // Observing the shared manager keeps the row in sync after the picker saves
    @ObservedObject private var manager = ScreenTimeManager.shared
    let iconSize: Double
    let spacing: Double

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                ForEach(
                    Array(manager.activitySelection.applicationTokens),
                    id: \.self
                ) { token in
                    tokenIcon(Label(token))
                }
                ForEach(
                    Array(manager.activitySelection.categoryTokens),
                    id: \.self
                ) { token in
                    tokenIcon(Label(token))
                }
            }
            .frame(maxHeight: .infinity)
        }
    }

    // Label(token) renders its icon at a fixed system size (~22pt),
    // so scale it to the requested size.
    private func tokenIcon(_ label: some View) -> some View {
        label
            .labelStyle(.iconOnly)
            .scaleEffect(iconSize / 22)
            .frame(width: iconSize, height: iconSize)
    }
}
#endif

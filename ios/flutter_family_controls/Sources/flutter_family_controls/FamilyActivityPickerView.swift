#if !targetEnvironment(simulator)
import SwiftUI
import FamilyControls

@available(iOS 16.0, *)
struct FamilyActivityPickerView: View {
    @ObservedObject var manager = ScreenTimeManager.shared
    @Environment(\.dismiss) var dismiss

    var title: String
    var cancelLabel: String
    var saveLabel: String

    init(title: String = "Select Apps",
         cancelLabel: String = "Cancel",
         saveLabel: String = "Save") {
        self.title = title
        self.cancelLabel = cancelLabel
        self.saveLabel = saveLabel
    }

    var body: some View {
        NavigationView {
            FamilyActivityPicker(selection: $manager.activitySelection)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(cancelLabel) {
                            NotificationCenter.default.post(
                                name: .familyActivityPickerDismissed,
                                object: nil
                            )
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(saveLabel) {
                            manager.updateSelection(manager.activitySelection)
                            NotificationCenter.default.post(
                                name: .familyActivityPickerDismissed,
                                object: nil
                            )
                            dismiss()
                        }
                        .fontWeight(.bold)
                    }
                }
        }
    }
}

extension Notification.Name {
    static let familyActivityPickerDismissed = Notification.Name(
        "flutter_family_controls_picker_dismissed"
    )
}
#endif

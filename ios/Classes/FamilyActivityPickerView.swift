#if !targetEnvironment(simulator)
import SwiftUI
import FamilyControls

@available(iOS 16.0, *)
struct FamilyActivityPickerView: View {
    @ObservedObject var manager = ScreenTimeManager.shared
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            FamilyActivityPicker(selection: $manager.activitySelection)
                .navigationTitle("Select Apps")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            NotificationCenter.default.post(
                                name: .familyActivityPickerDismissed,
                                object: nil
                            )
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
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

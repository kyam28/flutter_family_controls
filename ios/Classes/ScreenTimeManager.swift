#if !targetEnvironment(simulator)
import Foundation
import ManagedSettings
import FamilyControls
import SwiftUI

@available(iOS 16.0, *)
class ScreenTimeManager: ObservableObject {
    static let shared = ScreenTimeManager()

    private let store = ManagedSettingsStore()
    private let center = AuthorizationCenter.shared

    @Published var activitySelection = FamilyActivitySelection()
    @Published var isAuthorized = false

    private let selectionKey = "flutter_family_controls_activity_selection"

    private init() {
        loadSelection()
        isAuthorized = center.authorizationStatus == .approved
    }

    // MARK: - Authorization

    func requestAuthorization() async -> Bool {
        do {
            try await center.requestAuthorization(for: .individual)
            await MainActor.run {
                isAuthorized = true
            }
            return true
        } catch {
            print("ScreenTime authorization failed: \(error)")
            return false
        }
    }

    func checkAuthorization() -> Bool {
        return center.authorizationStatus == .approved
    }

    // MARK: - App Selection

    func updateSelection(_ selection: FamilyActivitySelection) {
        activitySelection = selection
        saveSelection()
    }

    func hasSelectedApps() -> Bool {
        return !activitySelection.applicationTokens.isEmpty ||
               !activitySelection.categoryTokens.isEmpty ||
               !activitySelection.webDomainTokens.isEmpty
    }

    func getSelectedAppCount() -> Int {
        return activitySelection.applicationTokens.count +
               activitySelection.categoryTokens.count
    }

    // MARK: - Shield (Block/Unblock)

    func enableRestrictions() {
        let apps = activitySelection.applicationTokens
        let categories = activitySelection.categoryTokens

        if !apps.isEmpty {
            store.shield.applications = apps
        }
        if !categories.isEmpty {
            store.shield.applicationCategories = .specific(categories)
        }
    }

    func disableRestrictions() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
    }

    // MARK: - Persistence

    private func saveSelection() {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(activitySelection) {
            UserDefaults.standard.set(data, forKey: selectionKey)
        }
    }

    private func loadSelection() {
        guard let data = UserDefaults.standard.data(forKey: selectionKey) else { return }
        let decoder = PropertyListDecoder()
        if let selection = try? decoder.decode(FamilyActivitySelection.self, from: data) {
            activitySelection = selection
        }
    }
}
#endif

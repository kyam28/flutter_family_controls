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

    /// Requests authorization and returns a stable string describing the outcome.
    /// "approved" on success; otherwise a `FamilyControlsError` case name
    /// ("unavailable" = Screen Time is turned off on the device).
    func requestAuthorizationResult() async -> String {
        do {
            try await center.requestAuthorization(for: .individual)
            await MainActor.run {
                isAuthorized = true
            }
            return "approved"
        } catch let error as FamilyControlsError {
            print("ScreenTime authorization failed: \(error)")
            switch error {
            case .invalidAccountType: return "invalidAccountType"
            case .authorizationCanceled: return "authorizationCanceled"
            case .networkError: return "networkError"
            case .authenticationMethodUnavailable: return "authenticationMethodUnavailable"
            case .authorizationConflict: return "authorizationConflict"
            case .invalidArgument: return "invalidArgument"
            case .unavailable: return "unavailable"
            case .restricted: return "restricted"
            @unknown default: return "unknown"
            }
        } catch {
            print("ScreenTime authorization failed: \(error)")
            return "unknown"
        }
    }

    func checkAuthorization() -> Bool {
        return center.authorizationStatus == .approved
    }

    /// "notDetermined" / "denied" / "approved"
    func authorizationStatusName() -> String {
        switch center.authorizationStatus {
        case .approved: return "approved"
        case .denied: return "denied"
        case .notDetermined: return "notDetermined"
        @unknown default: return "notDetermined"
        }
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

    func getSelectedApplicationCount() -> Int {
        return activitySelection.applicationTokens.count
    }

    func getSelectedCategoryCount() -> Int {
        return activitySelection.categoryTokens.count
    }

    // MARK: - Shield (Block/Unblock)

    /// `ManagedSettingsStore.shield.applications` silently shields *nothing*
    /// when it is given more than 50 tokens (undocumented system limit).
    static let maxShieldedApplications = 50

    func enableRestrictions() {
        let apps = activitySelection.applicationTokens
        let categories = activitySelection.categoryTokens

        if !apps.isEmpty {
            if apps.count > Self.maxShieldedApplications {
                // Shield as many as the system allows instead of none at all.
                print("ScreenTime: \(apps.count) apps selected, only \(Self.maxShieldedApplications) can be shielded")
                store.shield.applications = Set(apps.prefix(Self.maxShieldedApplications))
            } else {
                store.shield.applications = apps
            }
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

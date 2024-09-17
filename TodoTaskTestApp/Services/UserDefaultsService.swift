import Foundation

protocol UserDefaultsServiceProtocol {
    var isFirstLaunch: Bool { get }
    func setFirstLaunchCompleted()
}

final class UserDefaultsService: UserDefaultsServiceProtocol {
    static let shared = UserDefaultsService()
    private let userDefaults: UserDefaults

    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    private let launchedBeforeKey = "launchedBefore"

    var isFirstLaunch: Bool {
        return !userDefaults.bool(forKey: launchedBeforeKey)
    }

    func setFirstLaunchCompleted() {
        userDefaults.set(true, forKey: launchedBeforeKey)
    }
}

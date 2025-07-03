import Foundation

class DataManager {
    static let shared = DataManager()
    private init() {}

    var accounts: [SteamAccount] = []

    func addAccount(_ account: SteamAccount) {
        accounts.append(account)
    }

    func updateAccount(_ account: SteamAccount) {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index] = account
        }
    }

    func deleteAccount(id: UUID) {
        accounts.removeAll { $0.id == id }
    }

    // Optional: JSON file save/load
    private let saveKey = "casefarm_accounts"

    func saveToDisk() {
        if let data = try? JSONEncoder().encode(accounts) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    func loadFromDisk() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let saved = try? JSONDecoder().decode([SteamAccount].self, from: data) {
            accounts = saved
        }
    }
}

// dummy data
extension DataManager {
    static func generateDummyAccounts() -> [SteamAccount] {
        return [
            SteamAccount(
                id: UUID(),
                name: "Main",
                username: "mainacc",
                profileImageData: nil,
                inventory: [.recoil, .kilowatt],
                drops: [.recoil]
            ),
            SteamAccount(
                id: UUID(),
                name: "Smurf 1",
                username: "smurf1",
                profileImageData: nil,
                inventory: [],
                drops: []
            )
        ]
    }
}

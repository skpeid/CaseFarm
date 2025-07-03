import UIKit

class DataManager {
    static let shared = DataManager()
    private init() {
        loadDummyDataIfNeeded()
    }

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
    
    func loadDummyDataIfNeeded() {
        guard accounts.isEmpty else { return }

        let dummyAccounts: [SteamAccount] = (1...5).map { i in
            var account = SteamAccount(
                id: UUID(),
                name: "Dummy \(i)",
                username: "dummy\(i)",
                profileImageData: nil,
                inventory: generateRandomCases(),
                drops: []
            )
            // Optional: assign a profile icon from system
            account.setProfileImage(UIImage(systemName: "person.circle")!)
            return account
        }

        for account in dummyAccounts {
            addAccount(account)
        }
    }
    
    private func generateRandomCases() -> [CaseItem] {
        let all = CaseItem.allCases.shuffled()
        let count = Int.random(in: 2...6)
        return Array(all.prefix(count))
    }


}

import Foundation
import UIKit

class DataManager {
    static let shared = DataManager()

    private(set) var accounts: [SteamAccount] = []
    private(set) var drops: [CaseDrop] = []
    private(set) var trades: [CaseTrade] = []

    private let accountsFile = "accounts.json"
    private let dropsFile = "drops.json"
    private let tradesFile = "trades.json"

    private init() {
        loadAccounts()
        loadDrops()
        loadTrades()
        loadDummyDataIfNeeded()
    }

    // MARK: - Account Management

    func addAccount(_ account: SteamAccount) {
        accounts.append(account)
        saveAccounts()
    }

    func deleteAccount(id: UUID) {
        accounts.removeAll { $0.id == id }
        saveAccounts()
    }

    // MARK: - Drops

    func addDrop(_ drop: CaseDrop) {
        drops.append(drop)
        saveDrops()
    }

    func getAllDrops() -> [CaseDrop] {
        return drops
    }

    // MARK: - Trades

    func addTrade(_ trade: CaseTrade) {
        trades.append(trade)
        saveTrades()
    }

    func getAllTrades() -> [CaseTrade] {
        return trades
    }

    // MARK: - Dummy Data

    func loadDummyDataIfNeeded() {
        guard accounts.isEmpty, drops.isEmpty, trades.isEmpty else { return }

        let dummyAccounts: [SteamAccount] = (1...5).map { i in
            var account = SteamAccount(
                id: UUID(),
                name: "Dummy \(i)",
                username: "dummy\(i)",
                profileImageData: nil,
                inventory: generateRandomCases(),
                drops: []
            )
            account.setProfileImage(UIImage(systemName: "person.circle")!)
            return account
        }

        for account in dummyAccounts {
            addAccount(account)
        }

        // Add 5 dummy drops
        for _ in 1...5 {
            let randomAccount = accounts.randomElement()!
            let randomCase = CaseItem.allCases.randomElement()!
            let drop = CaseDrop(id: UUID(), accountID: randomAccount.id, caseItem: randomCase, date: Date().addingTimeInterval(-Double.random(in: 0...5 * 86400)))
            addDrop(drop)
        }

        // Add 3 dummy trades
        for _ in 1...3 {
            let from = accounts.randomElement()!
            var to = accounts.randomElement()!
            while from.id == to.id { to = accounts.randomElement()! } // prevent same ID

            let randomCase = CaseItem.allCases.randomElement()!
            let trade = CaseTrade(id: UUID(), fromAccountID: from.id, toAccountID: to.id, caseItem: randomCase, date: Date().addingTimeInterval(-Double.random(in: 0...5 * 86400)))
            addTrade(trade)
        }
    }


    private func generateRandomCases() -> [CaseItem] {
        let all = CaseItem.allCases.shuffled()
        let count = Int.random(in: 2...6)
        return Array(all.prefix(count))
    }

    // MARK: - File Persistence

    private func saveAccounts() {
        save(accounts, to: accountsFile)
    }

    private func loadAccounts() {
        accounts = load(from: accountsFile) ?? []
    }

    private func saveDrops() {
        save(drops, to: dropsFile)
    }

    private func loadDrops() {
        drops = load(from: dropsFile) ?? []
    }

    private func saveTrades() {
        save(trades, to: tradesFile)
    }

    private func loadTrades() {
        trades = load(from: tradesFile) ?? []
    }

    private func save<T: Codable>(_ object: T, to filename: String) {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: url)
        } catch {
            print("❌ Failed to save \(filename): \(error)")
        }
    }

    private func load<T: Codable>(from filename: String) -> T? {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("⚠️ Failed to load \(filename): \(error)")
            return nil
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

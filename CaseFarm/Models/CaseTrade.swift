import UIKit

struct CaseTrade: Codable, Identifiable {
    let id: UUID
    let fromAccountID: UUID
    let toAccountID: UUID
    let caseItem: CaseItem
    let date: Date
}

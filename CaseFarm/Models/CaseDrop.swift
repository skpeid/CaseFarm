import UIKit

struct CaseDrop: Codable, Identifiable {
    let id: UUID
    let accountID: UUID
    let caseItem: CaseItem
    let date: Date
}

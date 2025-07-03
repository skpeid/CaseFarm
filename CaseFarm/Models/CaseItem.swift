import UIKit

enum CaseItem: String, CaseIterable, Codable {
    case recoil
    case kilowatt
    case fracture
    case revolution
    case dreamsAndNightmares

    var displayName: String {
        switch self {
        case .recoil: return "Recoil Case"
        case .kilowatt: return "Kilowatt Case"
        case .fracture: return "Fracture Case"
        case .revolution: return "Revolution Case"
        case .dreamsAndNightmares: return "Dreams & Nightmares Case"
        }
    }

    var image: UIImage? {
        return UIImage(named: rawValue) // Match with image names in Assets
    }
}

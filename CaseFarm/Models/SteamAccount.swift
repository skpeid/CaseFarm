import UIKit

struct SteamAccount: Identifiable, Codable {
    let id: UUID
    var name: String
    var username: String
    var profileImageData: Data? // UIImage saved as Data
    var inventory: [CaseItem]
    var drops: [CaseItem]

    // Optional helpers:
    var profileImage: UIImage? {
        guard let data = profileImageData else { return nil }
        return UIImage(data: data)
    }

    mutating func setProfileImage(_ image: UIImage) {
        profileImageData = image.jpegData(compressionQuality: 0.8)
    }
}

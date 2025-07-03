import UIKit

class AccountCell: UITableViewCell {

    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let caseCountLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.backgroundColor = .secondarySystemBackground
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        usernameLabel.textColor = .secondaryLabel
        let textStack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        caseCountLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        caseCountLabel.textColor = .secondaryLabel
        caseCountLabel.setContentHuggingPriority(.required, for: .horizontal)

        let hStack = UIStackView(arrangedSubviews: [profileImageView, textStack, caseCountLabel])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(hStack)

        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with account: SteamAccount) {
        profileImageView.image = account.getProfileImage() ?? UIImage(systemName: "person.crop.circle")
        nameLabel.text = account.name
        usernameLabel.text = account.username
        caseCountLabel.text = "📦 \(account.inventory.count) case" + (account.inventory.count == 1 ? "" : "s")
    }
}

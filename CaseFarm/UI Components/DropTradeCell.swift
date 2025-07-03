import UIKit

class DropTradeCell: UITableViewCell {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.cornerRadius = 8
        iconImageView.clipsToBounds = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2

        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        let hStack = UIStackView(arrangedSubviews: [iconImageView, textStack, dateLabel])
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

    func configure(with item: DropOrTrade, accounts: [SteamAccount]) {
        iconImageView.image = item.caseItem.image

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"

        dateLabel.text = dateFormatter.string(from: item.date)

        switch item {
        case .drop(let drop):
            if let account = accounts.first(where: { $0.id == drop.accountID }) {
                titleLabel.text = "📦 Drop: \(drop.caseItem.displayName)"
                subtitleLabel.text = "Received by \(account.name)"
            } else {
                titleLabel.text = "📦 Drop"
                subtitleLabel.text = "Unknown account"
            }

        case .trade(let trade):
            let from = accounts.first(where: { $0.id == trade.fromAccountID })?.name ?? "Unknown"
            let to = accounts.first(where: { $0.id == trade.toAccountID })?.name ?? "Unknown"
            titleLabel.text = "🔁 Trade: \(trade.caseItem.displayName)"
            subtitleLabel.text = "\(from) → \(to)"
        }
    }
}

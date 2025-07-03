import UIKit

class DropOrTradeCell: UITableViewCell {

    private let fromAccountView = AccountIconView()
    private let toAccountView = AccountIconView()
    private let caseImageView = UIImageView()
    private let arrowImageView = UIImageView()
    private let dateLabel = UILabel()

    private let rowStack = UIStackView()
    private let mainStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: DropOrTrade, accounts: [SteamAccount]) {
        rowStack.arrangedSubviews.forEach { rowStack.removeArrangedSubview($0); $0.removeFromSuperview() }

        caseImageView.image = item.caseItem.image
        dateLabel.text = item.date.formatted(date: .abbreviated, time: .omitted)
        arrowImageView.image = UIImage(systemName: "arrow.right")

        switch item {
        case .drop(let drop):
            if let acc = accounts.first(where: { $0.id == drop.accountID }) {
                fromAccountView.configure(with: acc)
                arrowImageView.image = UIImage(systemName: "plus")

                rowStack.addArrangedSubview(fromAccountView)
                rowStack.addArrangedSubview(spacer(width: 12))

                rowStack.addArrangedSubview(arrowImageView)
                rowStack.addArrangedSubview(spacer(width: 12))

                rowStack.addArrangedSubview(caseImageView)
                rowStack.addArrangedSubview(UIView()) // spacer
            }

        case .trade(let trade):
            if let from = accounts.first(where: { $0.id == trade.fromAccountID }),
               let to = accounts.first(where: { $0.id == trade.toAccountID }) {

                fromAccountView.configure(with: from)
                toAccountView.configure(with: to)

                rowStack.addArrangedSubview(fromAccountView)
                rowStack.addArrangedSubview(spacer(width: 14))

                rowStack.addArrangedSubview(caseImageView)
                rowStack.addArrangedSubview(spacer(width: 10))

                rowStack.addArrangedSubview(arrowImageView)
                rowStack.addArrangedSubview(spacer(width: 10))

                rowStack.addArrangedSubview(toAccountView)
                rowStack.addArrangedSubview(UIView()) // spacer
            }
        }
    }
    
    private func spacer(width: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.widthAnchor.constraint(equalToConstant: width).isActive = true
        return spacer
    }

    private func setupViews() {
        fromAccountView.translatesAutoresizingMaskIntoConstraints = false
        toAccountView.translatesAutoresizingMaskIntoConstraints = false

        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = .label
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        caseImageView.contentMode = .scaleAspectFit
        caseImageView.translatesAutoresizingMaskIntoConstraints = false
        caseImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        caseImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)

        rowStack.axis = .horizontal
        rowStack.alignment = .center
        rowStack.spacing = 6
        rowStack.translatesAutoresizingMaskIntoConstraints = false

        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 10
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        mainStack.addArrangedSubview(rowStack)
        mainStack.addArrangedSubview(dateLabel)

        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}

// CaseInputCell.swift
import UIKit

class CaseInputCell: UICollectionViewCell {

    static let identifier = "CaseInputCell"

    let imageView = UIImageView()
    let nameLabel = UILabel()
    let amountField = UITextField()

    var caseItem: CaseItem?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        amountField.borderStyle = .roundedRect
        amountField.placeholder = "0"
        amountField.keyboardType = .numberPad
        amountField.font = .systemFont(ofSize: 12)
        amountField.translatesAutoresizingMaskIntoConstraints = false
        amountField.textAlignment = .center

        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(amountField)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),

            amountField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            amountField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            amountField.widthAnchor.constraint(equalToConstant: 40),
            amountField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with caseItem: CaseItem) {
        self.caseItem = caseItem
        imageView.image = caseItem.image
        nameLabel.text = caseItem.displayName
    }

    func getAmount() -> Int {
        return Int(amountField.text ?? "") ?? 0
    }
}

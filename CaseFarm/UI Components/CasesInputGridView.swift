// CasesInputGridView.swift
import UIKit

class CasesInputGridView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let collectionView: UICollectionView
    private var caseItems: [CaseItem] = CaseItem.allCases

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 8

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: .zero)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CaseInputCell.self, forCellWithReuseIdentifier: CaseInputCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return caseItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CaseInputCell.identifier, for: indexPath) as! CaseInputCell
        let item = caseItems[indexPath.item]
        cell.configure(with: item)
        return cell
    }

    func getInventory() -> [CaseItem] {
        var inventory: [CaseItem] = []
        for i in 0..<caseItems.count {
            let indexPath = IndexPath(item: i, section: 0)
            guard let cell = collectionView.cellForItem(at: indexPath) as? CaseInputCell else { continue }
            let count = cell.getAmount()
            if count > 0 {
                inventory += Array(repeating: caseItems[i], count: count)
            }
        }
        return inventory
    }
}

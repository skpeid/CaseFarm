import UIKit

class InventoryViewController: UIViewController {

    private var inventory: [CaseItem] = []
    private var grouped: [(case: CaseItem, count: Int)] = []

    private let collectionView: UICollectionView

    init(accountName: String, inventory: [CaseItem]) {
        self.inventory = inventory
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16

        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)

        title = "Inventory of \(accountName)"
        modalPresentationStyle = .pageSheet
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeView)
        )

        grouped = Dictionary(grouping: inventory, by: { $0 })
            .map { (key, value) in (key, value.count) }
            .sorted { $0.case.displayName < $1.case.displayName }

        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(CaseInputCell.self, forCellWithReuseIdentifier: CaseInputCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc private func closeView() {
        dismiss(animated: true)
    }
}

extension InventoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return grouped.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let (item, count) = grouped[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CaseInputCell.identifier, for: indexPath) as! CaseInputCell
        cell.configure(with: item)
        cell.amountField.text = "\(count)"
        cell.amountField.isUserInteractionEnabled = false
        return cell
    }
}

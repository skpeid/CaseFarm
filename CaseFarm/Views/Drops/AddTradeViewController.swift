import UIKit

class AddTradeViewController: UIViewController {

    private var fromAccount: SteamAccount?
    private var toAccount: SteamAccount?
    private var selectedCaseItem: CaseItem?

    private let fromView = AccountSelectionView()
    private let toView = AccountSelectionView()

    private let arrowLabel: UILabel = {
        let label = UILabel()
        label.text = "→"
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    private let casesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Trade"
        view.backgroundColor = .systemBackground
        setupNav()
        setupViews()
    }

    private func setupNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTrade))
    }

    private func setupViews() {
        fromAccount = DataManager.shared.accounts.first
        toAccount = DataManager.shared.accounts.count > 1 ? DataManager.shared.accounts[1] : nil
        selectedCaseItem = CaseItem.allCases.first

        fromView.translatesAutoresizingMaskIntoConstraints = false
        toView.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        casesCollectionView.translatesAutoresizingMaskIntoConstraints = false

        fromView.configure(with: fromAccount)
        toView.configure(with: toAccount)

        fromView.tag = 1
        toView.tag = 2
        fromView.isUserInteractionEnabled = true
        toView.isUserInteractionEnabled = true

        let tapFrom = UITapGestureRecognizer(target: self, action: #selector(selectAccount(_:)))
        let tapTo = UITapGestureRecognizer(target: self, action: #selector(selectAccount(_:)))
        fromView.addGestureRecognizer(tapFrom)
        toView.addGestureRecognizer(tapTo)

        casesCollectionView.dataSource = self
        casesCollectionView.delegate = self
        casesCollectionView.register(CaseCell.self, forCellWithReuseIdentifier: "CaseCell")

        view.addSubview(casesCollectionView)
        view.addSubview(fromView)
        view.addSubview(arrowLabel)
        view.addSubview(toView)

        NSLayoutConstraint.activate([
            casesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            casesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            casesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            casesCollectionView.heightAnchor.constraint(equalToConstant: 250),

            fromView.topAnchor.constraint(equalTo: casesCollectionView.bottomAnchor, constant: 20),
            fromView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fromView.widthAnchor.constraint(equalToConstant: 100),

            arrowLabel.centerYAnchor.constraint(equalTo: fromView.centerYAnchor),
            arrowLabel.leadingAnchor.constraint(equalTo: fromView.trailingAnchor, constant: 12),
            arrowLabel.trailingAnchor.constraint(equalTo: toView.leadingAnchor, constant: -12),

            toView.topAnchor.constraint(equalTo: fromView.topAnchor),
            toView.widthAnchor.constraint(equalToConstant: 100),
            toView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            toView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }

    @objc private func selectAccount(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }

        let alert = UIAlertController(title: "Choose Account", message: nil, preferredStyle: .actionSheet)
        for account in DataManager.shared.accounts {
            alert.addAction(UIAlertAction(title: account.name, style: .default, handler: { _ in
                if tag == 1 {
                    self.fromAccount = account
                    self.fromView.configure(with: account)
                } else {
                    self.toAccount = account
                    self.toView.configure(with: account)
                }
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func saveTrade() {
        guard let from = fromAccount, let to = toAccount, let caseItem = selectedCaseItem, from.id != to.id else { return }

        let trade = CaseTrade(
            id: UUID(),
            fromAccountID: from.id,
            toAccountID: to.id,
            caseItem: caseItem,
            date: Date()
        )
        DataManager.shared.addTrade(trade)
        navigationController?.popViewController(animated: true)
    }
}

extension AddTradeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CaseItem.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let caseItem = CaseItem.allCases[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CaseCell", for: indexPath) as! CaseCell
        cell.configure(with: caseItem, selected: caseItem == selectedCaseItem)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCaseItem = CaseItem.allCases[indexPath.item]
        collectionView.reloadData()
    }
}

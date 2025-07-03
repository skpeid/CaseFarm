import UIKit

class AddDropViewController: UIViewController {

    private var selectedAccount: SteamAccount?
    private var selectedCaseItem: CaseItem?

    private let accountSelectView = AccountSelectionView()

    private let casesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Drop"
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupViews()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveDrop))
    }

    private func setupViews() {
        selectedAccount = DataManager.shared.accounts.first
        selectedCaseItem = CaseItem.allCases.first

        accountSelectView.translatesAutoresizingMaskIntoConstraints = false
        accountSelectView.isUserInteractionEnabled = true
        accountSelectView.configure(with: selectedAccount)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectAccount))
        accountSelectView.addGestureRecognizer(tapGesture)

        view.addSubview(accountSelectView)

        casesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        casesCollectionView.backgroundColor = .clear
        casesCollectionView.dataSource = self
        casesCollectionView.delegate = self
        casesCollectionView.register(CaseCell.self, forCellWithReuseIdentifier: "CaseCell")
        view.addSubview(casesCollectionView)

        NSLayoutConstraint.activate([
            casesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            casesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            casesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            casesCollectionView.bottomAnchor.constraint(equalTo: accountSelectView.topAnchor, constant: -16),

            accountSelectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            accountSelectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            accountSelectView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            accountSelectView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    @objc private func selectAccount() {
        let alert = UIAlertController(title: "Choose Account", message: nil, preferredStyle: .actionSheet)
        for account in DataManager.shared.accounts {
            alert.addAction(UIAlertAction(title: account.name, style: .default, handler: { _ in
                self.selectedAccount = account
                self.accountSelectView.configure(with: account)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func saveDrop() {
        guard let account = selectedAccount, let caseItem = selectedCaseItem else { return }

        let drop = CaseDrop(
            id: UUID(),
            accountID: account.id,
            caseItem: caseItem,
            date: Date()
        )

        DataManager.shared.addDrop(drop)
        navigationController?.popViewController(animated: true)
    }
}

extension AddDropViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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

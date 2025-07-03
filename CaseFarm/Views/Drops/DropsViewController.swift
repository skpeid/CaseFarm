import UIKit

class DropsViewController: UIViewController {

    private let tableView = UITableView()
    private var combined: [DropOrTrade] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Drops & Trades"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupNavButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DropTradeCell.self, forCellReuseIdentifier: "DropTradeCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupNavButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Trade", style: .plain, target: self, action: #selector(addTrade))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Drop", style: .plain, target: self, action: #selector(addDrop))
    }

    private func reloadData() {
        let drops = DataManager.shared.getAllDrops().map { DropOrTrade.drop($0) }
        let trades = DataManager.shared.getAllTrades().map { DropOrTrade.trade($0) }
        combined = (drops + trades).sorted { $0.date > $1.date }
        tableView.reloadData()
    }

    @objc private func addDrop() {
        let vc = AddDropViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func addTrade() {
        let vc = AddTradeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DropsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return combined.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = combined[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropTradeCell", for: indexPath) as! DropTradeCell
        cell.configure(with: item, accounts: DataManager.shared.accounts)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


// MARK: - Unified View Model Enum

enum DropOrTrade {
    case drop(CaseDrop)
    case trade(CaseTrade)

    var date: Date {
        switch self {
        case .drop(let d): return d.date
        case .trade(let t): return t.date
        }
    }

    var caseItem: CaseItem {
        switch self {
        case .drop(let d): return d.caseItem
        case .trade(let t): return t.caseItem
        }
    }
}


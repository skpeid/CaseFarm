import UIKit

class DropsViewController: UIViewController {

    private let tableView = UITableView()
    private var combined: [DropOrTrade] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Drops & Trades"
        view.backgroundColor = .systemBackground

        setupTableView()
        setupNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    private func setupTableView() {
        tableView.register(DropOrTradeCell.self, forCellReuseIdentifier: "DropOrTradeCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Trade",
            style: .plain,
            target: self,
            action: #selector(addTrade)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Drop",
            style: .plain,
            target: self,
            action: #selector(addDrop)
        )
    }

    @objc private func addTrade() {
        let vc = AddTradeViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }

    @objc private func addDrop() {
        let vc = AddDropViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }

    private func loadData() {
        let allDrops = DataManager.shared.drops.map { DropOrTrade.drop($0) }
        let allTrades = DataManager.shared.trades.map { DropOrTrade.trade($0) }

        combined = (allDrops + allTrades).sorted(by: { $0.date > $1.date })
        tableView.reloadData()
    }
}

extension DropsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return combined.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = combined[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropOrTradeCell", for: indexPath) as! DropOrTradeCell
        cell.configure(with: item, accounts: DataManager.shared.accounts)
        return cell
    }
}

enum DropOrTrade {
    case drop(CaseDrop)
    case trade(CaseTrade)

    var date: Date {
        switch self {
        case .drop(let drop): return drop.date
        case .trade(let trade): return trade.date
        }
    }

    var caseItem: CaseItem {
        switch self {
        case .drop(let drop): return drop.caseItem
        case .trade(let trade): return trade.caseItem
        }
    }
}

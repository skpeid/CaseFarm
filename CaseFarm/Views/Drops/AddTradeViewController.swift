import UIKit

class AddTradeViewController: UIViewController {

    private var fromAccount: SteamAccount?
    private var toAccount: SteamAccount?
    private var selectedCaseItem: CaseItem?

    private let fromPicker = UIPickerView()
    private let toPicker = UIPickerView()
    private let casePicker = UIPickerView()
    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Trade"
        view.backgroundColor = .systemBackground
        setupViews()
    }

    private func setupViews() {
        fromPicker.dataSource = self
        fromPicker.delegate = self
        toPicker.dataSource = self
        toPicker.delegate = self
        casePicker.dataSource = self
        casePicker.delegate = self

        fromPicker.translatesAutoresizingMaskIntoConstraints = false
        toPicker.translatesAutoresizingMaskIntoConstraints = false
        casePicker.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        saveButton.setTitle("Save Trade", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTrade), for: .touchUpInside)

        let label1 = UILabel()
        label1.text = "From Account"
        let label2 = UILabel()
        label2.text = "To Account"
        let label3 = UILabel()
        label3.text = "Case"

        let stack = UIStackView(arrangedSubviews: [
            label1, fromPicker,
            label2, toPicker,
            label3, casePicker,
            saveButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        if let first = DataManager.shared.accounts.first {
            fromAccount = first
            toAccount = first
        }
        selectedCaseItem = CaseItem.allCases.first
    }

    @objc private func saveTrade() {
        guard let from = fromAccount, let to = toAccount, let item = selectedCaseItem else { return }
        guard from.id != to.id else {
            showAlert(title: "Invalid", message: "Cannot trade to same account.")
            return
        }

        let trade = CaseTrade(
            id: UUID(),
            fromAccountID: from.id,
            toAccountID: to.id,
            caseItem: item,
            date: Date()
        )

        DataManager.shared.addTrade(trade)
        navigationController?.popViewController(animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension AddTradeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == fromPicker || pickerView == toPicker {
            return DataManager.shared.accounts.count
        } else {
            return CaseItem.allCases.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == fromPicker || pickerView == toPicker {
            return DataManager.shared.accounts[row].name
        } else {
            return CaseItem.allCases[row].displayName
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == fromPicker {
            fromAccount = DataManager.shared.accounts[row]
        } else if pickerView == toPicker {
            toAccount = DataManager.shared.accounts[row]
        } else {
            selectedCaseItem = CaseItem.allCases[row]
        }
    }
}

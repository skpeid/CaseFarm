import UIKit

class AddDropViewController: UIViewController {

    private var selectedAccount: SteamAccount?
    private var selectedCaseItem: CaseItem?

    private let accountPicker = UIPickerView()
    private let casePicker = UIPickerView()
    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Drop"
        view.backgroundColor = .systemBackground
        setupViews()
    }

    private func setupViews() {
        accountPicker.translatesAutoresizingMaskIntoConstraints = false
        casePicker.translatesAutoresizingMaskIntoConstraints = false
        accountPicker.dataSource = self
        accountPicker.delegate = self
        casePicker.dataSource = self
        casePicker.delegate = self

        saveButton.setTitle("Save Drop", for: .normal)
        saveButton.addTarget(self, action: #selector(saveDrop), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [accountPicker, casePicker, saveButton])
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        if let firstAccount = DataManager.shared.accounts.first {
            selectedAccount = firstAccount
        }
        selectedCaseItem = CaseItem.allCases.first
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

extension AddDropViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == accountPicker {
            return DataManager.shared.accounts.count
        } else {
            return CaseItem.allCases.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == accountPicker {
            return DataManager.shared.accounts[row].name
        } else {
            return CaseItem.allCases[row].displayName
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == accountPicker {
            selectedAccount = DataManager.shared.accounts[row]
        } else {
            selectedCaseItem = CaseItem.allCases[row]
        }
    }
}

// AddAccountViewController.swift
import UIKit

class AddAccountViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    private let nameField = UITextField()
    private let usernameField = UITextField()
    private let profileImageView = UIImageView()
    private let selectImageButton = UIButton(type: .system)
    private let casesGridView = CasesInputGridView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Account"
        view.backgroundColor = .systemBackground

        setupNavigation()
        setupUI()
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveAccount)
        )
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 16
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])

        // Profile image + selector
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .secondarySystemBackground
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        selectImageButton.setTitle("Select Profile Image", for: .normal)
        selectImageButton.addTarget(self, action: #selector(selectProfileImage), for: .touchUpInside)

        let imageStack = UIStackView(arrangedSubviews: [profileImageView, selectImageButton])
        imageStack.axis = .vertical
        imageStack.alignment = .center
        imageStack.spacing = 8

        contentView.addArrangedSubview(imageStack)

        // Name & Username
        nameField.placeholder = "Account Name"
        usernameField.placeholder = "Username"
        [nameField, usernameField].forEach {
            $0.borderStyle = .roundedRect
            contentView.addArrangedSubview($0)
        }

        // Cases grid view
        casesGridView.translatesAutoresizingMaskIntoConstraints = false
        casesGridView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        contentView.addArrangedSubview(casesGridView)
    }

    @objc private func selectProfileImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    @objc private func saveAccount() {
        guard let name = nameField.text, !name.isEmpty,
              let username = usernameField.text, !username.isEmpty else {
            showAlert("Please fill in all required fields.")
            return
        }

        let inventory = casesGridView.getInventory()

        var newAccount = SteamAccount(
            id: UUID(),
            name: name,
            username: username,
            profileImageData: nil,
            inventory: inventory,
            drops: []
        )

        if let image = profileImageView.image {
            newAccount.setProfileImage(image)
        }

        DataManager.shared.addAccount(newAccount)
        navigationController?.popViewController(animated: true)
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Missing Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension AddAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
        }
    }
}

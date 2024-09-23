import UIKit

// MARK: - Presenter Protocol

protocol AddTodoViewInput: AnyObject {
    func showError(_ message: String)
}

// MARK: - View Protocol

protocol AddTodoViewOutput: AnyObject {
    func didTapSaveButton(name: String, description: String?)
    func didTapCancelButton()
}

// MARK: - ViewController

final class AddTodoViewController: UIViewController {
    var presenter: AddTodoViewOutput?

    private let nameTextField = TodoTextView(style: .primary)
    private let descriptionTextView = TodoTextView(style: .secondary)
    private let saveButton = TodoIconButton(.saveTodo)
    private let cancelButton = TodoIconButton(.cancelTodo)

    private enum Constants {
        static let topPadding: CGFloat = 16
        static let sidePadding: CGFloat = 16
        static let textFieldHeight: CGFloat = 84
        static let textViewHeight: CGFloat = 200
        static let buttonHeight: CGFloat = 44
        static let alertTitle = "Validation Error"
        static let alertButtonTitle = "OK"
        static let navigationTitle = "Add New Todo"
        static let namePlaceholder = "Task Name"
        static let descriptionPlaceholder = "Add description"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = ColorPalette.Background.layerOne
        navigationItem.title = Constants.navigationTitle

        nameTextField.placeholder = Constants.namePlaceholder
        descriptionTextView.placeholder = Constants.descriptionPlaceholder

        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(nameTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topPadding),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sidePadding),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sidePadding),
            nameTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            descriptionTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: Constants.topPadding),
            descriptionTextView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: Constants.textViewHeight),

            cancelButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: Constants.topPadding),
            cancelButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            saveButton.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            saveButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
        ])
    }

    @objc private func saveButtonTapped() {
        let name = nameTextField.text ?? ""
        let description = descriptionTextView.text ?? ""
        presenter?.didTapSaveButton(name: name, description: description)
    }

    @objc private func cancelButtonTapped() {
        presenter?.didTapCancelButton()
    }
}

// MARK: - Conformed methods

extension AddTodoViewController: AddTodoViewInput {
    func showError(_ message: String) {
        let alert = UIAlertController(title: Constants.alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.alertButtonTitle, style: .default))
        present(alert, animated: true)
    }
}

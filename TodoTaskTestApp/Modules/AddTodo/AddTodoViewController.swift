import UIKit

protocol AddTodoViewInput: AnyObject {
    func showError(_ message: String)
}

protocol AddTodoViewOutput: AnyObject {
    func didTapSaveButton(name: String, description: String?)
    func didTapCancelButton()
}

final class AddTodoViewController: UIViewController {
    var presenter: AddTodoViewOutput?

    private let nameTextField = TodoTextView(style: .primary)
    private let descriptionTextView = TodoTextView(style: .secondary)
    private let saveButton = TodoIconButton(.saveTodo)
    private let cancelButton = TodoIconButton(.cancelTodo)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = ColorPalette.Background.layerOne
        navigationItem.title = "Add New Todo"

        nameTextField.placeholder = "Task Name"
        descriptionTextView.placeholder = "Add description"

        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(nameTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 84),

            descriptionTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 200),

            cancelButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),

            saveButton.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            saveButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    @objc private func saveButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showError("Task name cannot be empty.")
            return
        }
        let description = descriptionTextView.text ?? ""
        presenter?.didTapSaveButton(name: name, description: description)
    }

    @objc private func cancelButtonTapped() {
        presenter?.didTapCancelButton()
    }
}

extension AddTodoViewController: AddTodoViewInput {
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

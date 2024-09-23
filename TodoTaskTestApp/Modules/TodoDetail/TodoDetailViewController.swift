import UIKit

// MARK: - Presenter Protocol

protocol TodoDetailViewInput: AnyObject {
    func displayTodoDetails(_ todo: Todo)
    func showError(_ message: String)
}

// MARK: - View Protocol

protocol TodoDetailViewOutput: AnyObject {
    func viewDidLoad()
    func didTapSaveButton(todo: Todo)
    func didTapDeleteButton()
}

// MARK: - ViewController

final class TodoDetailViewController: UIViewController {
    var presenter: TodoDetailViewOutput?

    private let nameTextField = TodoTextView(style: .primary)
    private let descriptionTextView = TodoTextView(style: .secondary)
    private let saveButton = TodoIconButton(.saveTodo)
    private let deleteButton = TodoIconButton(.deleteTodo)
    
    private var todo: Todo?

    private enum Constants {
        static let topPadding: CGFloat = 16
        static let sidePadding: CGFloat = 16
        static let textFieldHeight: CGFloat = 84
        static let textViewHeight: CGFloat = 150
        static let buttonHeight: CGFloat = 44
        static let navigationTitle = "Todo Details"
        static let namePlaceholder = "Task Name"
        static let descriptionPlaceholder = "Add description"
        static let alertTitle = "Delete Task"
        static let alertMessage = "Are you sure you want to delete this task?"
        static let cancelActionTitle = "Cancel"
        static let deleteActionTitle = "Delete"
        static let errorAlertTitle = "Error"
        static let errorAlertButtonTitle = "OK"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = ColorPalette.Background.layerOne
        navigationItem.title = Constants.navigationTitle

        nameTextField.placeholder = Constants.namePlaceholder
        descriptionTextView.placeholder = Constants.descriptionPlaceholder

        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(nameTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(saveButton)
        view.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topPadding),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sidePadding),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sidePadding),
            nameTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            descriptionTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: Constants.topPadding),
            descriptionTextView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: Constants.textViewHeight),

            deleteButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: Constants.topPadding),
            deleteButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            saveButton.topAnchor.constraint(equalTo: deleteButton.topAnchor),
            saveButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
        ])
    }

    @objc private func saveButtonTapped() {
        guard let name = nameTextField.text else { return }
        guard var todo = self.todo else { return }
        todo.name = name
        todo.description = descriptionTextView.text
        presenter?.didTapSaveButton(todo: todo)
    }

    @objc private func deleteButtonTapped() {
        let alert = UIAlertController(title: Constants.alertTitle, message: Constants.alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.cancelActionTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: Constants.deleteActionTitle, style: .destructive, handler: { _ in
            self.presenter?.didTapDeleteButton()
        }))
        present(alert, animated: true)
    }
}

// MARK: - Presenter Protocol conformance

extension TodoDetailViewController: TodoDetailViewInput {
    func displayTodoDetails(_ todo: Todo) {
        self.todo = todo
        nameTextField.text = todo.name
        descriptionTextView.text = todo.description
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: Constants.errorAlertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.errorAlertButtonTitle, style: .default))
        present(alert, animated: true)
    }
}

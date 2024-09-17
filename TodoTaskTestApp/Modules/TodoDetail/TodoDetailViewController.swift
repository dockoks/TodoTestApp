import UIKit

protocol TodoDetailViewControllerDelegate: AnyObject {
    func todoDetailViewControllerDidUpdateTodo()
}

protocol TodoDetailViewInput: AnyObject {
    func didUpdateTodo()
    func displayTodoDetails(_ todo: Todo)
    func showError(_ message: String)
}

protocol TodoDetailViewOutput: AnyObject {
    func viewDidLoad()
    func didTapSaveButton(todo: Todo)
    func didTapDeleteButton()
}

class TodoDetailViewController: UIViewController {
    weak var delegate: TodoDetailViewControllerDelegate?
    var presenter: TodoDetailViewOutput?

    private let nameTextField = TodoTextView(style: .primary)
    private let descriptionTextView = TodoTextView(style: .secondary)
    private let saveButton = TodoIconButton(.saveTodo)
    private let deleteButton = TodoIconButton(.deleteTodo)
    
    private var todo: Todo?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = ColorPalette.Background.layerOne
        navigationItem.title = "Todo Details"

        nameTextField.placeholder = "Task Name"
        descriptionTextView.placeholder = "Add description"
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(nameTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(saveButton)
        view.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 84),

            descriptionTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 150),

            deleteButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),

            saveButton.topAnchor.constraint(equalTo: deleteButton.topAnchor),
            saveButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    @objc private func saveButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showError("Task name cannot be empty.")
            return
        }
        guard var todo = self.todo else { return }
        todo.name = name
        todo.description = descriptionTextView.text
        self.todo = todo
        presenter?.didTapSaveButton(todo: todo)
    }

    @objc private func deleteButtonTapped() {
        let alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.presenter?.didTapDeleteButton()
        }))
        present(alert, animated: true)
    }
}

extension TodoDetailViewController: TodoDetailViewInput {
    func didUpdateTodo() {
        delegate?.todoDetailViewControllerDidUpdateTodo()
    }
    
    func displayTodoDetails(_ todo: Todo) {
        self.todo = todo
        nameTextField.text = todo.name
        descriptionTextView.text = todo.description
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

import UIKit

protocol TodoListViewInput: AnyObject {
    var presenter: TodoListPresenterInput? { get set }
    func didUpdateSegmentedCounts(all: Int, open: Int, closed: Int)
    func updateTodos(with todos: [Todo])
    func update(with error: String)
}

final class TodoListViewController: UIViewController, SegmentedControlDelegate {
    var presenter: TodoListPresenterInput?
    
    private let headerLabel = UILabel()
    private let dateLabel = UILabel()
    private let headerSV = UIStackView()
    private let newTodoButton = TodoIconButton(.newTodo)
    private let segmentedControl = SegmentedControl()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.separatorStyle = .none
        tv.backgroundView?.backgroundColor = .clear
        tv.backgroundColor = .clear
        tv.showsVerticalScrollIndicator = false
        tv.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.reuseIdentifier)
        tv.isHidden = true
        return tv
    }()
    
    var todos: [Todo] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.Background.layerOne
        tableView.delegate = self
        tableView.dataSource = self
        setupHeader()
        setupSegmentedControl()
        setupTableView()
        updateDateLabel()
        presenter?.viewDidLoad()
    }
    
    private func setupHeader() {
        headerLabel.text = "Today's task"
        headerLabel.font = TodoFont.Styles.header
        headerLabel.textColor = ColorPalette.Text.primary
        
        dateLabel.text = "Wed 23, 2023"
        dateLabel.font = TodoFont.Styles.subtitle
        dateLabel.textColor = ColorPalette.Text.tertiary
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerSV.addArrangedSubview(headerLabel)
        headerSV.addArrangedSubview(dateLabel)
        headerSV.axis = .vertical
        headerSV.spacing = 4
        headerSV.alignment = .leading
        headerSV.distribution = .fillEqually
        
        headerSV.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerSV)
        view.addSubview(newTodoButton)
        
        newTodoButton.configure(title: "New task", icon: UIImage(systemName: "plus"))
        newTodoButton.addTarget(self, action: #selector(newTodoButtonDidTap), for: .touchUpInside)
        newTodoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerSV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerSV.trailingAnchor.constraint(lessThanOrEqualTo: newTodoButton.leadingAnchor, constant: -8),
            headerSV.heightAnchor.constraint(equalToConstant: 60),
            
            newTodoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newTodoButton.centerYAnchor.constraint(equalTo: headerSV.centerYAnchor),
            newTodoButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupSegmentedControl() {
        segmentedControl.delegate = self
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: headerSV.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func segmentedControl(_ segmentedControl: SegmentedControl, didSelect index: Int) {
        presenter?.didFilterTodos(index: index)
    }
    
    private func updateDateLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, 11 MMMM"
        let currentDate = Date()
        dateLabel.text = formatter.string(from: currentDate)
    }
    
    @objc func newTodoButtonDidTap() {
        presenter?.didTapAddTodo()
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return switch segmentedControl.getSelectedIndex() {
        case 0: todos.count
        case 1: todos.filter { !$0.isCompleted }.count
        case 2: todos.filter { $0.isCompleted }.count
        default: 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.reuseIdentifier, for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        
        cell.onToggleCompletion = { [weak self] toggledTodo in
            guard let self = self else { return }
            if let index = self.todos.firstIndex(where: { $0.id == toggledTodo.id }) {
                self.presenter?.didToggleCompletion(for: self.todos[index])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        presenter?.didTapOpenTodo(todo)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo = todos[indexPath.row]
            presenter?.didDeleteTodo(todo)
        }
    }

}

extension TodoListViewController: TodoListViewInput {
    func didUpdateSegmentedCounts(all: Int, open: Int, closed: Int) {
        DispatchQueue.main.async {
            self.segmentedControl.updateCounts(
                all: all,
                open: open,
                closed: closed
            )
        }
    }
    
    func updateTodos(with todos: [Todo]) {
        DispatchQueue.main.async {
            self.todos = todos
            
            self.segmentedControl.updateCounts(
                all: todos.count,
                open: todos.filter { !$0.isCompleted }.count,
                closed: todos.filter { $0.isCompleted }.count
            )
            self.tableView.isHidden = false
        }
    }
    
    func update(with error: String) {
        // Handle error
    }
}

extension TodoListViewController: TodoDetailViewControllerDelegate {
    func todoDetailViewControllerDidUpdateTodo() {
        presenter?.viewDidLoad()
    }
}

extension TodoListViewController: AddTodoModuleDelegate {
    func didAddNewTodo() {
        presenter?.viewDidLoad()
    }
}

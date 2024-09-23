import UIKit

// MARK: - Presenter Protocol

protocol TodoListViewInput: AnyObject {
    func didUpdateSegmentedCounts(all: Int, open: Int, closed: Int)
    func updateTodos(with todos: [Todo])
    func update(with error: String)
}

// MARK: - ViewController

final class TodoListViewController: UIViewController, SegmentedControlDelegate {
    var presenter: TodoListViewOutpot?
    
    private enum Constants {
        static let topInset: CGFloat = 16
        static let edgeInsets: CGFloat = 16
        static let headerHeight: CGFloat = 60
        static let headerSpacing: CGFloat = 8
        static let verticalInsets: CGFloat = 20
        static let headerButtonSpacing: CGFloat = 8
        static let addTodoButtonHeight: CGFloat = 44
    }
    
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
    
    private var todos: [Todo] = [] {
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
        
        dateLabel.font = TodoFont.Styles.subtitle
        dateLabel.textColor = ColorPalette.Text.tertiary
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerSV.addArrangedSubview(headerLabel)
        headerSV.addArrangedSubview(dateLabel)
        headerSV.axis = .vertical
        headerSV.spacing = Constants.headerSpacing
        headerSV.alignment = .leading
        headerSV.distribution = .fillEqually
        
        headerSV.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerSV)
        view.addSubview(newTodoButton)
        
        newTodoButton.addTarget(self, action: #selector(newTodoButtonDidTap), for: .touchUpInside)
        newTodoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topInset),
            headerSV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edgeInsets),
            headerSV.trailingAnchor.constraint(lessThanOrEqualTo: newTodoButton.leadingAnchor, constant: -Constants.headerButtonSpacing),
            headerSV.heightAnchor.constraint(equalToConstant: Constants.headerHeight),
            
            newTodoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.edgeInsets),
            newTodoButton.centerYAnchor.constraint(equalTo: headerSV.centerYAnchor),
            newTodoButton.heightAnchor.constraint(equalToConstant: Constants.addTodoButtonHeight)
        ])
    }
    
    private func setupSegmentedControl() {
        segmentedControl.delegate = self
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: headerSV.bottomAnchor, constant: Constants.verticalInsets),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edgeInsets),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.edgeInsets)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Constants.verticalInsets),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func segmentedControl(_ segmentedControl: SegmentedControl, didSelect option: FilterOption) {
        presenter?.didFilterTodos(option: option)
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

// MARK: - TableView Delegate & Datasource

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return switch segmentedControl.selectedOption {
        case .all: todos.count
        case .open: todos.filter { !$0.isCompleted }.count
        case .closed: todos.filter { $0.isCompleted }.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.reuseIdentifier, for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        
        cell.onToggleCompletion = { [weak self] toggledTodo in
            guard let self, let index = self.todos.firstIndex(where: { $0.id == toggledTodo.id })
            else { return }
            self.presenter?.didToggleCompletion(for: self.todos[index])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        presenter?.didTapOpenTodo(todo)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo = todos[indexPath.row]
            presenter?.didDeleteTodo(todo)
        }
    }
}

// MARK: - Presenter Protocol conformance

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

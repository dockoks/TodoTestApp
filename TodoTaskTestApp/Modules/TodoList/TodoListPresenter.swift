import Foundation

protocol TodoListViewOutpot: AnyObject {
    func viewDidLoad()
    func didFilterTodos(option: FilterOption)
    func didTapAddTodo()
    func didToggleCompletion(for todo: Todo)
    func didTapOpenTodo(_ todo: Todo)
    func didUpdateTodo(_ todo: Todo)
    func didDeleteTodo(_ todo: Todo)
}

final class TodoListPresenter {
    weak var view: TodoListViewInput?
    let interactor: TodoListInteractorInput
    let router: TodoListRouterInput
    
    private var todos: [Todo] = []
    private var filteredTodos: [Todo] = []
    private var option: FilterOption = .all
    
    init(
        view: TodoListViewInput? = nil,
        interactor: TodoListInteractorInput,
        router: TodoListRouterInput
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension TodoListPresenter: TodoListViewOutpot {
    func didFilterTodos(option: FilterOption) {
        self.option = option
        switch option {
        case .all: filteredTodos = todos
        case .open: filteredTodos = todos.filter{ !$0.isCompleted }
        case .closed: filteredTodos = todos.filter{ $0.isCompleted }
        }
        view?.updateTodos(with: filteredTodos)
        view?.didUpdateSegmentedCounts(
            all: todos.count,
            open: todos.filter{ !$0.isCompleted }.count,
            closed: todos.filter{ $0.isCompleted }.count
        )
    }
    
    func viewDidLoad() {
        interactor.loadInitialDataIfNeeded()
    }
    
    func didTapAddTodo() {
        router.navigateToAddTodo()
    }
    
    func didSelectTodo(_ todo: Todo) {
        router.navigateToTodoDetail(with: todo)
    }
    
    func didToggleCompletion(for todo: Todo) {
        var updatedTodo = todo
        updatedTodo.isCompleted.toggle()
        interactor.updateTodo(updatedTodo)
    }
    
    func didTapOpenTodo(_ todo: Todo) {
        router.navigateToTodoDetail(with: todo)
    }
    
    func didUpdateTodo(_ todo: Todo) {
        interactor.updateTodo(todo)
    }

    func didDeleteTodo(_ todo: Todo) {
        interactor.deleteTodo(todo)
    }
}

extension TodoListPresenter: TodoListInteractorOutput {
    func didAddNewTodo() {
        interactor.fetchTodos()
    }
    
    func didLoadInitialData() {
        interactor.fetchTodos()
    }
    
    func didFailToLoadInitialData(_ error: any Error) {
        view?.update(with: error.localizedDescription)
    }
    
    func didFetchTodos(_ todos: [Todo]) {
        self.todos = todos
        didFilterTodos(option: option)
    }
    
    func didFailToFetchTodos(_ error: Error) {
        view?.update(with: error.localizedDescription)
    }
    
    func didAddTodo() {
        interactor.fetchTodos()
    }
    
    func didFailToAddTodo(_ error: Error) {
        view?.update(with: error.localizedDescription)
    }
    
    func didUpdateTodo() {
        interactor.fetchTodos()
    }
    
    func didFailToUpdateTodo(_ error: Error) {
        view?.update(with: error.localizedDescription)
    }
    
    func didDeleteTodo() {
        interactor.fetchTodos()
    }
    
    func didFailToDeleteTodo(_ error: Error) {
        view?.update(with: error.localizedDescription)
    }
}

extension TodoListPresenter: AddTodoModuleDelegate { }

extension TodoListPresenter: TodoDetailModuleDelegate { }

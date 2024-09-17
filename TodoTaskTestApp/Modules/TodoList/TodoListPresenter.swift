import Foundation

protocol TodoListPresenterInput: AnyObject {
    func viewDidLoad()
    func didFilterTodos(index: Int)
    func didTapAddTodo()
    func didToggleCompletion(for todo: Todo)
    func didTapOpenTodo(_ todo: Todo)
    func didUpdateTodo(_ todo: Todo)
    func didDeleteTodo(_ todo: Todo)
}

final class TodoListPresenter {
    weak var view: TodoListViewInput?
    var interactor: TodoListInteractorInput?
    var router: TodoListRouterInput?
    
    private var todos: [Todo] = []
    private var filteredTodos: [Todo] = []
    private var index: Int = 0
    
    init() {}
}

extension TodoListPresenter: TodoListPresenterInput {
    func didFilterTodos(index: Int) {
        self.index = index
        switch self.index {
        case 0: filteredTodos = todos
        case 1: filteredTodos = todos.filter{ !$0.isCompleted }
        case 2: filteredTodos = todos.filter{ $0.isCompleted }
        default: break
        }
        view?.updateTodos(with: filteredTodos)
        view?.didUpdateSegmentedCounts(
            all: todos.count,
            open: todos.filter{ !$0.isCompleted }.count,
            closed: todos.filter{ $0.isCompleted }.count
        )
    }
    
    func viewDidLoad() {
        interactor?.loadInitialDataIfNeeded()
    }
    
    func didTapAddTodo() {
        router?.navigateToAddTodo()
    }
    
    func didSelectTodo(_ todo: Todo) {
        router?.navigateToTodoDetail(with: todo)
    }
    
    func didToggleCompletion(for todo: Todo) {
        var updatedTodo = todo
        updatedTodo.isCompleted.toggle()
        interactor?.updateTodo(updatedTodo)
    }
    
    func didTapOpenTodo(_ todo: Todo) {
        router?.navigateToTodoDetail(with: todo)
    }
    
    func didUpdateTodo(_ todo: Todo) {
        interactor?.updateTodo(todo)
    }

    func didDeleteTodo(_ todo: Todo) {
        interactor?.deleteTodo(todo)
    }
}

extension TodoListPresenter: TodoListInteractorOutput {
    func didLoadInitialData() {
        interactor?.fetchTodos()
    }
    
    func didFailToLoadInitialData(_ error: any Error) {
        view?.update(with: error.localizedDescription)
    }
    
    func didFetchTodos(_ todos: [Todo]) {
        self.todos = todos
        didFilterTodos(index: index)
        
    }
    
    func didFailToFetchTodos(_ error: Error) {
        view?.update(with: error.localizedDescription)
    }
    
    func didAddTodo() {
        interactor?.fetchTodos()
    }
    
    func didFailToAddTodo(_ error: Error) {
        view?.update(with: error.localizedDescription)
    }
    
    func didUpdateTodo() {
        interactor?.fetchTodos()
    }
    
    func didFailToUpdateTodo(_ error: Error) {
        view?.update(with: error.localizedDescription)
    }
    
    func didDeleteTodo() {
        interactor?.fetchTodos()
    }
    
    func didFailToDeleteTodo(_ error: Error) {
        view?.update(with: error.localizedDescription)
    }
}

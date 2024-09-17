import Foundation

protocol TodoListInteractorInput: AnyObject {
    func loadInitialDataIfNeeded()
    func fetchTodos()
    func addTodo(_ todo: Todo)
    func updateTodo(_ todo: Todo)
    func deleteTodo(_ todo: Todo)
}

protocol TodoListInteractorOutput: AnyObject {
    func didLoadInitialData()
    func didFailToLoadInitialData(_ error: Error)
    func didFetchTodos(_ todos: [Todo])
    func didFailToFetchTodos(_ error: Error)
    func didAddTodo()
    func didFailToAddTodo(_ error: Error)
    func didUpdateTodo()
    func didFailToUpdateTodo(_ error: Error)
    func didDeleteTodo()
    func didFailToDeleteTodo(_ error: Error)
}

final class TodoListInteractor: TodoListInteractorInput {
    weak var output: TodoListInteractorOutput?
    private let todoService: TodoServiceProtocol
    
    init(todoService: TodoServiceProtocol) {
        self.todoService = todoService
    }
    
    func loadInitialDataIfNeeded() {
        todoService.loadInitialDataIfNeeded { [weak self] result in
            switch result {
            case .success():
                self?.output?.didLoadInitialData()
            case .failure(let error):
                self?.output?.didFailToLoadInitialData(error)
            }
        }
    }
    
    func fetchTodos() {
        todoService.fetchTodos { [weak self] result in
            switch result {
            case .success(let todos):
                self?.output?.didFetchTodos(todos)
            case .failure(let error):
                self?.output?.didFailToFetchTodos(error)
            }
        }
    }
    
    func addTodo(_ todo: Todo) {
        todoService.addTodo(todo) { [weak self] result in
            switch result {
            case .success():
                self?.output?.didAddTodo()
            case .failure(let error):
                self?.output?.didFailToAddTodo(error)
            }
        }
    }
    
    func updateTodo(_ todo: Todo) {
        todoService.updateTodo(todo) { [weak self] result in
            switch result {
            case .success():
                self?.output?.didUpdateTodo()
            case .failure(let error):
                self?.output?.didFailToUpdateTodo(error)
                
            }
        }
    }
    
    func deleteTodo(_ todo: Todo) {
        todoService.deleteTodo(todo) { [weak self] result in
            switch result {
            case .success():
                self?.output?.didDeleteTodo()
            case .failure(let error):
                self?.output?.didFailToDeleteTodo(error)
            }
        }
    }
}

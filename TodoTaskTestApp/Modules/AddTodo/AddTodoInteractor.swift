import Foundation

protocol AddTodoInteractorInput: AnyObject {
    func addTodo(_ todo: Todo)
}

protocol AddTodoInteractorOutput: AnyObject {
    func didAddTodoSuccessfully()
    func didFailToAddTodoWithError(_ error: Error)
}

final class AddTodoInteractor: AddTodoInteractorInput {
    weak var output: AddTodoInteractorOutput?
    private let todoService: TodoServiceProtocol

    init(todoService: TodoServiceProtocol) {
        self.todoService = todoService
    }

    func addTodo(_ todo: Todo) {
        todoService.addTodo(todo) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.output?.didAddTodoSuccessfully()
            case .failure(let error):
                self.output?.didFailToAddTodoWithError(error)
            }
        }
    }
}

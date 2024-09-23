import Foundation

// MARK: - TodoDetailModuleDelegate

protocol TodoDetailModuleDelegate: AnyObject {
    func didUpdateTodo()
}

// MARK: - TodoDetailPresenter

final class TodoDetailPresenter {
    weak var view: TodoDetailViewInput?
    weak var delegate: TodoDetailModuleDelegate?
    let interactor: TodoDetailInteractorInput
    let router: TodoDetailRouterInput
    
    private enum Constants {
        static let emptyTaskNameError = "Task name cannot be empty."
    }
    
    init(
        view: TodoDetailViewInput? = nil,
        interactor: TodoDetailInteractorInput,
        router: TodoDetailRouterInput,
        delegate: TodoDetailModuleDelegate? = nil
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.delegate = delegate
    }
}

// MARK: - TodoDetailViewOutput

extension TodoDetailPresenter: TodoDetailViewOutput {
    func viewDidLoad() {
        interactor.fetchTodoDetails()
    }
    
    func didTapSaveButton(todo: Todo) {
        guard !todo.name.isEmpty else {
            view?.showError(Constants.emptyTaskNameError)
            return
        }
        interactor.updateTodo(todo)
    }
    
    func didTapDeleteButton() {
        interactor.deleteTodo()
    }
}

// MARK: - TodoDetailInteractorOutput

extension TodoDetailPresenter: TodoDetailInteractorOutput {
    func didFetchTodoDetails(_ todo: Todo) {
        view?.displayTodoDetails(todo)
    }

    func didFailToFetchTodoDetails(_ error: Error) {
        view?.showError(error.localizedDescription)
    }

    func didUpdateTodoSuccessfully() {
        delegate?.didUpdateTodo()
        DispatchQueue.main.async {
            self.router.navigateBack()
        }
    }

    func didFailToUpdateTodoWithError(_ error: Error) {
        view?.showError(error.localizedDescription)
    }

    func didDeleteTodoSuccessfully() {
        router.navigateBack()
    }

    func didFailToDeleteTodoWithError(_ error: Error) {
        view?.showError(error.localizedDescription)
    }
}

import Foundation

protocol AddTodoPresenterInput: AddTodoViewOutput, AddTodoInteractorOutput {}

protocol AddTodoModuleDelegate: AnyObject {
    func didAddNewTodo()
}

final class AddTodoPresenter: AddTodoPresenterInput {
    weak var view: AddTodoViewInput?
    weak var delegate: AddTodoModuleDelegate?
    let interactor: AddTodoInteractorInput
    let router: AddTodoRouterInput

    // MARK: - Constants
    private enum Constants {
        static let emptyTaskNameError = "Task name cannot be empty."
    }
    
    init(
        view: AddTodoViewInput? = nil,
        interactor: AddTodoInteractorInput,
        router: AddTodoRouterInput,
        delegate: AddTodoModuleDelegate? = nil
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.delegate = delegate
    }

    // MARK: - View Output

    func didTapSaveButton(name: String, description: String?) {
        guard !name.isEmpty else {
            view?.showError(Constants.emptyTaskNameError)
            return
        }
        
        let newTodo = Todo(
            name: name,
            description: description
        )
        interactor.addTodo(newTodo)
    }

    func didTapCancelButton() {
        router.dismiss()
    }

    // MARK: - Interactor Output

    func didAddTodoSuccessfully() {
        delegate?.didAddNewTodo()
        router.dismiss()
    }

    func didFailToAddTodoWithError(_ error: Error) {
        view?.showError(error.localizedDescription)
    }
}

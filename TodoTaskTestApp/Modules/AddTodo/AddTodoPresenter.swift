import Foundation

protocol AddTodoPresenterInput: AddTodoViewOutput, AddTodoInteractorOutput {}

protocol AddTodoModuleDelegate: AnyObject {
    func didAddNewTodo()
}

final class AddTodoPresenter: AddTodoPresenterInput {
    weak var view: AddTodoViewInput?
    var interactor: AddTodoInteractorInput?
    var router: AddTodoRouterInput?
    weak var delegate: AddTodoModuleDelegate?

    // MARK: - View Output

    func didTapSaveButton(name: String, description: String?) {
        let newTodo = Todo(
            name: name,
            description: description
        )
        interactor?.addTodo(newTodo)
    }

    func didTapCancelButton() {
        router?.dismiss()
    }

    // MARK: - Interactor Output

    func didAddTodoSuccessfully() {
        delegate?.didAddNewTodo()
        router?.dismiss()
    }

    func didFailToAddTodoWithError(_ error: Error) {
        view?.showError(error.localizedDescription)
    }
}

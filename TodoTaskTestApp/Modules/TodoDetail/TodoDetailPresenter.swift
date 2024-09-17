//
//  TodoModuleBuilder.swift
//  TodoTaskTestApp
//
//  Created by Danila Kokin on 13/9/24.
//

import Foundation

protocol TodoDetailPresenterInput: TodoDetailViewOutput, TodoDetailInteractorOutput {}


class TodoDetailPresenter: TodoDetailPresenterInput {
    weak var view: TodoDetailViewInput?
    var interactor: TodoDetailInteractorInput?
    var router: TodoDetailRouterInput?

    // MARK: - View Output

    func viewDidLoad() {
        interactor?.fetchTodoDetails()
    }

    func didTapSaveButton(todo: Todo) {
        interactor?.updateTodo(todo)
    }

    func didTapDeleteButton() {
        interactor?.deleteTodo()
    }

    // MARK: - Interactor Output

    func didFetchTodoDetails(_ todo: Todo) {
        view?.displayTodoDetails(todo)
    }

    func didFailToFetchTodoDetails(_ error: Error) {
        view?.showError(error.localizedDescription)
    }

    func didUpdateTodoSuccessfully() {
        DispatchQueue.main.async {
            self.view?.didUpdateTodo()
            self.router?.navigateBack()
        }
    }

    func didFailToUpdateTodoWithError(_ error: Error) {
        view?.showError(error.localizedDescription)
    }

    func didDeleteTodoSuccessfully() {
        router?.navigateBack()
    }

    func didFailToDeleteTodoWithError(_ error: Error) {
        view?.showError(error.localizedDescription)
    }
}


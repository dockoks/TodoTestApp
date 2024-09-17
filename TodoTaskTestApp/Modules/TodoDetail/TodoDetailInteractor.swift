//
//  TodoModuleBuilder.swift
//  TodoTaskTestApp
//
//  Created by Danila Kokin on 13/9/24.
//

import Foundation

protocol TodoDetailInteractorInput: AnyObject {
    func fetchTodoDetails()
    func updateTodo(_ todo: Todo)
    func deleteTodo()
}

protocol TodoDetailInteractorOutput: AnyObject {
    func didFetchTodoDetails(_ todo: Todo)
    func didFailToFetchTodoDetails(_ error: Error)
    func didUpdateTodoSuccessfully()
    func didFailToUpdateTodoWithError(_ error: Error)
    func didDeleteTodoSuccessfully()
    func didFailToDeleteTodoWithError(_ error: Error)
}

class TodoDetailInteractor: TodoDetailInteractorInput {
    weak var output: TodoDetailInteractorOutput?
    private let todoService: TodoServiceProtocol
    private var todo: Todo

    init(todoService: TodoServiceProtocol, todo: Todo) {
        self.todoService = todoService
        self.todo = todo
    }

    func fetchTodoDetails() {
        output?.didFetchTodoDetails(todo)
    }

    func updateTodo(_ todo: Todo) {
        todoService.updateTodo(todo) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.output?.didUpdateTodoSuccessfully()
            case .failure(let error):
                self.output?.didFailToUpdateTodoWithError(error)
            }
        }
        
    }

    func deleteTodo() {
        todoService.deleteTodo(todo) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.output?.didDeleteTodoSuccessfully()
            case .failure(let error):
                self.output?.didFailToDeleteTodoWithError(error)
            }
        }
    }
}

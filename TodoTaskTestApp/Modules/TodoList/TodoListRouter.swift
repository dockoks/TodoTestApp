import UIKit

protocol TodoListRouterInput: AnyObject {
    func navigateToAddTodo()
    func navigateToTodoDetail(with todo: Todo)
}

final class TodoListRouter: TodoListRouterInput {
    weak var presenter: TodoListPresenter?
    
    init(presenter: TodoListPresenter? = nil) {
        self.presenter = presenter
    }
    
    func navigateToAddTodo() {
        guard let viewController = presenter?.view as? TodoListViewController,
              let delegate = presenter
        else { return }
        let addTodoViewController = AddTodoModuleBuilder.build(delegate: delegate)
        viewController.present(addTodoViewController, animated: true)
    }
    
    func navigateToTodoDetail(with todo: Todo) {
        guard let viewController = presenter?.view as? TodoListViewController,
              let delegate = presenter
        else { return }
        
        let todoDetailViewController = TodoDetailModuleBuilder.build(with: todo, delegate: delegate)
        viewController.present(todoDetailViewController, animated: true)
    }
}


import UIKit

protocol TodoListRouterInput: AnyObject {
    func navigateToAddTodo()
    func navigateToTodoDetail(with todo: Todo)
}

final class TodoListRouter: TodoListRouterInput {
    weak var viewController: UIViewController?
    
    func navigateToAddTodo() {
        guard let viewController = viewController as? TodoListViewController else { return }
        let addTodoViewController = AddTodoModuleBuilder.build(delegate: viewController)
        let navigationController = UINavigationController(rootViewController: addTodoViewController)
        viewController.present(navigationController, animated: true)
    }
    
    func navigateToTodoDetail(with todo: Todo) {
        let todoDetailViewController = TodoDetailModuleBuilder.build(with: todo)
        todoDetailViewController.delegate = viewController as? TodoDetailViewControllerDelegate
        viewController?.present(todoDetailViewController, animated: true)
    }
}


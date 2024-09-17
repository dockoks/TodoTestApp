import UIKit

typealias EntryPoint = TodoListViewInput & UIViewController

final class TodoListModuleBuilder {
    static func build() -> UIViewController {
        let view = TodoListViewController()
        let presenter = TodoListPresenter()
        let interactor = TodoListInteractor(todoService: TodoService.shared)
        let router = TodoListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

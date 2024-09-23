import UIKit

typealias EntryPoint = TodoListViewInput & UIViewController

final class TodoListModuleBuilder {
    static func build() -> UIViewController {
        let view = TodoListViewController()
        let interactor = TodoListInteractor(todoService: TodoService.shared)
        let router = TodoListRouter()
        
        let presenter = TodoListPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.presenter = presenter
        interactor.output = presenter
        router.presenter = presenter
        
        return view
    }
}

import UIKit

final class TodoDetailModuleBuilder {
    static func build(with todo: Todo, delegate: TodoDetailModuleDelegate) -> TodoDetailViewController {
        let view = TodoDetailViewController()
        let interactor = TodoDetailInteractor(todoService: TodoService.shared, todo: todo)
        let router = TodoDetailRouter(viewController: view)

        let presenter = TodoDetailPresenter(
            view: view,
            interactor: interactor,
            router: router,
            delegate: delegate
        )
        
        view.presenter = presenter
        interactor.output = presenter

        return view
    }
}



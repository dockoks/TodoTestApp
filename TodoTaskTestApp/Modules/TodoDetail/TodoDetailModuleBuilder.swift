import UIKit

final class TodoDetailModuleBuilder {
    static func build(with todo: Todo) -> TodoDetailViewController {
        let view = TodoDetailViewController()
        let presenter = TodoDetailPresenter()
        let interactor = TodoDetailInteractor(todoService: TodoService.shared, todo: todo)
        let router = TodoDetailRouter(viewController: view)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view

        return view
    }
}



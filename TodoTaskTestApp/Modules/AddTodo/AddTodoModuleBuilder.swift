import UIKit

final class AddTodoModuleBuilder {
    static func build(delegate: AddTodoModuleDelegate?) -> UIViewController {
        let view = AddTodoViewController()
        let presenter = AddTodoPresenter()
        let interactor = AddTodoInteractor(todoService: TodoService.shared)
        let router = AddTodoRouter(viewController: view)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.delegate = delegate
        interactor.output = presenter

        return view
    }
}

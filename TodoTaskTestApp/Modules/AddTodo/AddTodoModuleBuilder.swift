import UIKit

final class AddTodoModuleBuilder {
    static func build(delegate: AddTodoModuleDelegate?) -> UIViewController {
        let view = AddTodoViewController()
        let interactor = AddTodoInteractor(todoService: TodoService.shared)
        let router = AddTodoRouter(viewController: view)
        
        let presenter = AddTodoPresenter(
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

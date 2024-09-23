import UIKit

// MARK: - TodoDetailRouterInput

protocol TodoDetailRouterInput: AnyObject {
    func navigateBack()
}

// MARK: - TodoDetailRouter

final class TodoDetailRouter: TodoDetailRouterInput {
    weak var viewController: UIViewController?

    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    func navigateBack() {
        viewController?.dismiss(animated: true)
    }
}


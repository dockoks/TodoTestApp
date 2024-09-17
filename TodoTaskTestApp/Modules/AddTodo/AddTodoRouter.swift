import UIKit

protocol AddTodoRouterInput: AnyObject {
    func dismiss()
}

final class AddTodoRouter: AddTodoRouterInput {
    weak var viewController: UIViewController?

    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}

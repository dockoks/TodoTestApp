//
//  TodoModuleBuilder.swift
//  TodoTaskTestApp
//
//  Created by Danila Kokin on 13/9/24.
//

import UIKit

protocol TodoDetailRouterInput: AnyObject {
    func navigateBack()
}

class TodoDetailRouter: TodoDetailRouterInput {
    weak var viewController: UIViewController?

    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    func navigateBack() {
        viewController?.dismiss(animated: true)
    }
}


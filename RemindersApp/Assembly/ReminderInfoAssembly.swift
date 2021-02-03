//
//  ReminderInfoAssembly.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/24/21.
//

import UIKit

enum ReminderInfoAssembly {
    static func createVC(reminder: Reminder) -> UINavigationController {
        let router = ReminderInfoRouter()
        let interactor = ReminderInfoInteractor(reminder: reminder)
        let presenter = ReminderInfoPresenter(router: router,
                                              interactor: interactor)
        let viewController = ReminderInfoViewController(presenter: presenter)

        router.vc = viewController
        interactor.presenter = presenter

        let navController = UINavigationController(rootViewController: viewController)
        return navController
    }
}

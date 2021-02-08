//
//  ReminderInfoAssembly.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/24/21.
//

import UIKit

enum ReminderInfoAssembly {
    static func createVC(delegate: IReminderListInteractorDelegate, reminder: Reminder, reminderIndex: Int) -> UINavigationController {
        let router = ReminderInfoRouter()
        let interactor = ReminderInfoInteractor(delegate: delegate,
                                                reminder: reminder,
                                                reminderIndex: reminderIndex)
        let presenter = ReminderInfoPresenter(router: router,
                                              interactor: interactor)
        let viewController = ReminderInfoViewController(presenter: presenter)

        router.vc = viewController
        interactor.presenter = presenter
        router.presenter = presenter

        let navController = UINavigationController(rootViewController: viewController)
        return navController
    }
}

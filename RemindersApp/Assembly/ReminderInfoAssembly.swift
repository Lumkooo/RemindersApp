//
//  ReminderInfoAssembly.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/24/21.
//

import UIKit

enum ReminderInfoAssembly {
    static func createVC(reminder: Reminder) -> UIViewController {
        let router = ReminderInfoRouter()
        let interactor = ReminderInfoInteractor(reminder: reminder)
        let presenter = ReminderInfoPresenter(router: router,
                                              interactor: interactor)
        let viewController = ReminderInfoViewController(presenter: presenter)

        router.vc = viewController
        interactor.presenter = presenter
        router.presenter = presenter

        return viewController
    }
}

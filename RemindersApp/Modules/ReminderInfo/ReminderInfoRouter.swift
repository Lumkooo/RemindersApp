//
//  ReminderInfoRouter.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/24/21.
//

import UIKit

protocol IReminderInfoRouter {
    func showCancelAlert()
    func dismissVC()
}


final class ReminderInfoRouter {
    weak var vc: UIViewController?
}

// MARK: - IReminderInfoRouter

extension ReminderInfoRouter: IReminderInfoRouter {
    func showCancelAlert() {
        let alert = UIAlertController(title: "Уведомление",
                                      message: "Вы хотите выйти и не сохранить заметку?",
                                      preferredStyle: .alert)
        let dismissVCAction = UIAlertAction(title: "Да, выйти",
                                            style: .cancel) { (action) in
            self.dismissVC()
        }
        let stayOnVCAction = UIAlertAction(title: "Нет, остаться на экране", style: .default)
        alert.addAction(dismissVCAction)
        alert.addAction(stayOnVCAction)
        self.vc?.present(alert,
                         animated: true)
    }

    func dismissVC() {
        self.vc?.dismiss(animated: true)
    }
}

//
//  RemindersListRouter.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

protocol IRemindersListRouter {
    func showDetailInfo(forReminder reminder: Reminder)
}

final class RemindersListRouter {
    weak var vc: UIViewController?
}

// MARK: - IRemindersListRouter

extension RemindersListRouter: IRemindersListRouter {
    func showDetailInfo(forReminder reminder: Reminder) {
        let vc = ReminderInfoAssembly.createVC(reminder: reminder)
        self.vc?.navigationController?.present(vc, animated: true)
    }
}

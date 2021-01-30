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
        let reminderInfoVC = ReminderInfoAssembly.createVC(reminder: reminder)
        self.vc?.navigationController?.pushViewController(reminderInfoVC, animated: true)
    }
}

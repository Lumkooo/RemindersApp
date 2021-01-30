//
//  ReminderInfoRouter.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/24/21.
//

import UIKit

protocol IReminderInfoRouter {
    func goToCalendar()
}

protocol IReminderInfoRouterOuter: AnyObject {
    func setDate(date: Date)
}

final class ReminderInfoRouter {
    weak var vc: UIViewController?
    weak var presenter: IReminderInfoRouterOuter?
}

// MARK: - IReminderInfoRouter

extension ReminderInfoRouter: IReminderInfoRouter {
    func goToCalendar() {
        let viewController = CalendarAssembly.createVC(selectedDateChanged: { [weak self] date in
            guard let self = self else { return }
            
            self.presenter?.setDate(date: date)
            //            self.item.date = date
            //            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
        })
        self.vc?.navigationController?.present(viewController, animated: true)
    }
}

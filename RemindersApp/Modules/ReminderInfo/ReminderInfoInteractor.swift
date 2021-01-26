//
//  ReminderInfoInteractor.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/24/21.
//

import Foundation

protocol IReminderInfoInteractor {
    func loadInitData()
    func textViewDidChange(indexPath: IndexPath, text: String)
    func switchValueDidChange(indexPath: IndexPath, value: Bool)
}

protocol IReminderInfoInteractorOuter: AnyObject {
    func prepareViewFor(reminder: Reminder)
    func showCalendar()
    func hideCalendar()
}

final class ReminderInfoInteractor {

    // MARK: - Properties

    weak var presenter: IReminderInfoInteractorOuter?
    private var reminder: Reminder

    // MARK: - Init

    init(reminder: Reminder) {
        self.reminder = reminder
    }
}

// MARK: - IReminderInfoInteractor

extension ReminderInfoInteractor: IReminderInfoInteractor {
    func loadInitData() {
        self.reloadViewPresentation()
    }

    func textViewDidChange(indexPath: IndexPath, text: String) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.reminder.text = text
            case 1:
                self.reminder.note = text
            case 2:
                self.reminder.url = text
            default:
                assertionFailure("something went wrong")
                break
            }
            self.reloadViewPresentation()
        }
    }

    func switchValueDidChange(indexPath: IndexPath, value: Bool) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if value {
                    self.presenter?.showCalendar()
                } else {
                    self.presenter?.hideCalendar()
                }
            } else if indexPath.row == 1 {
                // Время
            }
        } else if indexPath.section == 2 {
            // Местоположение
        } else if indexPath.section == 3 {
            // Сообщения
        } else if indexPath.section == 4 {
            self.reminder.flag = value
        }
        self.reloadViewPresentation()
    }
}

private extension ReminderInfoInteractor {
    func reloadViewPresentation() {
        self.presenter?.prepareViewFor(reminder: reminder)
    }
}

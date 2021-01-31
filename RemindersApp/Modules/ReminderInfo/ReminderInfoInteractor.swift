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
    func dateChanged(date: Date)
    func timeChanged(time: Date)
    func saveReminder()
}

protocol IReminderInfoInteractorOuter: AnyObject {
    func prepareViewFor(reminder: Reminder)
    func reloadViewFor(reminder: Reminder)
    func showCalendarInfo()
    func hideCalendarInfo()
    func showTime()
    func hideTime()
}

final class ReminderInfoInteractor {

    // MARK: - Properties

    weak var presenter: IReminderInfoInteractorOuter?
    private var reminder: Reminder
    private var dayMonthsAndYears: DateComponents = DateComponents()
    // Изначально ставим на 8:00. Поэтому если пользователь не выберет
    // время, то напоминание будет установлено на 8:00
    private var hoursAndMinutes: DateComponents = DateComponents(calendar: .autoupdatingCurrent,
                                                                 timeZone: .autoupdatingCurrent,
                                                                 hour: 8,
                                                                 minute: 0)
    private var isDateIncluded: Bool = false

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
            self.isDateIncluded = value
            if indexPath.row == 0 {
                if value {
                    self.presenter?.showCalendarInfo()
                } else {
                    self.presenter?.hideCalendarInfo()
                }
            } else if indexPath.row == 1 {
                if value {
                    self.presenter?.showTime()
                } else {
                    self.presenter?.hideTime()
                }
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

    func dateChanged(date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        self.dayMonthsAndYears = components
    }

    func timeChanged(time: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        self.hoursAndMinutes = components
    }

    func saveReminder() {
        if self.isDateIncluded {
            let dateAndTime = self.getDateAndTime()
            print("Date and Time", dateAndTime)
            self.reminder.date = dateAndTime
        }
        print("saved", reminder)
    }
}

private extension ReminderInfoInteractor {
    func reloadViewPresentation() {
        self.presenter?.prepareViewFor(reminder: reminder)
    }

    func getDateAndTime() -> Date? {
        let calendar = Calendar.current
        if self.dayMonthsAndYears.year ?? 0 <= 1 {
            // Для того, чтобы выбрать дату, соответствующую сегодня
            // если пользователь не выбрал конкретную дату, но выбрал swifch календаря
            let date = Date()
            self.dateChanged(date: date)
        }
        let components = DateComponents(calendar: .autoupdatingCurrent,
                                        timeZone: .autoupdatingCurrent,
                                        year: self.dayMonthsAndYears.year,
                                        month: self.dayMonthsAndYears.month,
                                        day: self.dayMonthsAndYears.day,
                                        hour: self.hoursAndMinutes.hour,
                                        minute: self.hoursAndMinutes.minute)
        let dateAndTime = calendar.date(from: components)
        return dateAndTime
    }
}

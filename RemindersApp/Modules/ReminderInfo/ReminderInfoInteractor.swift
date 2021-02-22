//
//  ReminderInfoInteractor.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/24/21.
//

import Foundation
import MapKit

protocol IReminderInfoInteractor {
    func loadInitData()
    func textViewDidChange(indexPath: IndexPath, text: String)
    func switchValueDidChange(indexPath: IndexPath, value: Bool)
    func dateChanged(date: Date)
    func timeChanged(time: Date)
    func saveReminder()
    func userCurrentLocationChosen()
    func getInCarLocationChosen()
    func getOutCarLocationChosen()
    func prepareForPriorityVC()
    func imageFromImagePicker(image: UIImage, url: URL)
    func deleteImage(atIndex index: Int)
}

protocol IReminderInfoInteractorOuter: AnyObject {
    func prepareViewFor(reminder: Reminder)
    func reloadViewFor(reminder: Reminder)
    func showCalendarInfo()
    func hideCalendarInfo()
    func showTime()
    func hideTime()
    func showLocation()
    func hideLocation()
    func setupViewForUsersCurrentLocation(stringLocation: String)
    func setupViewForGetInCarLocation()
    func setupViewForGetOutCarLocation()
    func goToPriorityVC(currentPriority: Priority, delegate: IPriorityDelegate)
    func dismissVC()
}

protocol IPriorityDelegate {
    func priorityChanged(newPriority: Priority)
}

final class ReminderInfoInteractor {

    // MARK: - Properties

    weak var presenter: IReminderInfoInteractorOuter?
    private var reminder: Reminder
    private var reminderIndex: Int
    private var delegate: IReminderListInteractorDelegate
    private var dayMonthsAndYears: DateComponents = DateComponents()
    // Изначально ставим на 8:00. Поэтому если пользователь не выберет
    // время, то напоминание будет установлено на 8:00
    private var hoursAndMinutes: DateComponents = DateComponents(calendar: .autoupdatingCurrent,
                                                                 timeZone: .autoupdatingCurrent,
                                                                 hour: 8,
                                                                 minute: 0)
    private var isDateIncluded: Bool = false
    //Для уведомлений
    private var appDelegate = UIApplication.shared.delegate as? AppDelegate

    // MARK: - Init

    init(delegate: IReminderListInteractorDelegate,
         reminder: Reminder,
         reminderIndex: Int) {
        self.delegate = delegate
        self.reminder = reminder
        self.reminderIndex = reminderIndex
    }
}

// MARK: - IReminderInfoInteractor

extension ReminderInfoInteractor: IReminderInfoInteractor {
    func loadInitData() {
        self.checkIfDateIsSet()
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

            // MARK: - Дата и время

            if indexPath.row == 0 {
                if value {
                    self.presenter?.showCalendarInfo()
                } else {
                    self.presenter?.hideCalendarInfo()
                }
                self.isDateIncluded = value
            } else if indexPath.row == 1 {
                if value {
                    self.isDateIncluded = value
                    self.presenter?.showTime()
                } else {
                    self.presenter?.hideTime()
                    // Если switch перешел в состояние false, то ставим базовое время
                    // 8:00 для того, если switch даты все еще true, то уведомление
                    // показалось в 8:00 того дня
                    self.hoursAndMinutes = DateComponents(calendar: .autoupdatingCurrent,
                                                          timeZone: .autoupdatingCurrent,
                                                          hour: 8,
                                                          minute: 0)
                }
            }
        } else if indexPath.section == 2 {

            // MARK: - Местоположение
            
            if value {
                // показать ячейку с выбором местоположения
                self.presenter?.showLocation()
                self.userCurrentLocationChosen()
            } else {
                // убрать ячейку с выбором местоположения
                self.presenter?.hideLocation()
            }
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
        if self.reminder.text.isEmpty {
            self.reminder.text = "Новое напоминание"
        }
        if self.isDateIncluded {
            let dateAndTime = self.getDateAndTime()
            self.reminder.date = dateAndTime
        } else {
            self.reminder.date = nil
        }
        ReminderManager.sharedInstance.updateReminderAt(self.reminderIndex,
                                                        reminder: self.reminder) { _ in 
            print("saved", self.reminder)
            self.delegate.reloadData()
            self.appDelegate?.scheduleNotification(reminder: self.reminder)
        }
        self.presenter?.dismissVC()
    }

    func userCurrentLocationChosen() {
        // TODO: - Получить информацию о местоположении пользователя
        let stringLocation = "Текущее местоположение:\n" + "Some location that i have to get!"
        self.presenter?.setupViewForUsersCurrentLocation(stringLocation: stringLocation)
    }

    func getInCarLocationChosen() {
        self.presenter?.setupViewForGetInCarLocation()
    }

    func getOutCarLocationChosen() {
        self.presenter?.setupViewForGetOutCarLocation()
    }

    func prepareForPriorityVC() {
        let priority = self.reminder.priority ?? .none
        self.presenter?.goToPriorityVC(currentPriority: priority,
                                       delegate: self)
    }

    func imageFromImagePicker(image: UIImage, url: URL) {
        self.reminder.photos.append(image)
        self.reminder.photosURL.append(url)
        self.presenter?.reloadViewFor(reminder: self.reminder)
    }

    func deleteImage(atIndex index: Int) {
        if self.reminder.photos.count >= index {
            self.reminder.photos.remove(at: index)
        }
        self.presenter?.reloadViewFor(reminder: self.reminder)
    }
}

private extension ReminderInfoInteractor {
    func reloadViewPresentation() {
        self.presenter?.prepareViewFor(reminder: self.reminder)
    }

    func getDateAndTime() -> Date? {
        let calendar = Calendar.current
        if self.dayMonthsAndYears.year ?? 0 <= 1 {
            // Для того, чтобы выбрать дату, соответствующую сегодня
            // если пользователь не выбрал конкретную дату, но выбрал switch календаря
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

    func checkIfDateIsSet() {
        if let date = self.reminder.date {
            self.isDateIncluded = true
            self.presenter?.showCalendarInfo()
            self.presenter?.showTime()

            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.day, .month, .year], from: date)
            self.dayMonthsAndYears = dateComponents
            let timeComponents = calendar.dateComponents([.hour, .minute], from: date)
            self.hoursAndMinutes = timeComponents
        }
    }
}

extension ReminderInfoInteractor: IPriorityDelegate {
    func priorityChanged(newPriority: Priority) {
        self.reminder.priority = newPriority
        self.presenter?.reloadViewFor(reminder: self.reminder)
    }
}

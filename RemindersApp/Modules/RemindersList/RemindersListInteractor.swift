//
//  RemindersListInteractor.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

protocol IRemindersListInteractor {
    func loadInitData()
    func addNewReminder()
    func saveReminderToCompleted(indexPath: IndexPath)
    func deleteReminderAt(indexPath: IndexPath)
    func textDidChanged(indexPath: IndexPath, text: String)
    func goToDetailInfo(indexPath: IndexPath)
    func imageTappedAt(imageIndex: Int, reminderIndex: Int)
    func toggleIsShowingCompletedReminders()
}

protocol IRemindersListInteractorOuter: AnyObject {
    func showDataOnScreen(dataArray: [Reminder])
    func goToDetailInfo(delegate: IReminderListInteractorDelegate,
                        reminder: Reminder,
                        reminderIndex: Int)
    func goToImagesVC(photos: [UIImage?],
                      imageIndex: Int)
    func changeMenuTitles(isCompletedRemindersShowing: Bool)
}

protocol IReminderListInteractorDelegate {
    func reloadData()
}

final class RemindersListInteractor {

    // MARK: - Properties

    weak var presenter: IRemindersListInteractorOuter?
    private lazy var isCompletedRemindersShowing: Bool = {
        UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.isShowingCompletedKey)
    }()
    private let filter = Filter()
}

// MARK: - IRemindersListInteractor

extension RemindersListInteractor: IRemindersListInteractor {

    func loadInitData() {
        self.presenter?.changeMenuTitles(isCompletedRemindersShowing: self.isCompletedRemindersShowing)
        ReminderManager.sharedInstance.loadElements { reminders in
            self.showRemindersOnScreen(reminders: reminders)
        }
    }
    
    func addNewReminder() {
        ReminderManager.sharedInstance.appendElement { reminders in
            self.showRemindersOnScreen(reminders: reminders)
        }
    }
    
    func saveReminderToCompleted(indexPath: IndexPath) {
        guard let reminder = self.getReminder(indexPath: indexPath) else {
            return
        }
        let isDone = !reminder.isDone
        ReminderManager.sharedInstance.saveReminderToCompleted(reminderUID: reminder.uID,
                                                               isDone: isDone) { (reminders) in
            self.showRemindersOnScreen(reminders: reminders)
        }
    }


    func deleteReminderAt(indexPath: IndexPath) {
        guard let reminderIndex = self.getReminderIndex(indexPath: indexPath) else {
            return
        }
        ReminderManager.sharedInstance.removeElement(atIndex: reminderIndex) { reminders in
            self.presenter?.showDataOnScreen(dataArray: reminders)
        }
    }

    func textDidChanged(indexPath: IndexPath, text: String) {
        guard let reminderIndex = self.getReminderIndex(indexPath: indexPath) else {
            return
        }
        ReminderManager.sharedInstance.updateTextForReminderAt(reminderIndex, text: text)
    }

    func goToDetailInfo(indexPath: IndexPath) {
        guard let reminder = self.getReminder(indexPath: indexPath) else {
            return
        }
        guard let reminderIndex = self.getReminderIndex(indexPath: indexPath) else {
            return
        }

        self.presenter?.goToDetailInfo(delegate: self,
                                       reminder: reminder,
                                       reminderIndex: reminderIndex)
    }

    func imageTappedAt(imageIndex: Int, reminderIndex: Int) {
        let reminders = self.getReminders()
        guard let reminder = self.filter.getReminder(
                reminders,
                isCompletedRemindersShowing: self.isCompletedRemindersShowing,
                atIndex: reminderIndex) else {
            return
        }
        guard let index = self.filter.getReminderIndex(
                reminders: reminders,
                reminderUID: reminder.uID) else {
            return
        }
        let photos = reminders[index].photos
        self.presenter?.goToImagesVC(photos: photos,
                                     imageIndex: imageIndex)
    }

    func toggleIsShowingCompletedReminders() {
        self.isCompletedRemindersShowing.toggle()
        let reminders = self.getReminders()
        self.showRemindersOnScreen(reminders: reminders)
        self.presenter?.changeMenuTitles(isCompletedRemindersShowing: self.isCompletedRemindersShowing)
        UserDefaults.standard.setValue(self.isCompletedRemindersShowing,
                                       forKeyPath: AppConstants.UserDefaultsKeys.isShowingCompletedKey)
    }
}

private extension RemindersListInteractor {
    func getReminders() -> [Reminder] {
        return ReminderManager.sharedInstance.getRemindersArray()
    }

    /// Показывает уведомления на экране, отсортировав их
    /// в соответствии со свойством -
    /// self.isCompletedRemindersShowing
    /// для того, чтобы показывать не выполненные/все напоминания
    /// и все работало как следует
    func showRemindersOnScreen(reminders: [Reminder]) {
        let filteredReminders = self.filter.filterReminders(
            reminders,
            isCompletedRemindersShowing: self.isCompletedRemindersShowing)
        self.presenter?.showDataOnScreen(dataArray: filteredReminders)
    }

    func getReminder(indexPath: IndexPath) -> Reminder? {
        let reminders = self.getReminders()
        guard let reminder = self.filter.getReminder(
                reminders,
                isCompletedRemindersShowing: self.isCompletedRemindersShowing,
                atIndex: indexPath.row) else {
            return nil
        }
        return reminder
    }

    func getReminderIndex(indexPath: IndexPath) -> Int? {
        let reminders = self.getReminders()
        guard let reminder = self.filter.getReminder(
                reminders,
                isCompletedRemindersShowing: self.isCompletedRemindersShowing,
                atIndex: indexPath.row) else {
            return nil
        }
        guard let reminderIndex = self.filter.getReminderIndex(
                reminders: reminders,
                reminderUID: reminder.uID) else {
            return nil
        }
        return reminderIndex
    }
}

extension RemindersListInteractor: IReminderListInteractorDelegate {
    func reloadData() {
        let reminders = self.getReminders()
        self.showRemindersOnScreen(reminders: reminders)
    }
}

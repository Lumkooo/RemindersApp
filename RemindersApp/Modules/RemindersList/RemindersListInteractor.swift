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
    func textDidEndEditing(indexPath: IndexPath)
    func textDidBeginEditing(indexPath: IndexPath)
    func goToDetailInfo(indexPath: IndexPath)
    func imageTappedAt(imageIndex: Int, reminderIndex: Int)
    func toggleIsShowingCompletedReminders()
    func stopEdtingText()
}

protocol IRemindersListInteractorOuter: AnyObject {
    func showDataOnScreen(dataArray: [Reminder])
    func goToDetailInfo(delegate: IReminderListInteractorDelegate,
                        reminder: Reminder,
                        reminderIndex: Int)
    func goToImagesVC(photos: [UIImage?],
                      imageIndex: Int)
    func changeMenuTitles(isCompletedRemindersShowing: Bool,
                          isTextEditing: Bool)
    func resignFirstResponder()
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
    private var isTextEditing: Bool = false
    private let filter = Filter()
    private let reminderManager = ReminderManager.sharedInstance
}

// MARK: - IRemindersListInteractor

extension RemindersListInteractor: IRemindersListInteractor {

    func loadInitData() {
        self.reloadMenu()
        self.reminderManager.loadElements { reminders in
            self.filterAndShowRemindersOnScreen(reminders: reminders)
        }
    }
    
    func addNewReminder() {
        self.reminderManager.appendElement { reminders in
            self.filterAndShowRemindersOnScreen(reminders: reminders)
        }
    }
    
    func saveReminderToCompleted(indexPath: IndexPath) {
        guard let reminder = self.getReminder(indexPath: indexPath) else {
            return
        }
        let isDone = !reminder.isDone
        self.reminderManager.saveReminderToCompleted(reminderUID: reminder.uID,
                                                               isDone: isDone) { (reminders) in
            self.filterAndShowRemindersOnScreen(reminders: reminders)
        }
    }

    func deleteReminderAt(indexPath: IndexPath) {
        guard let reminderIndex = self.getReminderIndex(indexPath: indexPath) else {
            return
        }
        self.reminderManager.removeElement(atIndex: reminderIndex) { reminders in
            self.filterAndShowRemindersOnScreen(reminders: reminders)
        }
    }

    func textDidChanged(indexPath: IndexPath, text: String) {
        guard let reminderIndex = self.getReminderIndex(indexPath: indexPath) else {
            return
        }
        self.reminderManager.updateTextForReminderAt(reminderIndex, text: text)
    }

    func textDidEndEditing(indexPath: IndexPath) {
        guard let reminderIndex = self.getReminderIndex(indexPath: indexPath) else {
            return
        }
        self.isTextEditing = false
        self.reloadMenu()
        self.reminderManager.saveTextForReminderAt(reminderIndex)
    }

    func textDidBeginEditing(indexPath: IndexPath) {
        self.isTextEditing = true
        self.reloadMenu()
    }

    func stopEdtingText() {
        self.isTextEditing = false
        self.presenter?.resignFirstResponder()
        self.reloadMenu()
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
        let photos = reminder.photos
        self.presenter?.goToImagesVC(photos: photos,
                                     imageIndex: imageIndex)
    }

    func toggleIsShowingCompletedReminders() {
        self.isCompletedRemindersShowing.toggle()
        UserDefaults.standard.setValue(self.isCompletedRemindersShowing,
                                       forKeyPath: AppConstants.UserDefaultsKeys.isShowingCompletedKey)

        let reminders = self.getReminders()
        self.filterAndShowRemindersOnScreen(reminders: reminders)
        self.reloadMenu()
    }
}

private extension RemindersListInteractor {
    func getReminders() -> [Reminder] {
        return self.reminderManager.getRemindersArray()
    }

    /// Показывает уведомления на экране, отсортировав их
    /// в соответствии со свойством -
    /// self.isCompletedRemindersShowing
    /// для того, чтобы показывать не выполненные/все напоминания
    /// и все работало как следует
    func filterAndShowRemindersOnScreen(reminders: [Reminder]) {
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

    func reloadMenu() {
        self.presenter?.changeMenuTitles(isCompletedRemindersShowing: self.isCompletedRemindersShowing,
                                         isTextEditing: self.isTextEditing)
    }
}

extension RemindersListInteractor: IReminderListInteractorDelegate {
    func reloadData() {
        let reminders = self.getReminders()
        self.filterAndShowRemindersOnScreen(reminders: reminders)
    }
}

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
    func textDidChanged(atIndex index: Int, text: String)
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
}

// MARK: - IRemindersListInteractor

extension RemindersListInteractor: IRemindersListInteractor {

    func loadInitData() {
        self.presenter?.changeMenuTitles(isCompletedRemindersShowing: self.isCompletedRemindersShowing)
        ReminderManager.sharedInstance.loadElements { reminders in
            let filteredReminders = self.filterReminders(reminders)
            self.presenter?.showDataOnScreen(dataArray: filteredReminders)
        }
    }
    
    func addNewReminder() {
        ReminderManager.sharedInstance.appendElement { reminders in
            self.presenter?.showDataOnScreen(dataArray: reminders)
        }
    }
    
    func saveReminderToCompleted(indexPath: IndexPath) {
        let reminders = self.getReminders()
        let isDone = !reminders[indexPath.row].isDone
        ReminderManager.sharedInstance.saveReminderToCompleted(indexPath: indexPath,
                                                               isDone: isDone) { (reminders) in
            self.presenter?.showDataOnScreen(dataArray: reminders)
        }
    }

    func deleteReminderAt(indexPath: IndexPath) {
        ReminderManager.sharedInstance.removeElement(atIndex: indexPath.row) { reminders in
            self.presenter?.showDataOnScreen(dataArray: reminders)
        }
    }

    func textDidChanged(atIndex index: Int, text: String) {
        ReminderManager.sharedInstance.updateTextForReminderAt(index, text: text)
    }

    func goToDetailInfo(indexPath: IndexPath) {
        let reminderIndex = indexPath.row
        guard let reminder = ReminderManager.sharedInstance.getReminderAt(reminderIndex) else {
            assertionFailure("oops, error occured")
            return
        }
        self.presenter?.goToDetailInfo(delegate: self,
                                       reminder: reminder,
                                       reminderIndex: reminderIndex)
    }

    func imageTappedAt(imageIndex: Int, reminderIndex: Int) {
        let reminders = self.getReminders()
        let photos = reminders[reminderIndex].photos
        self.presenter?.goToImagesVC(photos: photos,
                                     imageIndex: imageIndex)
    }

    func toggleIsShowingCompletedReminders() {
        self.isCompletedRemindersShowing.toggle()
        let reminders = self.getReminders()
        let filteredReminders = self.filterReminders(reminders)
        self.presenter?.showDataOnScreen(dataArray: filteredReminders)
        self.presenter?.changeMenuTitles(isCompletedRemindersShowing: self.isCompletedRemindersShowing)
        UserDefaults.standard.setValue(self.isCompletedRemindersShowing,
                                       forKeyPath: AppConstants.UserDefaultsKeys.isShowingCompletedKey)
    }
}

private extension RemindersListInteractor {
    func getReminders() -> [Reminder] {
        return ReminderManager.sharedInstance.getRemindersArray()
    }

    func filterReminders(_ reminders: [Reminder]) -> [Reminder] {
        return reminders.filter {
            if self.isCompletedRemindersShowing {
                return true
            } else {
                return $0.isDone == self.isCompletedRemindersShowing
            }
        }
    }
}

extension RemindersListInteractor: IReminderListInteractorDelegate {
    func reloadData() {
        let reminderArray = self.getReminders()
        self.presenter?.showDataOnScreen(dataArray: reminderArray)
    }
}

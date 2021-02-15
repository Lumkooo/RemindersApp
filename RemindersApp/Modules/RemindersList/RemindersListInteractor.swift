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
}

protocol IRemindersListInteractorOuter: AnyObject {
    func showDataOnScreen(dataArray: [Reminder])
    func goToDetailInfo(delegate: IReminderListInteractorDelegate,
                        reminder: Reminder,
                        reminderIndex: Int)
    func goToImagesVC(photos: [UIImage?],
                      imageIndex: Int)
}

protocol IReminderListInteractorDelegate {
    func reloadData()
}

final class RemindersListInteractor {

    // MARK: - Properties

    weak var presenter: IRemindersListInteractorOuter?
}

// MARK: - IRemindersListInteractor

extension RemindersListInteractor: IRemindersListInteractor {

    func loadInitData() {
        ReminderManager.sharedInstance.loadElements { reminders in
            self.presenter?.showDataOnScreen(dataArray: reminders)
        }
    }
    
    func addNewReminder() {
        ReminderManager.sharedInstance.appendElement { reminders in
            self.presenter?.showDataOnScreen(dataArray: reminders)
        }
    }
    
    func saveReminderToCompleted(indexPath: IndexPath) {
        ReminderManager.sharedInstance.saveReminderToCompleted(indexPath: indexPath)
        self.deleteReminderAt(indexPath: indexPath)
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
}

private extension RemindersListInteractor {
    func getReminders() -> [Reminder] {
        return ReminderManager.sharedInstance.getRemindersArray()
    }
}

extension RemindersListInteractor: IReminderListInteractorDelegate {
    func reloadData() {
        let reminderArray = self.getReminders()
        self.presenter?.showDataOnScreen(dataArray: reminderArray)
    }
}

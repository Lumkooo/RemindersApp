//
//  RemindersListInteractor.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import Foundation

protocol IRemindersListInteractor {
    func loadInitData()
    func addNewReminder()
    func saveReminderToCompleted(indexPath: IndexPath)
    func deleteReminderAt(indexPath: IndexPath)
    func textDidChanged(atIndex index: Int, text: String)
    func goToDetailInfo(indexPath: IndexPath)
}

protocol IRemindersListInteractorOuter: AnyObject {
    func showDataOnScreen(dataArray: [Reminder])
    func goToDetailInfo(delegate: IReminderListInteractorDelegate, reminder: Reminder, reminderIndex: Int)
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
        ReminderManager.sharedInstance.loadElements()
        self.passDataToView()
    }
    
    func addNewReminder() {
        ReminderManager.sharedInstance.appendElement()
        self.passDataToView()
    }
    
    func saveReminderToCompleted(indexPath: IndexPath) {
        ReminderManager.sharedInstance.saveReminderToCompleted(indexPath: indexPath)
        self.deleteReminderAt(indexPath: indexPath)
    }

    func deleteReminderAt(indexPath: IndexPath) {
        ReminderManager.sharedInstance.removeElement(atIndex: indexPath.row)
        self.passDataToView()
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
}

private extension RemindersListInteractor {
    func passDataToView() {
        self.presenter?.showDataOnScreen(dataArray: ReminderManager.sharedInstance.getDataArray())
    }
}

extension RemindersListInteractor: IReminderListInteractorDelegate {
    func reloadData() {
        self.passDataToView()
    }
}

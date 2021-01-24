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
    func goToDetailInfo(reminder: Reminder)
}

final class RemindersListInteractor {

    // MARK: - Properties

    private let reminderManager = ReminderManager()
    weak var presenter: IRemindersListInteractorOuter?
}

// MARK: - IRemindersListInteractor

extension RemindersListInteractor: IRemindersListInteractor {

    func loadInitData() {
        self.addNewReminder()
        self.passDataToView()
    }
    
    func addNewReminder() {
        self.reminderManager.appendElement()
        self.passDataToView()
    }
    
    func saveReminderToCompleted(indexPath: IndexPath) {
        self.reminderManager.saveReminderToCompleted(indexPath: indexPath)
        self.deleteReminderAt(indexPath: indexPath)
    }

    func deleteReminderAt(indexPath: IndexPath) {
        self.reminderManager.removeElement(atIndex: indexPath.row)
        self.passDataToView()
    }

    func textDidChanged(atIndex index: Int, text: String) {
        self.reminderManager.updateElement(atIndex: index, text: text)
    }

    func goToDetailInfo(indexPath: IndexPath) {
        let reminderArray = self.reminderManager.getDataArray()
        let reminder = reminderArray[indexPath.row]
        self.presenter?.goToDetailInfo(reminder: reminder)
    }
}

private extension RemindersListInteractor {
    func passDataToView() {
        self.presenter?.showDataOnScreen(dataArray: self.reminderManager.getDataArray())
    }
}

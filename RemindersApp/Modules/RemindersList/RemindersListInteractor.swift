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
    func updateDataArray(atIndex index: Int, text: String)
}

protocol IRemindersListInteractorOuter: AnyObject {
    func showDataOnScreen(dataArray: [String])
}

final class RemindersListInteractor {

    // MARK: - Properties

    weak var presenter: IRemindersListInteractorOuter?
}

// MARK: - IRemindersListInteractor

extension RemindersListInteractor: IRemindersListInteractor {
    func loadInitData() {
        self.addNewReminder()
        self.passDataToView()
    }
    
    func addNewReminder() {
        ReminderManager.shared.appendElement()
        self.passDataToView()
    }
    
    func updateDataArray(atIndex index: Int, text: String) {
        ReminderManager.shared.updateElement(atIndex: index, text: text)
        self.passDataToView()
    }
}

private extension RemindersListInteractor {
    func passDataToView() {
        self.presenter?.showDataOnScreen(dataArray: ReminderManager.shared.getDataArray())
    }
}

//
//  RemindersListPresenter.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import Foundation

protocol IRemindersListPresenter {
    func viewDidLoad(ui: IRemindersListView)
    func addReminderTapped()
}

final class RemindersListPresenter {

    // MARK: - Properties

    private weak var ui: IRemindersListView?
    private var interactor: IRemindersListInteractor
    private var router: IRemindersListRouter

    init(interactor: IRemindersListInteractor,
         router: IRemindersListRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IRemindersListPresenter

extension RemindersListPresenter: IRemindersListPresenter {
    func viewDidLoad(ui: IRemindersListView) {
        self.ui = ui
        self.ui?.updateDataArray = { (index, text) in
            self.interactor.updateDataArray(atIndex: index, text: text)
        }
        self.interactor.loadInitData()
    }

    func addReminderTapped() {
        self.interactor.addNewReminder()
    }
}

// MARK: - IRemindersListInteractorOuter

extension RemindersListPresenter: IRemindersListInteractorOuter {
    func showDataOnScreen(dataArray: [String]) {
        self.ui?.showDataOnScreen(dataArray: dataArray)
    }
}

//
//  RemindersListInteractor.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import Foundation

protocol IRemindersListInteractor {
    func loadInitData()
}

protocol IRemindersListInteractorOuter: AnyObject {
    func showDataOnScreen(dataArray: [String])
}

final class RemindersListInteractor {

    // MARK: - Properties

    weak var presenter: IRemindersListInteractorOuter?
    private var dataArray: [String] = []
}

// MARK: - IRemindersListInteractor

extension RemindersListInteractor: IRemindersListInteractor {
    func loadInitData() {
        self.dataArray.append("One")
        self.dataArray.append("Two")
        self.dataArray.append("Three")
        self.presenter?.showDataOnScreen(dataArray: self.dataArray)
    }
}

//
//  ReminderInfoPresenter.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/24/21.
//

import Foundation

protocol IReminderInfoPresenter {
    func viewDidLoad(ui: IReminderInfoView)
}

final class ReminderInfoPresenter {

    // MARK: - Properties

    private weak var ui: IReminderInfoView?
    private let router: IReminderInfoRouter
    private let interactor: IReminderInfoInteractor

    // MARK: - Init

    init(router: IReminderInfoRouter, interactor: IReminderInfoInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - IReminderInfoPresenter

extension ReminderInfoPresenter: IReminderInfoPresenter {
    func viewDidLoad(ui: IReminderInfoView) {
        self.ui = ui
        self.ui?.textViewDidChange = { [weak self] (indexPath, text) in
            self?.interactor.textViewDidChange(indexPath: indexPath, text: text)
        }
        self.ui?.switchValueDidChange = { [weak self] (indexPath, value) in
            self?.interactor.switchValueDidChange(indexPath: indexPath, value: value)
        }
        self.interactor.loadInitData()
    }
}

// MARK: - IReminderInfoInteractorOuter

extension ReminderInfoPresenter: IReminderInfoInteractorOuter {
    func prepareViewFor(reminder: Reminder) {
        self.ui?.prepareViewFor(reminder: reminder)
    }

    func showCalendar() {
        self.ui?.showCalendar()
    }

    func hideCalendar() {
        self.ui?.hideCalendar()
    }
}

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
        self.ui?.showCalendar = { [weak self] in
            self?.router.goToCalendar()
        }
        self.interactor.loadInitData()
    }
}

// MARK: - IReminderInfoInteractorOuter

extension ReminderInfoPresenter: IReminderInfoInteractorOuter {
    func prepareViewFor(reminder: Reminder) {
        self.ui?.prepareViewFor(reminder: reminder)
    }

    func showCalendarInfo() {
        self.ui?.showCalendarInfo()
    }

    func hideCalendarInfo() {
        self.ui?.hideCalendarInfo()
    }

    func showTime() {
        self.ui?.showTime()
    }

    func hideTime() {
        self.ui?.hideTime()
    }

    func reloadViewFor(reminder: Reminder) {
        self.ui?.reloadViewFor(reminder: reminder)
    }
}

extension ReminderInfoPresenter: IReminderInfoRouterOuter {
    func setDate(date: Date) {
        self.interactor.setDate(date: date)
    }
}

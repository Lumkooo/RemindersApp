//
//  ReminderInfoPresenter.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/24/21.
//

import Foundation

protocol IReminderInfoPresenter {
    func viewDidLoad(ui: IReminderInfoView)
    func saveTapped()
    func cancelTapped()
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
        self.ui?.dateChanged = { [weak self] (date) in
            self?.interactor.dateChanged(date: date)
        }
        self.ui?.timeChanged = { [weak self] (time) in
            self?.interactor.timeChanged(time: time)
        }
        self.ui?.userCurrentLocation = { [weak self] in
            self?.interactor.userCurrentLocationChosen()
        }
        self.ui?.getInCarLocation = { [weak self] in
            self?.interactor.getInCarLocationChosen()
        }
        self.ui?.getOutCarLocation = { [weak self] in
            self?.interactor.getOutCarLocationChosen()
        }
        self.interactor.loadInitData()
    }

    func saveTapped() {
        self.interactor.saveReminder()
    }

    func cancelTapped() {
        self.router.showCancelAlert()
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

    func showLocation() {
        self.ui?.showLocation()
    }

    func hideLocation() {
        self.ui?.hideLocation()
    }

    func setupViewForUsersCurrentLocation(stringLocation: String) {
        self.ui?.setupViewForUsersCurrentLocation(stringLocation: stringLocation)
    }

    func setupViewForGetInCarLocation() {
        self.ui?.setupViewForGetInCarLocation()
    }

    func setupViewForGetOutCarLocation() {
        self.ui?.setupViewForGetOutCarLocation()
    }
}

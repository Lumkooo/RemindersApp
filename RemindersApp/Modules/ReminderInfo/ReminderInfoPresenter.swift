//
//  ReminderInfoPresenter.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/26/21.
//

import Foundation

protocol IReminderInfoPresenter {
    func viewDidLoad(ui: IReminderInfoView)
}

final class ReminderInfoPresenter {

    private let router: IReminderInfoRouter
    private let interactor: IReminderInfoInteractor
    weak var ui: IReminderInfoView?

    init(router: IReminderInfoRouter, interactor: IReminderInfoInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - IReminderInfoPresenter

extension ReminderInfoPresenter: IReminderInfoPresenter {
    func viewDidLoad(ui: IReminderInfoView) {
        self.ui = ui
    }
}

// MARK: - IReminderInfoInteractorOuter

extension ReminderInfoPresenter: IReminderInfoInteractorOuter {
    
}

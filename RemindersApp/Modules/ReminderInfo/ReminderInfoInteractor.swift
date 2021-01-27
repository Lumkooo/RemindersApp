//
//  ReminderInfoInteractor.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/26/21.
//

import Foundation

protocol IReminderInfoInteractor {

}

protocol IReminderInfoInteractorOuter: AnyObject {

}

final class ReminderInfoInteractor {

    // MARK: - Properties

    weak var presenter: IReminderInfoInteractorOuter?
    private var remidner: Reminder

    // MARK: - Init

    init(reminder: Reminder) {
        self.remidner = reminder
    }
}

// MARK: - IReminderInfoInteractor

extension ReminderInfoInteractor: IReminderInfoInteractor {

}

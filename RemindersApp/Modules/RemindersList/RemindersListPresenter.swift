//
//  RemindersListPresenter.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

protocol IRemindersListPresenter {
    func viewDidLoad(ui: IRemindersListView,
                     vc: IRemindersListViewController)
    func toggleIsShowingCompletedReminders()
}

final class RemindersListPresenter {

    // MARK: - Properties

    private weak var ui: IRemindersListView?
    private weak var vc: IRemindersListViewController?
    private var interactor: IRemindersListInteractor
    private var router: IRemindersListRouter

    init(interactor: IRemindersListInteractor,
         router: IRemindersListRouter) {
        self.interactor = interactor
        self.router = router
    }

    func toggleIsShowingCompletedReminders() {
        self.interactor.toggleIsShowingCompletedReminders()
    }
}

// MARK: - IRemindersListPresenter

extension RemindersListPresenter: IRemindersListPresenter {
    func viewDidLoad(ui: IRemindersListView,
                     vc: IRemindersListViewController) {
        self.ui = ui
        self.vc = vc
        self.ui?.infoButtonTapped = { [weak self] indexPath in
            self?.interactor.goToDetailInfo(indexPath: indexPath)
        }
        self.ui?.isDoneButtonTapped = { [weak self] indexPath in
            self?.interactor.saveReminderToCompleted(indexPath: indexPath)
        }
        self.ui?.deletingCellAt = { [weak self] indexPath in
            self?.interactor.deleteReminderAt(indexPath: indexPath)
        }
        self.ui?.textDidChanged = { [weak self] (index, text) in
            self?.interactor.textDidChanged(atIndex: index, text: text)
        }
        self.ui?.imageTappedAt = { [weak self] (imageIndex, reminderIndex) in
            self?.interactor.imageTappedAt(imageIndex: imageIndex,
                                           reminderIndex: reminderIndex)
        }
        self.ui?.createReminderTapped = { [weak self] in
            self?.interactor.addNewReminder()
        }
        self.interactor.loadInitData()
    }
}

// MARK: - IRemindersListInteractorOuter

extension RemindersListPresenter: IRemindersListInteractorOuter {
    func goToDetailInfo(delegate: IReminderListInteractorDelegate,
                        reminder: Reminder,
                        reminderIndex: Int) {
        self.router.showDetailInfo(delegate: delegate,
                                   forReminder: reminder,
                                   reminderIndex: reminderIndex)
    }

    func showDataOnScreen(dataArray: [Reminder]) {
        self.ui?.showDataOnScreen(dataArray: dataArray)
    }

    func goToImagesVC(photos: [UIImage?], imageIndex: Int) {
        self.router.showImagesVC(photos: photos, imageIndex: imageIndex)
    }

    func changeMenuTitles(isCompletedRemindersShowing: Bool) {
        self.vc?.changeMenuTitles(isCompletedRemindersShowing: isCompletedRemindersShowing)
    }
}

//
//  RemindersListRouter.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

protocol IRemindersListRouter {
    func showDetailInfo(delegate: IReminderListInteractorDelegate,
                        forReminder reminder: Reminder,
                        reminderIndex: Int)
    func showImagesVC(photos: [UIImage?], imageIndex: Int)
}

final class RemindersListRouter {
    weak var vc: UIViewController?
}

// MARK: - IRemindersListRouter

extension RemindersListRouter: IRemindersListRouter {
    func showDetailInfo(delegate: IReminderListInteractorDelegate,
                        forReminder reminder: Reminder,
                        reminderIndex: Int) {
        let reminderInfoVC = ReminderInfoAssembly.createVC(delegate: delegate,
                                                           reminder: reminder,
                                                           reminderIndex: reminderIndex)
        self.vc?.navigationController?.present(reminderInfoVC, animated: true)
    }

    func showImagesVC(photos: [UIImage?], imageIndex: Int) {
        let imagesVC = ImagesViewController(photos: photos, imageIndex: imageIndex)
        imagesVC.modalPresentationStyle = .overFullScreen
        self.vc?.navigationController?.present(imagesVC, animated: true)
    }
}

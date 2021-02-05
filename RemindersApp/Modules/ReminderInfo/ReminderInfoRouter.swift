//
//  ReminderInfoRouter.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/24/21.
//

import UIKit

protocol IReminderInfoRouter {
    func showCancelAlert()
    func dismissVC()
    func showPriorityVC(currentPriority: Priority, delegate: IPriorityDelegate)
    func showCamera()
    func showPhotoLibrary()
}

protocol IReminderInfoRouterOuter: AnyObject {
    func imageFromImagePicker(image: UIImage)
}

final class ReminderInfoRouter {
    weak var vc: UIViewController?
    weak var presenter: IReminderInfoRouterOuter?
    private lazy var imagePickerManager = ImagePickerManager(self.vc ?? UIViewController()) { (image) in
        self.presenter?.imageFromImagePicker(image: image)
    }
}

// MARK: - IReminderInfoRouter

extension ReminderInfoRouter: IReminderInfoRouter {
    func showCancelAlert() {
        let alert = UIAlertController(title: "Уведомление",
                                      message: "Вы хотите выйти и не сохранить заметку?",
                                      preferredStyle: .alert)
        let dismissVCAction = UIAlertAction(title: "Да, выйти",
                                            style: .cancel) { (action) in
            self.dismissVC()
        }
        let stayOnVCAction = UIAlertAction(title: "Нет, остаться на экране", style: .default)
        alert.addAction(dismissVCAction)
        alert.addAction(stayOnVCAction)
        self.vc?.present(alert,
                         animated: true)
    }

    func dismissVC() {
        self.vc?.dismiss(animated: true)
    }

    func showPriorityVC(currentPriority: Priority, delegate: IPriorityDelegate) {
        let priorityVC = PriorityListVCAssembly.createVC(currentPriority: currentPriority,
                                                         delegate: delegate)
        self.vc?.navigationController?.pushViewController(priorityVC, animated: true)
    }

    func showCamera() {
        self.imagePickerManager.openCamera()
    }

    func showPhotoLibrary() {
        self.imagePickerManager.openGallery()
    }
}

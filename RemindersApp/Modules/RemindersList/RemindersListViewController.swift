//
//  ViewController.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

protocol IRemindersListViewController: AnyObject {
    func changeMenuTitles(isCompletedRemindersShowing: Bool,
                          isTextEditing: Bool)
}

class RemindersListViewController: UIViewController {

    // MARK: - Properties

    private let customView = RemindersListView()
    private var presenter: IRemindersListPresenter
    private let barMenuButtonItem = UIBarButtonItem(image: AppConstants.Images.ellipsisCircleImage,
                              style: .done,
                              target: self,
                              action: nil)
    private lazy var barDoneButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                    target: self,
                                                    action: #selector(doneTapped))

    // MARK: - Init

    init(presenter: IRemindersListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Напоминания"
        self.view = self.customView
        self.presenter.viewDidLoad(ui: self.customView,
                                   vc: self)
        self.setupHidingKeyboardOnTap()
    }

    // MARK: - Обработка нажатия на кнопки

    @objc private func doneTapped() {
        self.presenter.stopEdtingText()
    }
}

extension RemindersListViewController: IRemindersListViewController {
    func changeMenuTitles(isCompletedRemindersShowing: Bool,
                          isTextEditing: Bool) {
        if isTextEditing {
            self.navigationItem.rightBarButtonItem = self.barDoneButtonItem
        } else {
            self.navigationItem.rightBarButtonItem = self.barMenuButtonItem
            let itemChildrens = self.setupMenuChildrens(isCompletedRemindersShowing: isCompletedRemindersShowing)
            let items = UIMenu(title: "More",
                               options: .displayInline,
                               children: itemChildrens)
            self.barMenuButtonItem.menu = UIMenu(title: "", children: [items])
            self.barMenuButtonItem.primaryAction = nil
        }
    }
}

private extension RemindersListViewController {
    // Других вариантов изменения текста в меню не нашел
    // Поэтому пусть будет так
    func setupMenuChildrens(isCompletedRemindersShowing: Bool) -> [UIMenuElement] {
        let toggleAction = UIAction(handler: { _ in
            self.presenter.toggleIsShowingCompletedReminders()
        })
        if isCompletedRemindersShowing {
            self.setupUIAction(action: toggleAction,
                               title: "Скрыть завершенные",
                               image: AppConstants.Images.eyeSlashImage)
        } else {
            self.setupUIAction(action: toggleAction,
                               title: "Показать завершенные",
                               image: AppConstants.Images.eyeImage)
        }
        return [toggleAction]
    }

    func setupUIAction(action: UIAction, title: String, image: UIImage?) {
        action.title = title
        action.image = image
    }
}

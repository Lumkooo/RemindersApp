//
//  ReminderInfoViewController.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/24/21.
//

import UIKit

final class ReminderInfoViewController: UIViewController {

    // MARK: - Properties

    private let presenter: IReminderInfoPresenter
    private let customView = ReminderInfoView()

    // MARK: - Init

    init(presenter: IReminderInfoPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.customView
        self.presenter.viewDidLoad(ui: self.customView)
        self.setupHidingKeyboardOnTap()
        self.title = "Detail"
        self.addNavigationBarButtons()
    }

    private func addNavigationBarButtons() {
        self.addNavigationRightBarButton()
        self.addNavigationLeftBarButton()
    }

    private func addNavigationRightBarButton() {
        let save = UIBarButtonItem(barButtonSystemItem: .save,
                                  target: self,
                                  action: #selector(saveTapped))
        navigationItem.rightBarButtonItem = save
    }

    private func addNavigationLeftBarButton() {
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel,
                                  target: self,
                                  action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem = cancel
    }

    @objc private func saveTapped() {
        self.presenter.saveTapped()
    }

    @objc private func cancelTapped() {
        self.presenter.cancelTapped()
    }
}


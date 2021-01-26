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
    }
}


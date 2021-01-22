//
//  ViewController.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

class RemindersListViewController: UIViewController {

    // MARK: - Properties

    private let customView = RemindersListView()
    private var presenter: IRemindersListPresenter

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
        self.view = self.customView
        self.presenter.viewDidLoad(ui: self.customView)
        self.setupHidingKeyboardOnTap()
    }
}


//
//  RemindersListView.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

protocol IRemindersListView: AnyObject {
    var createReminderTapped: (() -> Void)? { get set }
    var isDoneButtonTapped: ((IndexPath) -> Void)? { get set }
    var infoButtonTapped: ((IndexPath) -> Void)? { get set }
    var deletingCellAt: ((IndexPath) -> Void)? { get set }
    var textDidChanged: ((IndexPath, String) -> Void)? { get set }
    var imageTappedAt: ((Int, Int) -> Void)? { get set }

    func showDataOnScreen(dataArray: [Reminder])
}

final class RemindersListView: UIView {

    // MARK: - Views

    private lazy var tableView: UITableView = {
        let myTableView = UITableView(frame: .zero, style: .insetGrouped)
        myTableView.register(RemindersListTableViewCell.self,
                             forCellReuseIdentifier: RemindersListTableViewCell.reuseIdentifier)
        return myTableView
    }()

    private lazy var activitIndicator: UIActivityIndicatorView = {
        let myActivitIndicator = UIActivityIndicatorView()
        myActivitIndicator.hidesWhenStopped = true
        myActivitIndicator.startAnimating()
        myActivitIndicator.style = .large
        return myActivitIndicator
    }()

    private lazy var createReminderButton: UIButton = {
        let myButton = UIButton()
        myButton.addTarget(self,
                           action: #selector(createReminderButtonTapped),
                           for: .touchUpInside)
        myButton.setTitle("Добавить напоминание", for: .normal)
        myButton.setTitleColor(.systemOrange, for: .normal)
        myButton.backgroundColor = self.tableView.backgroundColor
        return myButton
    }()

    // MARK: - Properties

    private var tableViewDelegate: CustomTableViewDelegate?
    private var tableViewDataSource: RemindersTableViewDataSource?
    var createReminderTapped: (() -> Void)?
    var isDoneButtonTapped: ((IndexPath) -> Void)?
    var infoButtonTapped: ((IndexPath) -> Void)?
    var deletingCellAt: ((IndexPath) -> Void)?
    var textDidChanged: ((IndexPath, String) -> Void)?
    var imageTappedAt: ((Int, Int) -> Void)?

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        self.setupElements()
        self.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Обработка нажатий на кнопки

    @objc private func createReminderButtonTapped() {
        self.createReminderTapped?()
    }
}

// MARK: - IRemindersListView

extension RemindersListView: IRemindersListView {
    func showDataOnScreen(dataArray: [Reminder]) {
        self.tableViewDataSource?.setReminderArray(dataArray)
        self.tableView.reloadData()
        if self.activitIndicator.isAnimating {
            self.activitIndicator.stopAnimating()
        }
    }
}

// MARK: - UISetup

private extension RemindersListView {
    func setupElements() {
        self.setupTableView()
        self.setupActivityIndicator()
        self.setupCreateReminderButton()
    }

    func setupTableView() {
        self.tableViewDelegate = CustomTableViewDelegate(delegate: self)
        self.tableViewDataSource = RemindersTableViewDataSource(delegate: self)
        self.tableView.delegate = self.tableViewDelegate
        self.tableView.dataSource = self.tableViewDataSource
        self.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func setupActivityIndicator() {
        self.addSubview(self.activitIndicator)
        self.activitIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.activitIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activitIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func setupCreateReminderButton() {
        self.addSubview(self.createReminderButton)
        self.createReminderButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.createReminderButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.createReminderButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.createReminderButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.createReminderButton.heightAnchor.constraint(equalTo: self.heightAnchor,
                                                              multiplier: 0.1)
        ])
    }
}

// MARK: - IRemindersTableViewDelegate

extension RemindersListView: ICustomTableViewDelegate {
    func didSelectRowAt(_ indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RemindersListView: IRemindersTableViewDataSource {
    func deletingCellAt(_ indexPath: IndexPath) {
        self.deletingCellAt?(indexPath)
    }

    func infoButtonTapped(indexPath: IndexPath) {
        self.infoButtonTapped?(indexPath)
    }

    func isDoneButtonTapped(indexPath: IndexPath) {
        self.isDoneButtonTapped?(indexPath)
    }

    func textDidChanged(indexPath: IndexPath, text: String) {
        self.textDidChanged?(indexPath, text)
    }

    func imageTappedAt(imageIndex: Int, reminderIndex: Int) {
        self.imageTappedAt?(imageIndex, reminderIndex)
    }
}

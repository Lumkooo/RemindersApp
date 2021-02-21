//
//  RemindersListView.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

protocol IRemindersListView: AnyObject {
    var isDoneButtonTapped: ((IndexPath) -> Void)? { get set }
    var infoButtonTapped: ((IndexPath) -> Void)? { get set }
    var deletingCellAt: ((IndexPath) -> Void)? { get set }
    var textDidChanged: ((Int, String) -> Void)? { get set }
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

    // MARK: - Properties

    private var tableViewDelegate: CustomTableViewDelegate?
    private var tableViewDataSource: RemindersTableViewDataSource?
    var isDoneButtonTapped: ((IndexPath) -> Void)?
    var infoButtonTapped: ((IndexPath) -> Void)?
    var deletingCellAt: ((IndexPath) -> Void)?
    var textDidChanged: ((Int, String) -> Void)?
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
        let cell = self.tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.45) {
            cell?.contentView.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            cell?.contentView.alpha = 1
            self.isDoneButtonTapped?(indexPath)
        }
    }

    func textDidChanged(atIndex index: Int, text: String) {
        self.textDidChanged?(index, text)
    }

    func imageTappedAt(imageIndex: Int, reminderIndex: Int) {
        self.imageTappedAt?(imageIndex, reminderIndex)
    }
}

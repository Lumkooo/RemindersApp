//
//  ReminderInfoView.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/24/21.
//

import UIKit

protocol IReminderInfoView: AnyObject {
    var textViewDidChange: ((IndexPath, String) -> Void)? { get set }
    var switchValueDidChange: ((IndexPath, Bool) -> Void)? { get set }

    func prepareViewFor(reminder: Reminder)
    func showCalendar()
    func hideCalendar()
}

final class ReminderInfoView: UIView {


    // MARK: - Views

    private let tableView: UITableView = {
        let myTableView = UITableView(frame: .zero, style: .insetGrouped)
        return myTableView
    }()

    // MARK: - Properties

    private var tableViewDataSource: ReminderInfoTableViewDataSource?
    private var tableViewDelegate: CustomTableViewDelegate?
    var textViewDidChange: ((IndexPath, String) -> Void)?
    var switchValueDidChange: ((IndexPath, Bool) -> Void)?

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

// MARK: - IReminderInfoView

extension ReminderInfoView: IReminderInfoView {
    func prepareViewFor(reminder: Reminder) {
        self.tableViewDataSource?.reminder = reminder
    }

    func showCalendar() {
        self.tableViewDataSource?.showCalendar()
        self.tableView.reloadData()
    }

    func hideCalendar() {
        self.tableViewDataSource?.hideCalendar()
        self.tableView.reloadData()
    }
}

// MARK: - UISetup

private extension ReminderInfoView {
    func setupElements() {
        self.setupTableView()
    }

    func setupTableView() {
        self.tableView.register(ReminderInfoTextViewTableViewCell.self,
                                forCellReuseIdentifier: ReminderInfoTextViewTableViewCell.reuseIdentifier)
        self.tableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: "cellID")
        self.tableView.register(ReminderInfoSwitcherTableViewCell.self,
                                forCellReuseIdentifier: ReminderInfoSwitcherTableViewCell.reuseIdentifier)
        self.tableView.register(ReminderInfoPriorityTableViewCell.self,
                                forCellReuseIdentifier: ReminderInfoPriorityTableViewCell.reuseIdentifier)
        self.tableViewDelegate = CustomTableViewDelegate(delegate: self)
        self.tableViewDataSource = ReminderInfoTableViewDataSource(delegate: self)
        self.tableView.delegate = tableViewDelegate
        self.tableView.dataSource = tableViewDataSource
        self.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

// MARK: - ICustomTableViewDelegate

extension ReminderInfoView: ICustomTableViewDelegate {
    func didSelectRowAt(_ indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - IReminderInfoTableViewDataSource

extension ReminderInfoView: IReminderInfoTableViewDataSource {
    func textViewDidChange(indexPath: IndexPath, text: String) {
        self.textViewDidChange?(indexPath, text)
    }

    func switchValueDidChange(indexPath: IndexPath, value: Bool) {
        self.switchValueDidChange?(indexPath, value)
    }
}

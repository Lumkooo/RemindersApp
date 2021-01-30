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
    var showCalendar: (() -> Void)? { get set }

    func prepareViewFor(reminder: Reminder)
    func reloadViewFor(reminder: Reminder)
    func showCalendarInfo()
    func hideCalendarInfo()
    func showTime()
    func hideTime()
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
    var showCalendar: (() -> Void)?

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

    func reloadViewFor(reminder: Reminder) {
        self.tableViewDataSource?.reminder = reminder
        self.reloadTableViewWithAnimation()
    }

    func showCalendarInfo() {
        self.tableViewDataSource?.showCalendar()
        self.reloadTableViewWithAnimation()
    }
    
    func hideCalendarInfo() {
        self.tableViewDataSource?.hideCalendar()
        self.reloadTableViewWithAnimation()
    }

    func showTime() {
        self.tableViewDataSource?.showTime()
        self.reloadTableViewWithAnimation()
    }

    func hideTime() {
        self.tableViewDataSource?.hideTime()
        self.reloadTableViewWithAnimation()
    }

    private func reloadTableViewWithAnimation() {
        UIView.transition(with: tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
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
                                forCellReuseIdentifier: AppConstants.TableViewCells.cellID)
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

        if indexPath == IndexPath(row: 2, section: 1) {
            self.showCalendar?()
        }
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


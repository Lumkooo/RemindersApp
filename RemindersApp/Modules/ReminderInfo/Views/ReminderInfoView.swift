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
    var dateChanged: ((Date) -> Void)? { get set }
    var timeChanged: ((Date) -> Void)? { get set }
    var userCurrentLocation: (() -> Void)? { get set }
    var getInCarLocation: (() -> Void)? { get set }
    var getOutCarLocation: (() -> Void)? { get set }

    func prepareViewFor(reminder: Reminder)
    func reloadViewFor(reminder: Reminder)
    func showCalendarInfo()
    func hideCalendarInfo()
    func showTime()
    func hideTime()
    func showLocation()
    func hideLocation()
    func setupViewForUsersCurrentLocation(stringLocation: String)
    func setupViewForGetInCarLocation()
    func setupViewForGetOutCarLocation()
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
    var dateChanged: ((Date) -> Void)?
    var timeChanged: ((Date) -> Void)?
    var userCurrentLocation: (() -> Void)?
    var getInCarLocation: (() -> Void)?
    var getOutCarLocation: (() -> Void)?

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

    func showLocation() {
        self.tableViewDataSource?.showLocation()
        self.reloadTableViewWithAnimation()
    }

    func hideLocation() {
        self.tableViewDataSource?.hideLocation()
        self.reloadTableViewWithAnimation()
    }

    func setupViewForUsersCurrentLocation(stringLocation: String) {
        self.tableViewDataSource?.setupViewForUsersCurrentLocation(stringLocation: stringLocation)
        self.reloadTableViewWithAnimation()
    }

    func setupViewForGetInCarLocation() {
        self.tableViewDataSource?.setupViewForGetInCarLocation()
        self.reloadTableViewWithAnimation()
    }

    func setupViewForGetOutCarLocation() {
        self.tableViewDataSource?.setupViewForGetOutCarLocation()
        self.reloadTableViewWithAnimation()
    }

    private func reloadTableViewWithAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.AnimationTimes.reloadTableView) {
            UIView.transition(with: self.tableView,
                              duration: AppConstants.AnimationTimes.reloadTableView,
                              options: .transitionCrossDissolve,
                              animations: { self.tableView.reloadData() })
        }
    }
}

// MARK: - UISetup

private extension ReminderInfoView {
    func setupElements() {
        self.setupTableView()
    }

    func registerTableViewCells() {
        self.tableView.register(ReminderInfoTextViewTableViewCell.self,
                                forCellReuseIdentifier: ReminderInfoTextViewTableViewCell.reuseIdentifier)
        self.tableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: AppConstants.TableViewCells.cellID)
        self.tableView.register(ReminderInfoSwitcherTableViewCell.self,
                                forCellReuseIdentifier: ReminderInfoSwitcherTableViewCell.reuseIdentifier)
        self.tableView.register(ReminderInfoPriorityTableViewCell.self,
                                forCellReuseIdentifier: ReminderInfoPriorityTableViewCell.reuseIdentifier)
        self.tableView.register(ReminderInfoDateTableViewCell.self,
                                forCellReuseIdentifier: ReminderInfoDateTableViewCell.reuseIdentifier)
        self.tableView.register(ReminderInfoLocationTableViewCell.self,
                                forCellReuseIdentifier: ReminderInfoLocationTableViewCell.reuseIdentifier)
    }

    func setupTableView() {
        self.registerTableViewCells()
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

    func dateChanged(newDate: Date) {
        self.dateChanged?(newDate)
    }

    func timeChanged(newTime: Date) {
        self.timeChanged?(newTime)
    }

    func userCurrentLocationChosen() {
        self.userCurrentLocation?()
    }

    func getInCarLocationChosen() {
        self.getInCarLocation?()
    }

    func getOutCarLocationChosen() {
        self.getOutCarLocation?()
    }
}


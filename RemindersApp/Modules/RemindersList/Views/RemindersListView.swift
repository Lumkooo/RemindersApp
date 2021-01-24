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

    // MARK: - Properties

    private var tableViewDelegate: RemindersTableViewDelegate?
    private var tableViewDataSource: RemindersTableViewDataSource?
    var isDoneButtonTapped: ((IndexPath) -> Void)?
    var infoButtonTapped: ((IndexPath) -> Void)?
    var deletingCellAt: ((IndexPath) -> Void)?
    var textDidChanged: ((Int, String) -> Void)?

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
        self.tableViewDataSource?.dataArray = dataArray
        self.tableView.reloadData()
    }
}

// MARK: - UISetup

private extension RemindersListView {
    func setupElements() {
        self.setupTableView()
    }

    func setupTableView() {
        self.tableViewDelegate = RemindersTableViewDelegate(delegate: self)
        self.tableViewDataSource = RemindersTableViewDataSource(delegate: self)
        self.tableView.delegate = self.tableViewDelegate
        self.tableView.dataSource = self.tableViewDataSource
        self.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - IRemindersTableViewDelegate

extension RemindersListView: IRemindersTableViewDelegate {
    func didSelectRowAt(_ indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        print("cell tapped at: \(indexPath.row)")
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
//            ReminderManager.shared.removeElement(atIndex: indexPath.row)
//            self.tableViewDataSource?.dataArray = ReminderManager.shared.getDataArray()
//            self.tableView.reloadData()
            cell?.contentView.alpha = 1
            self.isDoneButtonTapped?(indexPath)
        }
    }

    func textDidChanged(atIndex index: Int, text: String) {
        self.textDidChanged?(index, text)
    }
}

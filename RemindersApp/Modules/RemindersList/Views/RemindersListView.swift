//
//  RemindersListView.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

protocol IRemindersListView: AnyObject {
    var updateDataArray: ((Int, String) -> Void)? { get set }

    func showDataOnScreen(dataArray: [String])
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
    private var tableViewDataSource = RemindersTableViewDataSource()
    var updateDataArray: ((Int, String) -> Void)?

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        self.setupElements()
        self.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public method

    func updateData(atIndex index: Int, text: String) {
        self.updateDataArray?(index, text)
    }
}

// MARK: - IRemindersListView

extension RemindersListView: IRemindersListView {
    func showDataOnScreen(dataArray: [String]) {
        self.tableViewDataSource.dataArray = dataArray
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

//
//  PrioritiesTableViewController.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 2/4/21.
//

import UIKit

class PrioritiesTableViewController: UITableViewController {

    // MARK: - Properties

    private var priorities: [Priority] = []
    private var chosenPrioriry: Priority
    private var delegate: IPriorityDelegate

    // MARK: - Init

    init(currentPriority: Priority, delegate: IPriorityDelegate) {
        self.chosenPrioriry = currentPriority
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC Lyfe Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCell()
        self.setupPriorities()
    }

    private func setupPriorities() {
        for priority in Priority.allCases {
            priorities.append(priority)
        }
    }

    private func registerTableViewCell() {
        self.tableView.register(PrioritiesListTableViewCell.self,
                                forCellReuseIdentifier: PrioritiesListTableViewCell.reuseIdentifier)
    }
}

// MARK: - Table view data source

extension PrioritiesTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.priorities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrioritiesListTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? PrioritiesListTableViewCell else {
            assertionFailure("oops, can't dequeue cell")
            return UITableViewCell()
        }

        let priority = self.priorities[indexPath.row]

        cell.setupCell(cellPriority: priority, chosenPriority: self.chosenPrioriry)

        return cell
    }
}

// MARK: - Table view delegate

extension PrioritiesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosenPrioriry = self.priorities[indexPath.row]
        self.delegate.priorityChanged(newPriority: self.chosenPrioriry)
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
    }
}

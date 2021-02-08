//
//  RemindersTableViewDataSource.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

protocol IRemindersTableViewDataSource {
    func infoButtonTapped(indexPath: IndexPath)
    func isDoneButtonTapped(indexPath: IndexPath)
    func deletingCellAt(_ indexPath: IndexPath)
    func textDidChanged(atIndex index: Int, text: String)
}

final class RemindersTableViewDataSource: NSObject {

    // MARK: - Properties

    var reminderArray: [Reminder] = []
    private let delegate: IRemindersTableViewDataSource

    // MARK: - Init
    
    init(delegate: IRemindersTableViewDataSource) {
        self.delegate = delegate
    }
}

// MARK: - UITableViewDataSource

extension RemindersTableViewDataSource: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminderArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RemindersListTableViewCell.reuseIdentifier,
                for: indexPath) as? RemindersListTableViewCell else {
            assertionFailure("Can't dequeue tableView cell")
            return UITableViewCell()
        }
        let reminder = reminderArray[indexPath.row]
        cell.setupCell(tableView: tableView,
                       cellIndex: indexPath.row,
                       reminder: reminder)
        cell.infoButtonTapped = {
            self.delegate.infoButtonTapped(indexPath: indexPath)
        }
        cell.isDoneButtonTapped = {
            self.delegate.isDoneButtonTapped(indexPath: indexPath)
        }
        cell.textViewDidChange = { (index, text) in
            self.delegate.textDidChanged(atIndex: index, text: text)
        }
        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.delegate.deletingCellAt(indexPath)
        }
    }
}

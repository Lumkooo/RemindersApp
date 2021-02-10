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
    func imageTappedAt(imageIndex: Int, reminderIndex: Int)
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
        cell.setupCell(reminder: reminder)
        cell.infoButtonTapped = { [weak self] in
            self?.delegate.infoButtonTapped(indexPath: indexPath)
        }
        cell.isDoneButtonTapped = { [weak self] in
            self?.delegate.isDoneButtonTapped(indexPath: indexPath)
        }
        cell.textViewDidChange = { [weak self] (text) in
            tableView.beginUpdates()
            tableView.endUpdates()
            self?.delegate.textDidChanged(atIndex: indexPath.row, text: text)
        }
        cell.imageTapped = { [weak self] (index) in
            self?.delegate.imageTappedAt(imageIndex: index,
                                         reminderIndex: indexPath.row)
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

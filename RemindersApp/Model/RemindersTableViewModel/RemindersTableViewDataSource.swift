//
//  RemindersTableViewDataSource.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

protocol IRemindersTableViewDataSource {

}

final class RemindersTableViewDataSource: NSObject {

    // MARK: - Properties

    var dataArray: [String] = []
}

// MARK: - UITableViewDataSource

extension RemindersTableViewDataSource: UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Напоминания"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RemindersListTableViewCell.reuseIdentifier,
                for: indexPath) as? RemindersListTableViewCell else {
            assertionFailure("Can't dequeue tableView cell")
            return UITableViewCell()
        }
        let data = dataArray[indexPath.row]
        cell.setupCell(tableView: tableView,
                       cellIndex: indexPath.row,
                       text: data)
        return cell
    }
}

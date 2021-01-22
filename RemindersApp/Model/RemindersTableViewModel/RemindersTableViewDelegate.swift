//
//  RemindersTableViewDelegate.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

protocol IRemindersTableViewDelegate {
    func didSelectRowAt(_ indexPath: IndexPath)
}

final class RemindersTableViewDelegate: NSObject {

    // MARK: - Constants

    private enum Constants {
        static let tableViewEstimatedHeight: CGFloat = 444
    }

    // MARK: - Properties

    private let delegate: IRemindersTableViewDelegate

    // MARK: - Init

    init(delegate: IRemindersTableViewDelegate) {
        self.delegate = delegate
    }
}

extension RemindersTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.didSelectRowAt(indexPath)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.tableViewEstimatedHeight
    }
}

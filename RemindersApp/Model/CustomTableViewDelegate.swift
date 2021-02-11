//
//  RemindersTableViewDelegate.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

protocol ICustomTableViewDelegate {
    func didSelectRowAt(_ indexPath: IndexPath)
}

final class CustomTableViewDelegate: NSObject {

    // MARK: - Constants

    private enum Constants {
        static let tableViewEstimatedHeight: CGFloat = 44
    }

    // MARK: - Properties

    private let delegate: ICustomTableViewDelegate

    // MARK: - Init

    init(delegate: ICustomTableViewDelegate) {
        self.delegate = delegate
    }
}

extension CustomTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.didSelectRowAt(indexPath)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.tableViewEstimatedHeight
    }
}

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
        static let tableViewEstimatedHeight: CGFloat = 444
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

//    func tableView(_ tableView: UITableView,
//                   contextMenuConfigurationForRowAt indexPath: IndexPath,
//                   point: CGPoint) -> UIContextMenuConfiguration? {
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
//
//            return self.makeContextMenu()
//        })
//    }
//
//    func makeContextMenu() -> UIMenu {
//
//        // Create a UIAction for sharing
//        let share = UIAction(title: "Photo Library",
//                             image: UIImage(systemName: "square.and.arrow.up")) { action in
//            // Show system share sheet
//        }
//
//        // Create and return a UIMenu with the share action
//        return UIMenu(title: "Main Menu", children: [share])
//    }
}

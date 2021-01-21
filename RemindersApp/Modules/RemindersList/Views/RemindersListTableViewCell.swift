//
//  RemindersListTableViewCell.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

final class RemindersListTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static var reuseIdentifier: String {
        return String(describing: RemindersListTableViewCell.self)
    }

    // MARK: - Public method

    func setupCell(text: String) {
        self.textLabel?.text = text
    }
}

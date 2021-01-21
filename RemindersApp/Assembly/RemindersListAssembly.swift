//
//  RemindersListAssembly.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

enum RemindersListAssembly {
    static func createVC() -> UIViewController {
        let listViewController = RemindersListViewController()
        return listViewController
    }
}

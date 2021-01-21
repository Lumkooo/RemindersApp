//
//  NavigationVCAssembly.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

enum NavigationControllerAssembly {
    static func createNavigationController() -> UINavigationController {
        let remindersListVC = RemindersListAssembly.createVC()
        let navigationController = UINavigationController(rootViewController: remindersListVC)
        return navigationController
    }
}

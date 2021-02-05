//
//  PriorityListVCAssembly.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 2/4/21.
//

import UIKit

enum PriorityListVCAssembly {
    static func createVC(currentPriority: Priority, delegate: IPriorityDelegate) -> UIViewController {
        let priorityListVC = PrioritiesTableViewController(currentPriority: currentPriority,
                                                           delegate: delegate)
        return priorityListVC
    }
}

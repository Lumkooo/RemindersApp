//
//  RemindersListAssembly.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

enum RemindersListAssembly {
    static func createVC() -> UIViewController {
        let interactor = RemindersListInteractor()
        let router = RemindersListRouter()
        let presenter = RemindersListPresenter(interactor: interactor,
                                               router: router)
        let listViewController = RemindersListViewController(presenter: presenter)

        router.vc = listViewController
        interactor.presenter = presenter
        
        return listViewController
    }
}

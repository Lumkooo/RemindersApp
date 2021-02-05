//
//  Priority.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/26/21.
//

import Foundation

enum Priority: String, CaseIterable {
    case none = "Отсутствует"
    case low = "Низкий"
    case normal = "Средний"
    case high = "Высокий"

    init() {
        self = Priority.none
    }
}

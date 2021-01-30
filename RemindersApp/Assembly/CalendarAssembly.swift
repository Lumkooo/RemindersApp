//
//  CalendarAssembly.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/27/21.
//

import UIKit

enum CalendarAssembly {
    static func createVC(selectedDateChanged: @escaping ((Date) -> Void)) -> UIViewController {
        let today = Date()
        let vc = CalendarPickerViewController(baseDate: today, selectedDateChanged: selectedDateChanged)
        return vc
    }
}

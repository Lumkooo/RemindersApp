//
//  Reminder.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/22/21.
//

import Foundation
import MapKit

struct Reminder {
    var text: String
    var isDone: Bool
    var date: Date?
    var location: CLLocation?
    var photo: UIImage?
}

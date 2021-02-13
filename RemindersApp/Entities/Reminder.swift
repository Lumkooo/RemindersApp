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
    var note: String?
    var url: String?
    var isDone: Bool
    var date: Date?
    var location: CLLocation?
    var flag: Bool
    var photos: [UIImage?]
    var photosURL: [URL]
    var priority: Priority?

    // MARK: - Init

    init() {
        self.text = ""
        self.note = nil
        self.url = nil
        self.isDone = false
        self.date = nil
        self.location = nil
        self.photos = []
        self.flag = false
        self.priority = Priority()
        self.photosURL = []
    }
}

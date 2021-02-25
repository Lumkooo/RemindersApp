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
    var uID: String
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
        self.uID = UUID().uuidString
    }

    init(text: String,
         uID: String,
         note: String?,
         url: String?,
         isDone: Bool,
         date: Date?,
         location: CLLocation?,
         flag: Bool,
         photos: [UIImage?],
         photosURL: [URL],
         priority: Priority?) {
        self.text = text
        self.note = note
        self.url = url
        self.isDone = isDone
        self.date = date
        self.location = location
        self.photos = photos
        self.flag = flag
        self.priority = priority
        self.photosURL = photosURL
        self.uID = uID
    }

    init(text: String) {
        self.text = text
        self.note = nil
        self.url = nil
        self.isDone = false
        self.date = nil
        self.location = nil
        self.photos = []
        self.flag = false
        self.priority = .none
        self.photosURL = []
        self.uID = UUID().uuidString
    }

}

//
//  ReminderManager.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/22/21.
//

import Foundation
import UIKit

final class ReminderManager {

    // MARK: Properties

    static let sharedInstance = ReminderManager()
    private var dataArray: [Reminder] = []

    // MARK: Methods

    func getDataArray() -> [Reminder] {
        return self.dataArray
    }

    func getReminderAt(_ index: Int) -> Reminder? {
        if self.dataArray.count >= index {
            return self.dataArray[index]
        } else {
            return nil
        }
    }

    func appendElement() {
        self.dataArray.append(Reminder())
    }

    func appendElement(reminder: Reminder) {
        self.dataArray.append(reminder)
        CoreDataManager.sharedInstance.appendReminder(reminder)
    }

    func updateTextForReminderAt(_ index: Int, text: String) {
        self.dataArray[index].text = text
    }

    func updateReminderAt(_ index: Int, reminder: Reminder) {
        self.dataArray[index] = reminder
        CoreDataManager.sharedInstance.updateReminderAt(index, reminder: reminder)
    }

    func loadElements() {
        // TODO: - Загрузка из CoreData
        let reminders = CoreDataManager.sharedInstance.getReminders()
        if !reminders.isEmpty {
            for reminder in reminders {
                let priority = Priority(rawValue: reminder.priority ?? "Отсутствует")
                let photos = self.photosFromCoreData(object: reminder.photos) ?? []
                let photosURL = self.photosURLFromCoreData(object: reminder.photosURL) ?? []
                let reminder = Reminder(text: reminder.text,
                                        uID: reminder.uID,
                                        note: reminder.note,
                                        url: reminder.url,
                                        isDone: reminder.isDone,
                                        date: reminder.date,
                                        // MARK: - Пока что с местоположением не работаем
                                        location: nil,
                                        flag: reminder.flag,
                                        photos: photos,
                                        photosURL: photosURL,
                                        priority: priority)
                self.dataArray.append(reminder)
                print("ADDED")
            }
        } else {
            print("EMPTY")
        }
    }

    func removeElement(atIndex index: Int) {
        self.dataArray.remove(at: index)
        CoreDataManager.sharedInstance.removeReminder(atIndex: index)
    }

    func saveReminderToCompleted(indexPath: IndexPath) {
//        CoreDataManager.sharedInstance.
        // TODO: - Сохранение в удаленные в CoreData
    }
}

private extension ReminderManager {
    func photosFromCoreData(object: Data?) -> [UIImage?]? {
        var retVal = [UIImage]()

        guard let object = object else { return nil }
        if let dataArray = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: object) {
            for data in dataArray {
                if let data = data as? Data,
                   let image = UIImage(data: data) {
                    retVal.append(image)
                }
            }
        }
        return retVal
    }

    func photosURLFromCoreData(object: Data?) -> [URL]? {
        var retVal = [URL]()

        guard let object = object else { return nil }
        if let dataArray = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: object) {
            for data in dataArray {
                if let data = data as? Data,
                   let url = URL(dataRepresentation: data, relativeTo: nil) {
                    retVal.append(url)
                }
            }
        }
        return retVal
    }

}

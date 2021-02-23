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
    private let coreDataManager = CoreDataManager()
    private let globaUserInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
    private let maindQueue = DispatchQueue.main
    private let filter = Filter()

    // MARK: Methods

    func getRemindersArray() -> [Reminder] {
        return self.dataArray
    }


    func getReminderAt(_ index: Int) -> Reminder? {
        if self.dataArray.count >= index {
            return self.dataArray[index]
        } else {
            return nil
        }
    }

    func appendElement(completion: (([Reminder]) -> Void)) {
        self.dataArray.append(Reminder())
        completion(self.dataArray)
    }

    func updateTextForReminderAt(_ index: Int,
                                 text: String) {
        self.dataArray[index].text = text
    }

    func updateReminderAt(_ index: Int,
                          reminder: Reminder,
                          completion: @escaping () -> Void) {
        self.globaUserInitiatedQueue.async {
            self.dataArray[index] = reminder
            self.coreDataManager.updateReminderAt(index, reminder: reminder)
            self.maindQueue.async {
                completion()
            }
        }
    }

    func loadElements(completion: @escaping (([Reminder]) -> Void)) {
        self.globaUserInitiatedQueue.async {
            let reminders = self.coreDataManager.getReminders()
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
                }
                self.maindQueue.async {
                    completion(self.dataArray)
                }
            } else {
                // Возвращаем пустой массив
                self.maindQueue.async {
                    completion([])
                }
            }
        }
    }

    func removeElement(atIndex index: Int,
                       completion: @escaping (([Reminder]) -> Void)) {
        self.globaUserInitiatedQueue.async {
            self.dataArray.remove(at: index)
            self.coreDataManager.removeReminder(atIndex: index)
            self.maindQueue.async {
                completion(self.dataArray)
            }
        }
    }

    func saveReminderToCompleted(reminderUID: String,
                                 isDone: Bool,
                                 completion: @escaping (([Reminder]) -> Void)) {
        
        guard let reminderIndex = self.filter.getReminderIndex(reminders: self.dataArray,
                                                               reminderUID: reminderUID) else {
            return
        }
        self.dataArray[reminderIndex].isDone = isDone
        self.coreDataManager.saveReminderToCompleted(reminderIndex: reminderIndex,
                                                     isDone: isDone)
        completion(self.dataArray)
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

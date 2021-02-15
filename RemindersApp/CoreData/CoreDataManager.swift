//
//  CoreDataManager.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 2/14/21.
//

import UIKit
import CoreData


final class CoreDataManager {

    // MARK: - Properties

    private var coreDataReminder: [CoreDataReminder] = []
    private let context: NSManagedObjectContext

    // MARK: - Init

    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get appDelegate during Init")
        }
        self.context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CoreDataReminder> = CoreDataReminder.fetch()
        do {
            self.coreDataReminder = try self.context.fetch(fetchRequest)
        } catch {
            // MARK: - Можно вывести ошибку пользователю
            assertionFailure("Can not fetch")
        }
    }

}

// MARK: - Работа с напоминаниям

extension CoreDataManager {

    // MARK: - Добавление напоминания

    func appendReminder(_ reminder: Reminder) {
        let coreDataReminder = CoreDataReminder(context: self.context)
        coreDataReminder.text = reminder.text
        coreDataReminder.uID = reminder.uID
        coreDataReminder.note = reminder.note
        coreDataReminder.url = reminder.url
        coreDataReminder.isDone = reminder.isDone
        coreDataReminder.date = reminder.date
        coreDataReminder.flag = reminder.flag
        coreDataReminder.photos = self.coreDataObjectFromPhotos(images: reminder.photos)
        coreDataReminder.photosURL = self.coreDataObjectFromPhotoURL(photoURL: reminder.photosURL)
        coreDataReminder.priority = reminder.priority?.rawValue

        self.coreDataReminder.append(coreDataReminder)
        do {
            print("SAVED", self.coreDataReminder)
            try self.context.save()
        } catch {
            self.context.rollback()
            assertionFailure("Can not append reminder")
        }
    }

    // MARK: - Удаление напоминания

    func removeReminder(atIndex index: Int) {
        if self.coreDataReminder.count > index {
            self.coreDataReminder.remove(at: index)
            let fetchRequest: NSFetchRequest<CoreDataReminder> = CoreDataReminder.fetch()
            do {
                let entitie = try self.context.fetch(fetchRequest)[index]
                self.context.delete(entitie)
                try self.context.save()
            } catch {
                self.context.rollback()
                assertionFailure("Can not remove reminder at index: \(index)")
            }
        } else {
            assertionFailure("Can not remove reminder at index: \(index).\nIndex is out of range")
        }
    }
    
    func getReminders() -> [CoreDataReminder] {
        return self.coreDataReminder
    }

    // MARK: - Изменение напоминания по индексу

    func updateReminderAt(_ index: Int, reminder: Reminder) {
        if self.coreDataReminder.count > index {
            self.coreDataReminder[index].text = reminder.text
            self.coreDataReminder[index].uID = reminder.uID
            self.coreDataReminder[index].note = reminder.note
            self.coreDataReminder[index].url = reminder.url
            self.coreDataReminder[index].isDone = reminder.isDone
            self.coreDataReminder[index].date = reminder.date
            self.coreDataReminder[index].flag = reminder.flag
            self.coreDataReminder[index].photos = self.coreDataObjectFromPhotos(images: reminder.photos)
            self.coreDataReminder[index].photosURL = self.coreDataObjectFromPhotoURL(photoURL: reminder.photosURL)
            self.coreDataReminder[index].priority = reminder.priority?.rawValue
            do {
                try self.context.save()
            } catch {
                self.context.rollback()
                assertionFailure("Can not append reminder")
            }
        } else {
            self.appendReminder(reminder)
        }
    }
}

private extension CoreDataManager {
    func coreDataObjectFromPhotos(images: [UIImage?]) -> Data? {
        let dataArray = NSMutableArray()
        for img in images {
            if let img = img {
                if let data = img.pngData() {
                    dataArray.add(data)
                }
            }
        }
        return try? NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: true)
    }
    
    func coreDataObjectFromPhotoURL(photoURL: [URL]) -> Data? {
        let dataArray = NSMutableArray()
        
        for url in photoURL {
            let data = url.dataRepresentation
            dataArray.add(data)
        }
        return try? NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: true)
    }
}

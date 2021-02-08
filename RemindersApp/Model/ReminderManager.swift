//
//  ReminderManager.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/22/21.
//

import Foundation

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

    func updateTextForReminderAt(_ index: Int, text: String) {
        self.dataArray[index].text = text
    }

    func updateReminderAt(_ index: Int, reminder: Reminder) {
        self.dataArray[index] = reminder
    }

    func loadElements() {
        // TODO: - Загрузка из CoreData
    }

    func removeElement(atIndex index: Int) {
        self.dataArray.remove(at: index)
    }

    func saveReminderToCompleted(indexPath: IndexPath) {
        // TODO: - Сохранение в удаленные в CoreData
    }
}

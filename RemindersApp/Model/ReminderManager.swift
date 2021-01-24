//
//  ReminderManager.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/22/21.
//

import Foundation

final class ReminderManager {

    // MARK: Properties

    private var dataArray: [Reminder] = []

    // MARK: Methods

    func getDataArray() -> [Reminder] {
        return self.dataArray
    }

    func appendElement() {
        self.dataArray.append(Reminder())
    }

    func updateElement(atIndex index: Int, text: String) {
        self.dataArray[index].text = text
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

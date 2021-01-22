//
//  ReminderManager.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/22/21.
//

import Foundation

final class ReminderManager {

    private var dataArray: [String] = []

    static let shared = ReminderManager()

    func getDataArray() -> [String] {
        return self.dataArray
    }

    func appendElement() {
        self.dataArray.append("")
    }

    func updateElement(atIndex index: Int, text: String) {
        print("index", index)
        print("text", text)
        self.dataArray[index] = text
    }

    func loadElements() {
        // TODO: - Загрузка из CoreData
    }

    func removeElement(atIndex index: Int) {
        self.dataArray.remove(at: index)
    }
}

//
//  Filter.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 2/23/21.
//

import Foundation

final class Filter {
    func filterReminders(_ reminders: [Reminder],
                         isCompletedRemindersShowing: Bool) -> [Reminder] {
        return reminders.filter {
            if isCompletedRemindersShowing {
                return true
            } else {
                return $0.isDone == false
            }
        }
    }

    func getReminder(_ reminders: [Reminder],
                     isCompletedRemindersShowing: Bool,
                     atIndex index: Int) -> Reminder? {
        let filteredReminders = self.filterReminders(reminders,
                                                     isCompletedRemindersShowing: isCompletedRemindersShowing)
        if filteredReminders.count > index {
            return filteredReminders[index]
        } else {
            return nil
        }
    }

    func getReminderIndex(reminders: [Reminder],
                          reminderUID: String) -> Int? {
        var reminderIndex: Int? = nil
        for (index, reminder) in reminders.enumerated() {
            if reminder.uID == reminderUID {
                reminderIndex = index
            }
        }
        return reminderIndex
    }
}
